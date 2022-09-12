import 'dart:async';

// Packages
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';


// Providers
import '../../../../application/firestore_database_service/database_service.dart';
import '../../../../application/application_export.dart';
import '../../../authentication/application/authentication_provider_service.dart';
import '../../chat.dart';

// Models

class ChatPageProvider extends ChangeNotifier {
  ChatPageProvider(
    this._chatId,
    this._auth,
    this._messagesListViewController,
  ) {
    _database = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  late DatabaseService _database;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  final AuthenticationProviderService _auth;
  final ScrollController _messagesListViewController;

  final String _chatId;
  List<ChatMessage>? messages;

  late StreamSubscription _messagesStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  String? _message;

  String get message => _message as String;

  set message(String _value) => _message = _value;

  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  void listenToMessages() {
    try {
      _messagesStream = _database.streamMessagesForChatPage(_chatId).listen(
        (_snapshot) {
          List<ChatMessage> _messages = _snapshot.docs.map(
            (_message) {
              final messageData = _message.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(messageData);
            },
          ).toList();
          messages = _messages;
          notifyListeners();
          // * Go to the last sent message
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_messagesListViewController.hasClients) {
              _messagesListViewController.jumpTo(
                _messagesListViewController.position.maxScrollExtent,
              );
            }
          });
        },
      );
    } catch (error) {
      debugPrint('$error');
    }
  }

// * User Typing activity listening to the keyboard
  void listenToKeyboardChanges() {
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen(
      (_event) {
        _database.updateChatData(
          _chatId,
          {'is_activity': _event},
        );
      },
    );
  }

  //* =============== Media Type messages =======================

  // * TEXT messages
  void sendTextMessage() {
    if (_message != null) {
      final _messageToSend = ChatMessage(
        senderID: _auth.user.uid,
        type: MessageType.text,
        content: _message!,
        sentTime: DateTime.now(),
      );
      _database.addMessagesToChat(_chatId, _messageToSend);
    }
  }

  // * IMAGE messages
  void sendImageMessage() async {
    try {
      final _file = await _media.pickImageFromLibrary();
      if (_file != null) {
        final downloadUrl = await _storage.saveChatImageToStorage(
          _chatId,
          _auth.user.uid,
          _file,
        );
        final _messageToSend = ChatMessage(
          senderID: _auth.user.uid,
          type: MessageType.image,
          content: downloadUrl!,
          sentTime: DateTime.now(),
        );
        _database.addMessagesToChat(_chatId, _messageToSend);
      }
    } catch (error) {
      debugPrint('$error');
    }
  }

  //* Delete chats
  void deleteChat() {
    goBack();
    _database.deleteChat(_chatId);
  }

// * Go Back to previous screen
  void goBack() {
    _navigation.goBack();
  }
}
