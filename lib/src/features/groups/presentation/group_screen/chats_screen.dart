// Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../application/application_export.dart';
// Providers
import '../../../../core/constants/constants_export.dart';
import '../../../authentication/application/authentication_provider_service.dart';
import '../../../chat/chat_export.dart';
// Widgets
import '../../../contacts/contacts_export.dart';
import '../../../contacts/widgets/custom_list_view_tiles.dart';
import '../../../contacts/widgets/custom_top_bar.dart';
// Models
import '../../models/chats_model.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  // Required variables
  late double _deviceWidth;
  late double _deviceHeight;

  late AuthenticationProviderService _auth;
  late NavigationService _navigation;
  late ChatsPageProvider _pageProvider;

  @override
  Widget build(BuildContext context) {
    // Responsive layout
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    _auth = Provider.of<AuthenticationProviderService>(context);
    _navigation = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_auth),
        )
      ],
      child: Builder(
        builder: (context) {
          //* Triggers the info in the widgets to render themselves
          _pageProvider = context.watch<ChatsPageProvider>();
          return Container(
            width: _deviceWidth * .97,
            height: _deviceHeight * .98,
            padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * .03,
              vertical: _deviceHeight * .02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomTopBar(
                  'Chats',
                  primaryAction: IconButton(
                    onPressed: () {
                      // * Logout the user if he/she presses the button icon
                      _auth.logout();
                    },
                    icon: const Icon(
                      Icons.logout_outlined,
                      color: AppColors.appPrimaryIconColor,
                    ),
                  ),
                ),
                _chatsList(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Build UI
  Widget _chatsList() {
    List<ChatsModel>? chats = _pageProvider.chats;
    return Expanded(
      child: (() {
        if (chats != null) {
          if (chats.isNotEmpty) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                return _chatTile(
                  chats[index],
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No Chats Found.',
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
      })(),
    );
  }

//* Render the chat tile
  Widget _chatTile(ChatsModel chat) {
    // * Getting the users
    List<ChatUserModel> recepients = chat.recepients();
    // * Checking if each user is active or not
    bool isActive = recepients.any(
      (eachDoc) => eachDoc.wasRecentlyActive(),
    );
    var subtitleText = '';
    if (chat.messages.isNotEmpty) {
      //The chat may not have any messages when created
      subtitleText = chat.messages.first.type != MessageType.text
          ? 'Media Attachment'
          : chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      height: _deviceHeight * .10,
      title: chat.title(),
      subtitle: subtitleText,
      imagePath: chat.chatImageURL(),
      isActive: isActive,
      isActivity: chat.activity,
      onTap: () => _navigation.navigateToPage(
        ChatPage(chat: chat),
      ),
    );
  }
}
