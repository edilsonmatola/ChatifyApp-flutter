import 'dart:async';

// Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Services

// Providers
import '../../../../application/firestore_database_service/database_service.dart';
import '../../../authentication/application/authentication_provider_service.dart';

// Models
import '../../../contacts/contacts.dart';
import '../../models/chat_message_model.dart';
import '../../../groups/models/chats_model.dart';

class ChatsPageProvider extends ChangeNotifier {
  ChatsPageProvider(this._auth) {
    _database = GetIt.I.get<DatabaseService>();
    getChats();
  }
  final AuthenticationProviderService _auth;

  late DatabaseService _database;

  List<ChatsModel>? chats;

  late StreamSubscription _chatsStream;

// * Once not longer needed, it will be disposed
  @override
  void dispose() {
    super.dispose();
    _chatsStream.cancel();
  }

//* Getting the chats
  void getChats() async {
    try {
      _chatsStream = _database.getChatsForsUser(_auth.user.uid).listen(
        (_snapshot) async {
          chats = await Future.wait(
            _snapshot.docs.map(
              (_eachDoc) async {
                final _chatData = _eachDoc.data() as Map<String, dynamic>;
                // * Get users instance
                List<ChatUserModel> _members = [];
                // * Looping through the members arry from Firebase
                for (var _uid in _chatData['members']) {
                  // * Getting the uid from each user
                  final _userSnapshot = await _database.getUser(_uid);
                  if (_eachDoc.data() != null) {
                    //* Extracting the data from each user
                    final _userData =
                        _userSnapshot.data() as Map<String, dynamic>;
                    // * Acessing the user id
                    _userData['uid'] = _userSnapshot.id;
                    //* Adding to members list the user instance
                    _members.add(
                      ChatUserModel.fromJson(
                        _userData,
                      ),
                    );
                  }
                }
                // * Get Last Message For Chat
                List<ChatMessage> _messages = [];
                // * Stoting the snapshot
                final _chatMessage =
                    await _database.getLastMessageFroChat(_eachDoc.id);
                if (_chatMessage.docs.isNotEmpty) {
                  final _messageData =
                      _chatMessage.docs.first.data()! as Map<String, dynamic>;
                  final _message = ChatMessage.fromJSON(_messageData);
                  // * Adding each message in the messages array
                  _messages.add(_message);
                }
                // *Return chat instance
                return ChatsModel(
                  uid: _eachDoc.id,
                  currentUserUid: _auth.user.uid,
                  activity: _chatData['is_activity'],
                  group: _chatData['is_group'],
                  members: _members,
                  messages: _messages,
                );
              },
            ).toList(),
          );
          notifyListeners();
        },
      );
    } catch (error) {
      debugPrint('Error getting chats.');
      debugPrint('$error');
    }
  }
}
