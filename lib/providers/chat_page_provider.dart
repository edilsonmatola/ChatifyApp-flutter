import 'dart:async';

// Packages
import 'package:chatifyapp/models/chat_message_model.dart';
import 'package:chatifyapp/models/chats_model.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

// Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';

// Providers
import '../providers/authentication_provider.dart';

// Models
import '../models/chat_user_model.dart';

class ChatPageProvider extends ChangeNotifier {
  ChatPageProvider(this._chatId, this._auth, this._messagesListViewController) {
    _database = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _navigation = GetIt.instance.get<NavigationService>();
  }

  late DatabaseService _database;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  AuthenticationProvider _auth;
  ScrollController _messagesListViewController;

  String _chatId;
  List<ChatMessage>? _messages;

  String? _message;

  String get message => _message as String;

  void goBack() {
    _navigation.goBack();
  }
}
