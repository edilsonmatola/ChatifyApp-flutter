// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/authentication_provider.dart';
import '../providers/chats_page_provider.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';

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
  late ChatsPageProvider _pageProvider;

  @override
  Widget build(BuildContext context) {
    // Responsive layout
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    _auth = Provider.of<AuthenticationProvider>(context);
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
    return Builder(builder: (_context) {
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
              'CHATS',
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
    });
  }

  // Build UI
  Widget _chatsList() {
    return Expanded(
      child: _chatTile(),
    );
  }

// Render the chat tile
  Widget _chatTile() {
    return CustomListViewTileWithActivity(
      height: _deviceHeight * .10,
      title: 'J. Cole',
      subtitle: 'Wassup dawg?',
      imagePath: 'https://i.pravatar.cc/300',
      isActive: false,
      isActivity: false,
      onTap: () {},
    );
  }
}
