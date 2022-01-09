class ChatUserModel {
  ChatUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.lastActive,
  });

  final String id;
  final String name;
  final String email;
  final String imageUrl;
  late DateTime lastActive;

  factory ChatUserModel.fromJson(Map<String, dynamic> _json) {
    return ChatUserModel(
      id: _json['uid'],
      name: _json['name'],
      email: _json['email'],
      imageUrl: _json['image'],
      lastActive: _json['last_active'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
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
