// Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/authentication_provider.dart';
import '../providers/chats_page_provider.dart';

// Services
import '../services/navigation_service.dart';

// Pages
import '../pages/chat_page.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';

// Models
import '../models/chats_model.dart';
import 'package:chatifyapp/models/chat_user_model.dart';
import 'package:chatifyapp/models/chat_message_model.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  // Required variables
  late double _deviceWidth;
  late double _deviceHeight;

  late AuthenticationProvider _auth;
  late NavigationService _navigation;
  late ChatsPageProvider  _pageProvider;

  @override
  Widget build(BuildContext context) {
    // Responsive layout
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_auth),
        )
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (_context) {
        //* Triggers the info in the widgets to render themselves
        _pageProvider = _context.watch<ChatsPageProvider>();
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
              TopBar(
                'Chats',
                primaryAction: IconButton(
                  onPressed: () {
                    // * Logout the user if he/she presses the button icon
                    _auth.logout();
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: Color.fromRGBO(0, 82, 218, 1),
                  ),
                ),
              ),
              _chatsList(),
            ],
          ),
        );
      },
    );
  }

  // Build UI
  Widget _chatsList() {
    List<ChatsModel>? _chats = _pageProvider.chats;
    return Expanded(
      child: (() {
        if (_chats != null) {
          if (_chats.isNotEmpty) {
            return ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (BuildContext _context, int _index) {
                return _chatTile(
                  _chats[_index],
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
  Widget _chatTile(ChatsModel _chat) {
    // * Getting the users
    List<ChatUserModel> _recepients = _chat.recepients();
    // * Checking if each user is active or not
    bool _isActive = _recepients.any(
      (_eachDoc) => _eachDoc.wasRecentlyActive(),
    );
    var _subtitleText = '';
    if (_chat.messages.isNotEmpty) {
      //The chat may not have any messages when created
      _subtitleText = _chat.messages.first.type != MessageType.text
          ? 'Media Attachment'
          : _chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      height: _deviceHeight * .10,
      title: _chat.title(),
      subtitle: _subtitleText,
      imagePath: _chat.chatImageURL(),
      isActive: _isActive,
      isActivity: _chat.activity,
      onTap: () => _navigation.navigateToPage(
        ChatPage(chat: _chat),
      ),
    );
  }
}
