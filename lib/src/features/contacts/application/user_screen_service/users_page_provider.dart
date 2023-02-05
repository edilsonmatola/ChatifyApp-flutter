// Packages
import 'package:chatifyapp/src/features/authentication/authentication_export.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../application/application_export.dart';
// Providers
import '../../../../application/firestore_database_service/database_service.dart';
import '../../../chat/chat_export.dart';
import '../../../groups/groups_export.dart';
import '../../contacts_export.dart';

// Models

// Pages

class UsersPageProvider extends ChangeNotifier {
  UsersPageProvider(this._auth) {
    _selectedUsers = [];
    _database = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  final AuthenticationProviderService _auth;

  late DatabaseService _database;
  late NavigationService _navigation;

  List<ChatUserModel>? users;
  late List<ChatUserModel> _selectedUsers;

  List<ChatUserModel> get selectedUsers => _selectedUsers;

// * Getting the users name from the Firebase
  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      _database.getUsers(name: name).then(
        (snapshot) {
          users = snapshot.docs.map(
            (eachDoc) {
              final data = eachDoc.data() as Map<String, dynamic>;
              data['uid'] = eachDoc.id;
              return ChatUserModel.fromJson(data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (error) {
      ScaffoldMessenger(
        child: SnackBar(
          content: Text(
            '$error',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
      // debugPrint('Error getting users');
      // debugPrint('$error');
    }
  }

  // * Select multiple Users
  void updateSelectedUsers(ChatUserModel user) {
    if (_selectedUsers.contains(user)) {
      _selectedUsers.remove(user);
    } else {
      _selectedUsers.add(user);
    }
    notifyListeners();
  }

  // * Create Group Or Individual chat in the Firestore database
  Future<void> createChat() async {
    try {
      final membersIds =
          _selectedUsers.map((eachUser) => eachUser.uid).toList();
      membersIds.add(_auth.user.uid);
      final isGroup = _selectedUsers.length > 1;
      final doc = await _database.createChat(
        {
          'is_group': isGroup,
          'is_activity': false,
          'members': membersIds,
        },
      );
      // * Navigate to chat page
      final membersOfChat = <ChatUserModel>[];
      for (var uid in membersIds) {
        final userSnapshot = await _database.getUser(uid);
        final userData = userSnapshot.data() as Map<String, dynamic>;
        userData['uid'] = userSnapshot.id;
        membersOfChat.add(
          ChatUserModel.fromJson(
            userData,
          ),
        );
      }
      final chatPage = ChatPage(
        chat: ChatsModel(
          uid: doc!.id,
          currentUserUid: _auth.user.uid,
          activity: false,
          group: isGroup,
          members: membersOfChat,
          messages: [],
        ),
      );
      _selectedUsers = [];
      notifyListeners();
      _navigation.navigateToPage(chatPage);
    } catch (error) {
      ScaffoldMessenger(
        child: SnackBar(
          content: Text(
            '$error',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
      // debugPrint('Error creating chat');
      // debugPrint('$error');
    }
  }
}
