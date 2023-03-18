import 'dart:io';

// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

const String userCollection = 'Users';

class CloudStorageService {
  CloudStorageService();

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> saveUserImageProfileToStorage(
      String uid, PlatformFile file) async {
    try {
      //* Referenciando a localizacao da pasta de imagens no firebase
      final reference =
          _firebaseStorage.ref('images/users/$uid/profile.${file.extension}');
      //* Uploading the image in the refered path
      UploadTask task = reference.putFile(
        File(file.path as String),
      );
      //* Returning the photo url
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
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

  Future<String?> saveChatImageToStorage(
    String chatID,
    String userID,
    PlatformFile file,
  ) async {
    try {
      final reference = _firebaseStorage.ref().child(
          'images/chats/$chatID/${userID}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}');

      //* Uploading the image in the refered path
      UploadTask task = reference.putFile(
        File(file.path as String),
      );

      //* Returning the photo url
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
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
