// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/authentication_provider.dart';

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

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    _auth = Provider.of<AuthenticationProvider>(context);
    return _buildUI();
  }

  Widget _buildUI() {
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
  }

// * Render the chats of the users
  Widget _usersList() {
    return Expanded(
      child: () {
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext _context, int _index) {
            return CustomListViewTile(
              height: _deviceHeight * .10,
              title: 'User $_index',
              subtitle: 'Last Active',
              imagePath: 'https://i.pravatar.cc/300',
              isActive: false,
              isSelected: false,
              onTap: () {},
            );
          },
        );
      }(),
    );
  }
}
