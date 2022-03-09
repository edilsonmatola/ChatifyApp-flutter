// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

// Providers
import '../providers/authentication_provider.dart';

// Models
import '../models/chat_user_model.dart';
import '../models/chat_message_model.dart';

// Pages
import '../pages/chat_page.dart';

class UsersPageProvider extends ChangeNotifier {
  UsersPageProvider(this._auth) {
    _selectedUsers = [];
    _database = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  AuthenticationProvider _auth;

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
      // TODO: Return a scaffoldMessanger instead of debugPrint
      debugPrint('Error getting users');
      debugPrint('$error');
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
}
