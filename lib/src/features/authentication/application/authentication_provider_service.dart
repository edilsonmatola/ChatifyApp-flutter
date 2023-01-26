import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../application/application_export.dart';
import '../../../application/firestore_database_service/database_service.dart';
import '../../contacts/contacts_export.dart';

class AuthenticationProviderService extends ChangeNotifier {
  AuthenticationProviderService() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    _auth.authStateChanges().listen(
      (_user) {
        if (_user != null) {
          _databaseService.updateUserLastSeenTime(_user.uid);
          _databaseService.getUser(_user.uid).then(
            (_snapshot) {
              // * Check if the documentSnapshot exists or not.
              if (_snapshot.exists) {
                final _userData = _snapshot.data() as Map<String, dynamic>;
                //* Check if the document object is null or not
                if (_snapshot.data() != null) {
                  user = ChatUserModel.fromJson(
                    {
                      'uid': _user.uid,
                      'name': _userData['name'],
                      'email': _userData['email'],
                      'image': _userData['image'],
                      'last_active': _userData['last_active'],
                    },
                  );
                }
              }
              //* Automatic navigates to the home page
              _navigationService.removeAndNavigateToRoute('/home');
            },
          );
        } else {
          // * In case the user is not null (exists), then the user must login
          _navigationService.removeAndNavigateToRoute('/login');
        }
      },
    );
  }
// TODO: Increase the size of the Chat Tile

//TODO: Swipe left or right to navigate through pages

//TODO: Change Icons and Inovate the app

// TODO: Add the messanger sender name on the group chat  and while it is typing

// TODO: Use scaffoldMessanger to show the error logs, instead of debugPrint

  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  late ChatUserModel user;

  Future<void> loginUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      // TODO: Error snackbar

      debugPrint('${_auth.currentUser}');
    } on FirebaseAuthException {
      const ScaffoldMessenger(
        child: SnackBar(
          content: Text(
            'Error loging user into Firebase. Please try again later',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
      // debugPrint('Error login user into Firebase.');
    } catch (e) {
      ScaffoldMessenger(
        child: SnackBar(
          content: Text(
            '$e',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  //* Register user in the firebase
  Future<String?> registerUserUsingEmailAndPassword(
    String _email,
    String _password,
  ) async {
    try {
      UserCredential _credentials = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      return _credentials.user!.uid;
    } on FirebaseAuthException {
      const ScaffoldMessenger(
        child: SnackBar(
          content: Text(
            'Error registering user. Please try again later',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
      // debugPrint('Error registering user.');
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

      // debugPrint('$error');
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
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
      // debugPrint('$error');
    }
  }
}
