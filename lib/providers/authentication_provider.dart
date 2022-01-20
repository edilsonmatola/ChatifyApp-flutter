// Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

// Models
import 'package:chatifyapp/models/chat_user_model.dart';

class AuthenticationProvider extends ChangeNotifier {
  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    _auth.authStateChanges().listen(
      (_user) {
        if (_user != null) {
          _databaseService.updateUserLastSeenTime(_user.uid);
          _databaseService.getUser(_user.uid).then(
            (_snapshot) {
              Map<String, dynamic> _userData =
                  _snapshot.data()! as Map<String, dynamic>;
              user = ChatUserModel.fromJson(
                {
                  'uid': _user.uid,
                  'name': _userData['name'],
                  'email': _userData['email'],
                  'imageUrl': _userData['image'],
                  'last_active': _userData['last_active'],
                },
              );
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
      debugPrint('${_auth.currentUser}');
    } on FirebaseAuthException {
      debugPrint('Error login user into Firebase.');
    } catch (e) {
      debugPrint('$e');
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
      debugPrint('Error registering user.');
    } catch (error) {
      debugPrint('$error');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (error) {
      debugPrint('$error');
    }
  }
}
