class ChatUserModel {
  ChatUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.lastActive,
  });

  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  late DateTime lastActive;

  factory ChatUserModel.fromJson(Map<String, dynamic> _json) {
    return ChatUserModel(
      uid: _json['uid'],
      name: _json['name'],
      email: _json['email'],
      imageUrl: _json['imageUrl'],
      lastActive: _json['last_active'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'lastActive': lastActive,
    };
  }

  String lastDayActive() {
    return '${lastActive.month}/${lastActive.day}/${lastActive.year}';
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}
