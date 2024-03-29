// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../../../authentication/application/authentication_provider_service.dart';
import '../../../authentication/widgets/widgets_export.dart';
import '../../application/user_screen_service/users_page_provider.dart';
import '../../contacts_export.dart';
import '../../widgets/custom_list_view_tiles.dart';
// Widgets
import '../../widgets/custom_top_bar.dart';

// Models

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late double _deviceWidth;
  late double _deviceHeight;

  late AuthenticationProviderService _auth;
  late UsersPageProvider _userPageProvider;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    _auth = Provider.of<AuthenticationProviderService>(context);
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
    return Builder(builder: (context) {
      _userPageProvider = context.watch<UsersPageProvider>();
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
              onEditingComplete: (value) {
                // TODO: Criar funcionalidade para fazer um search enquanto o user vai digitando e o valor aparece
                _userPageProvider.getUsers(name: value);
                FocusScope.of(context).unfocus();
              },
              hintText: 'Search...',
              obscureText: false,
              controller: _searchFieldTextEditingController,
              icon: Icons.search,
            ),
            _usersList(),
            _createChatOrGroupButton(),
          ],
        ),
      );
    });
  }

// * Render the chats of the users
  Widget _usersList() {
    List? users = _userPageProvider.users;
    return Expanded(
      child: () {
        if (users != null) {
          if (users.isNotEmpty) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomListViewTile(
                  height: _deviceHeight * .10,
                  title: users[index].name,
                  subtitle: 'Last Active: ${users[index].lastActive}',
                  imagePath: users[index].imageUrl,
                  isActive: users[index].wasRecentlyActive(),
                  isSelected: _userPageProvider.selectedUsers.contains(
                    users[index],
                  ),
                  onTap: () => _userPageProvider.updateSelectedUsers(
                    users[index],
                  ),
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

  // * Button to create group or chat with user
  Widget _createChatOrGroupButton() {
    return Visibility(
      visible: _userPageProvider
          .selectedUsers.isNotEmpty, // Apears at least 1 user is selected.
      child: CustomRoundedButtonWidget(
        name: _userPageProvider.selectedUsers.length == 1
            ? 'Chat with ${_userPageProvider.selectedUsers.first.name}'
            : 'Create Group Chat',
        width: _deviceWidth * .80,
        height: _deviceHeight * 08,
        onPress: () => _userPageProvider.createChat(),
      ),
    );
  }
}
