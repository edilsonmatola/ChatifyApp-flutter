// Packages
import 'package:chatifyapp/providers/chat_page_provider.dart';
import 'package:chatifyapp/widgets/custom_input_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';

// Models
import '../models/chats_model.dart';

// Providers
import '../providers/authentication_provider.dart';
import '../providers/chat_page_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.chat}) : super(key: key);

  final ChatsModel chat;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceWidth;
  late double _deviceHeight;

  late AuthenticationProvider _auth;
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
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
            widget.chat.uid,
            _auth,
            _messagesListViewController,
          ),
        )
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (_context) {
        _pageProvider = _context.watch<ChatPageProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: _deviceWidth * .03,
                  vertical: _deviceHeight * .02),
              width: _deviceWidth,
              height: _deviceHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopBar(
                    widget.chat.title(),
                    fontSize: 16,
                    primaryAction: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromRGBO(0, 82, 218, 1),
                      ),
                    ),
                    secondaryAction: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color.fromRGBO(0, 82, 218, 1),
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
    );
  }

// * Rendenring Messages from Firebase
  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.isNotEmpty) {
        return SizedBox(
          height: _deviceHeight * .74,
          child: ListView.builder(
            itemCount: _pageProvider.messages!.length,
            itemBuilder: (BuildContext _context, int _index) {
              final _message = _pageProvider.messages![_index];
              final _isOwnMessage = _message.senderID == _auth.user.uid;
              return CustomChatListViewTile(
                width: _deviceWidth * .80,
                deviceHeight: _deviceHeight,
                isOwnMessage: _isOwnMessage,
                message: _message,
                sender: widget.chat.members
                    .where((element) => element.uid == _message.senderID)
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
        color: const Color.fromRGBO(30, 29, 37, 1),
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
        onSaved: (_value) => _pageProvider.message = _value,
        regularExpression: r"^(?!\s*$).+",
        hintText: 'Type a message',
        obscureText: false,
      ),
    );
  }

  // * Send Message Button
  Widget _sendMessageButton() {
    double _size = _deviceHeight * .04;
    return SizedBox(
      width: _size,
      height: _size,
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
    double _size = _deviceHeight * .04;
    return SizedBox(
      width: _size,
      height: _size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 82, 218, 1),
        onPressed: () {},
        child: const Icon(
          Icons.camera_alt,
        ),
      ),
    );
  }
}
