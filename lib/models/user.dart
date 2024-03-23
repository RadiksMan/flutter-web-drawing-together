import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String displayName;
  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
  });
}

class DrawUser {
  final String id;
  final String email;
  final String displayName;
  final String? lastActivity;
  final Map<String, dynamic>? content;

  factory DrawUser.createNewUser(
    UserModel usr,
  ) {
    return DrawUser(
      id: usr.id,
      email: usr.email,
      displayName: usr.displayName,
      content: {},
      lastActivity: DateTime.now().toString(),
    );
  }

  DrawUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.lastActivity,
    this.content = const {},
  });

  DrawUser.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        email = json['email'] as String,
        lastActivity = json['lastActivity'] as String,
        content = jsonDecode(json['content'] ?? '{}') as Map<String, dynamic>,
        displayName = json['displayName'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'lastActivity': lastActivity,
        'content': content,
      };
}
