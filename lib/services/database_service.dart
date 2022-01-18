// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

const String USER_COLLECTION = 'Users';
const String CHAT_COLLECTION = 'Chats';
const String MESSAGES_COLLECTION = 'Messages';

class DatabaseService {
  DatabaseService();
  final FirebaseFirestore _dataBase = FirebaseFirestore.instance;

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
