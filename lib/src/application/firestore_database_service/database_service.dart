// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Models
import '../../features/chat/models/chat_message_model.dart';

const String userCollection = 'Users';
const String chatCollection = 'Chats';
const String messagesCollection = 'Messages';

class DatabaseService {
  DatabaseService();
  final FirebaseFirestore _dataBase = FirebaseFirestore.instance;

  // Create User
  Future<void> createUser(
      String uid, String email, String name, String imageUrl) async {
    try {
      // * Going to the collections (User) the to the user uid and overrides the values of the fields
      await _dataBase.collection(userCollection).doc(uid).set(
        {
          'name': name,
          'email': email,
          'image': imageUrl,
          'last_active': DateTime.now().toUtc(),
        },
      );
    } catch (error) {
      debugPrint('$error');
    }
  }

  //* Getting the User from Firebase Cloud Store
  Future<DocumentSnapshot> getUser(String uid, {String? name}) {
    return _dataBase.collection(userCollection).doc(uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query query = _dataBase.collection(userCollection);
    if (name != null) {
      query = query.where('name', isGreaterThanOrEqualTo: name).where(
            'name',
            isLessThanOrEqualTo: '${name}z',
          );
    }
    return query.get();
  }

//* Getting the chats from the users
  Stream<QuerySnapshot> getChatsForsUser(String uid) {
    return _dataBase
        .collection(chatCollection)
        .where(
          'members',
          arrayContains: uid,
        )
        .snapshots();
  }

  //* Update to the last chat sent
  Future<QuerySnapshot> getLastMessageFroChat(String chatID) {
    return _dataBase
        .collection(chatCollection)
        .doc(chatID)
        .collection(messagesCollection)
        .orderBy(
          'sent_time',
          descending: true,
        )
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChatPage(String chatId) {
    return _dataBase
        .collection(chatCollection)
        .doc(chatId)
        .collection(messagesCollection)
        .orderBy('sent_time', descending: false)
        .snapshots();
  }

  // * Add messages to the firestore databse
  Future<void> addMessagesToChat(String chatId, ChatMessage message) async {
    try {
      await _dataBase
          .collection(chatCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .add(
            message.toJson(),
          );
    } catch (error) {
      SnackBar(
        content: Text('$error'),
      );
    }
  }

  Future<void> updateChatData(String chatId, Map<String, dynamic> data) async {
    try {
      await _dataBase.collection(chatCollection).doc(chatId).update(data);
    } catch (error) {
      debugPrint('$error');
    }
  }

//* Update time
  Future<void> updateUserLastSeenTime(String uid) async {
    try {
      await _dataBase.collection(userCollection).doc(uid).update(
        {
          'last_active': DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      Dialog(
        child: AlertDialog(
          content: Text('$e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // *Delete chat
  Future<void> deleteChat(String chatId) async {
    try {
      await _dataBase.collection(chatCollection).doc(chatId).delete();
    } catch (error) {
      Dialog(
        child: AlertDialog(
          content: Text('$error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// * Select and Create chat
  Future<DocumentReference?> createChat(Map<String, dynamic> data) async {
    try {
      final chat = await _dataBase.collection(chatCollection).add(data);
      return chat;
    } catch (error) {
     Dialog(
        child: AlertDialog(
          content: Text('$error'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }
}
