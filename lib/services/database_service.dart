// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

const String USER_COLLECTION = 'Users';
const String CHAT_COLLECTION = 'Chats';
const String MESSAGES_COLLECTION = 'Messages';

class DatabaseService {
  DatabaseService();
  final FirebaseFirestore _dataBase = FirebaseFirestore.instance;

  // Create User
  Future<void> createUser(
      String _uid, String _email, String _name, String _imageUrl) async {
    try {
      // * Going to the collections (User) the to the user uid and overrides the values of the fields
      await _dataBase.collection(USER_COLLECTION).doc(_uid).set(
        {
          'name': _name,
          'email': _email,
          'image': _imageUrl,
          'last_active': DateTime.now().toUtc(),
        },
      );
    } catch (error) {
      debugPrint('$error');
    }
  }

  // Getting the User from Firebase Cloud Store
  Future<DocumentSnapshot> getUser(String _uid) {
    return _dataBase.collection(USER_COLLECTION).doc(_uid).get();
  }

// Update time
  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _dataBase.collection(USER_COLLECTION).doc(_uid).update(
        {
          'last_active': DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      debugPrint('$e');
    }
  }
}
