import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  unknown,
}

class ChatMessage {
  final String senderID;
  final MessageType type;
  final String content;
  final DateTime sentTime;

  ChatMessage({
    required this.senderID,
    required this.type,
    required this.content,
    required this.sentTime,
  });

// Fecth Json data
  factory ChatMessage.fromJSON(Map<String, dynamic> json) {
    final MessageType messageType;
    switch (json['type']) {
      case 'text':
        messageType = MessageType.text;
        break;
      case 'image':
        messageType = MessageType.image;
        break;
      default:
        messageType = MessageType.unknown;
    }
    return ChatMessage(
      senderID: json['sender_id'],
      type: messageType,
      content: json['content'],
      sentTime: json['sent_time'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    final String messageType;
    switch (type) {
      case MessageType.text:
        messageType = 'text';
        break;
      case MessageType.image:
        messageType = 'image';
        break;
      default:
        messageType = '';
    }
    return {
      'content': content,
      'type': messageType,
      'sender_id': senderID,
      'sent_time': Timestamp.fromDate(sentTime),
    };
  }
}
