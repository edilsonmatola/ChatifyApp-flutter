// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/authentication_provider.dart';
import '../providers/users_page_provider.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/rounded_button.dart';

// Models
import '../models/chat_user_model.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceWidth;
  late double _deviceHeight;

  late AuthenticationProvider _auth;
  late UsersPageProvider _userPageProvider;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (_context) {
      _userPageProvider = _context.watch<UsersPageProvider>();
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
              'Users',
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
            CustomTextField(
              onEditingComplete: (_value) {},
              hintText: 'Search...',
              obscureText: false,
              controller: _searchFieldTextEditingController,
              icon: Icons.search,
            ),
            _usersList(),
          ],
        ),
      );
    });
  }

// * Render the chats of the users
  Widget _usersList() {
    List<ChatUserModel>? _users = _userPageProvider.users;
    return Expanded(
      child: () {
        if (_users != null) {
          if (_users.isNotEmpty) {
            return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (BuildContext _context, int _index) {
                return CustomListViewTile(
                  height: _deviceHeight * .10,
                  title: _users[_index].name,
                  subtitle: 'Last Active: ${_users[_index].lastActive}',
                  imagePath: _users[_index].imageUrl,
                  isActive: _users[_index].wasRecentlyActive(),
                  isSelected: false,
                  onTap: () {},
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No users found',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
        } else {
          // TODO: Implement Shimmer loading effect or Tell the user to use that he/she doesn't have a list of users
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      }(),
    );
  }
}
