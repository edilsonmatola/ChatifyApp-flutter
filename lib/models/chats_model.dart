import '../models/chat_user_model.dart';
import '../models/chat_message_model.dart';

class ChatsModel {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUserModel> members;
  List<ChatMessage> messages; //Not final because it might change

  late final List<ChatUserModel> _recepients;

  ChatsModel({
    required this.uid,
    required this.currentUserUid,
    required this.activity,
    required this.group,
    required this.members,
    required this.messages,
  }) {
    // * Excludes the member whom is currently logged in to the actual device
    _recepients = members.where((_i) => _i.uid != currentUserUid).toList();
  }

// Return the list of recipients
  List<ChatUserModel> recepients() {
    return _recepients;
  }

// Title of the chat
  String title() {
    //* True -> The list will contain one of the members inside of it
    //* False -> It is a group chat
    return !group
        ? _recepients.first.name
        : _recepients.map((_eachUser) => _eachUser.name).join(
            ', '); //* Return the name of the users each name separated by commas
  }

  // Group chat image
  String chatImageURL() {
    // * True ->  returns the user profileImage
    // * False -> returns an imageurl from the internet
    return !group ? _recepients.first.imageUrl : 'https://image.pngaaa.com/574/3863574-middle.png';
  }
}
