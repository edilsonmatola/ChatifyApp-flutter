import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constants_export.dart';
import '../../../authentication/authentication_export.dart';
import '../../../contacts/widgets/widgets_export.dart';
import '../../../groups/groups_export.dart';
import '../../chat_export.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.chat}) : super(key: key);

  final ChatsModel chat;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceWidth;
  late double _deviceHeight;

  late AuthenticationProviderService _auth;
  late ChatPageProvider _pageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    // * Initializations
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    _auth = Provider.of<AuthenticationProviderService>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
            widget.chat.uid,
            _auth,
            _messagesListViewController,
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          _pageProvider = context.watch<ChatPageProvider>();
          return Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _deviceWidth * .03,
                  vertical: _deviceHeight * .02,
                ),
                width: _deviceWidth,
                height: _deviceHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTopBar(
                      widget.chat.title(),
                      fontSize: 16,
                      primaryAction: IconButton(
                        onPressed: () {
                          _pageProvider.deleteChat();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.appPrimaryIconColor,
                        ),
                      ),
                      secondaryAction: IconButton(
                        onPressed: () {
                          _pageProvider.goBack();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.appPrimaryIconColor,
                        ),
                      ),
                    ),
                    _messagesListView(),
                    _sendMessageForm(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// * Rendenring Messages from Firebase
  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.isNotEmpty) {
        return SizedBox(
          height: _deviceHeight * .74,
          child: ListView.builder(
            controller: _messagesListViewController,
            itemCount: _pageProvider.messages!.length,
            itemBuilder: (BuildContext context, int index) {
              final message = _pageProvider.messages![index];
              final isOwnMessage = message.senderID == _auth.user.uid;
              return CustomChatListViewTile(
                width: _deviceWidth * .80,
                deviceHeight: _deviceHeight,
                isOwnMessage: isOwnMessage,
                message: message,
                sender: widget.chat.members
                    .where((element) => element.uid == message.senderID)
                    .first,
              );
            },
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            'Be the first to send a message!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * .06,
      decoration: BoxDecoration(
        color: AppColors.appSecondaryBackgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * .04,
        vertical: _deviceHeight * .03,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _sendImageButton(),
          ],
        ),
      ),
    );
  }

//* Text Field to compose the message
  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * .65,
      child: CustomTextFormField(
        onSaved: (value) => _pageProvider.message = value,
        validator: (message) => r"^(?!\s*$).+",
        hintText: 'Type a message',
        isSecret: false,
      ),
    );
  }

  // * Send Message Button
  Widget _sendMessageButton() {
    double size = _deviceHeight * .04;
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _pageProvider.sendTextMessage();
            // Reset the field after sending the message
            _messageFormState.currentState!.reset();
          }
        },
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }

  // * Send Image Button
  Widget _sendImageButton() {
    double size = _deviceHeight * .04;
    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        backgroundColor: AppColors.appPrimaryIconColor,
        onPressed: () => _pageProvider.sendImageMessage(),
        child: const Icon(
          Icons.camera_alt,
          color: AppColors.appPrimaryIconColor,
        ),
      ),
    );
  }
}
