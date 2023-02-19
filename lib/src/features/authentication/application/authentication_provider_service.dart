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
            (snapshot) {
              // * Check if the documentSnapshot exists or not.
              if (snapshot.exists) {
                final userData = snapshot.data() as Map<String, dynamic>;
                //* Check if the document object is null or not
                if (snapshot.data() != null) {
                  user = ChatUserModel.fromJson(
                    {
                      'uid': _user.uid,
                      'name': userData['name'],
                      'email': userData['email'],
                      'image': userData['image'],
                      'last_active': userData['last_active'],
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

  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  late ChatUserModel user;

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
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
    String email,
    String password,
  ) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credentials.user!.uid;
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
