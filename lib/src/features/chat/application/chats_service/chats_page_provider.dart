import 'dart:async';

// Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Services

// Providers
import '../../../../application/firestore_database_service/database_service.dart';
import '../../../authentication/application/authentication_provider_service.dart';
// Models
import '../../../contacts/contacts_export.dart';
import '../../../groups/models/chats_model.dart';
import '../../models/chat_message_model.dart';

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
        (snapshot) async {
          chats = await Future.wait(
            snapshot.docs.map(
              (eachDoc) async {
                final chatData = eachDoc.data() as Map<String, dynamic>;
                // * Get users instance
                List<ChatUserModel> members = [];
                // * Looping through the members arry from Firebase
                for (var uid in chatData['members']) {
                  // * Getting the uid from each user
                  final userSnapshot = await _database.getUser(uid);
                  if (eachDoc.data() != null) {
                    //* Extracting the data from each user
                    final userData =
                        userSnapshot.data() as Map<String, dynamic>;
                    // * Acessing the user id
                    userData['uid'] = userSnapshot.id;
                    //* Adding to members list the user instance
                    members.add(
                      ChatUserModel.fromJson(
                        userData,
                      ),
                    );
                  }
                }
                // * Get Last Message For Chat
                List<ChatMessage> messages = [];
                // * Stoting the snapshot
                final chatMessage =
                    await _database.getLastMessageFroChat(eachDoc.id);
                if (chatMessage.docs.isNotEmpty) {
                  final messageData =
                      chatMessage.docs.first.data()! as Map<String, dynamic>;
                  final message = ChatMessage.fromJSON(messageData);
                  // * Adding each message in the messages array
                  messages.add(message);
                }
                // *Return chat instance
                return ChatsModel(
                  uid: eachDoc.id,
                  currentUserUid: _auth.user.uid,
                  activity: chatData['is_activity'],
                  group: chatData['is_group'],
                  members: members,
                  messages: messages,
                );
              },
            ).toList(),
          );
          notifyListeners();
        },
      );
    } catch (error) {
      Dialog(
        child: AlertDialog(
          content: Text('$error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
