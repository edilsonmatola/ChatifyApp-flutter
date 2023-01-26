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
        (_snapshot) {
          users = _snapshot.docs.map(
            (_eachDoc) {
              final _data = _eachDoc.data() as Map<String, dynamic>;
              _data['uid'] = _eachDoc.id;
              return ChatUserModel.fromJson(_data);
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
  void updateSelectedUsers(ChatUserModel _user) {
    if (_selectedUsers.contains(_user)) {
      _selectedUsers.remove(_user);
    } else {
      _selectedUsers.add(_user);
    }
    notifyListeners();
  }

  // * Create Group Or Individual chat in the Firestore database
  Future<void> createChat() async {
    try {
      final _membersIds =
          _selectedUsers.map((_eachUser) => _eachUser.uid).toList();
      _membersIds.add(_auth.user.uid);
      final _isGroup = _selectedUsers.length > 1;
      final _doc = await _database.createChat(
        {
          'is_group': _isGroup,
          'is_activity': false,
          'members': _membersIds,
        },
      );
      // * Navigate to chat page
      final _membersOfChat = <ChatUserModel>[];
      for (var _uid in _membersIds) {
        final _userSnapshot = await _database.getUser(_uid);
        final _userData = _userSnapshot.data() as Map<String, dynamic>;
        _userData['uid'] = _userSnapshot.id;
        _membersOfChat.add(
          ChatUserModel.fromJson(
            _userData,
          ),
        );
      }
      final _chatPage = ChatPage(
        chat: ChatsModel(
          uid: _doc!.id,
          currentUserUid: _auth.user.uid,
          activity: false,
          group: _isGroup,
          members: _membersOfChat,
          messages: [],
        ),
      );
      _selectedUsers = [];
      notifyListeners();
      _navigation.navigateToPage(_chatPage);
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
