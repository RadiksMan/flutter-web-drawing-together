import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class RawUserModel {
  final String id;
  final String email;
  final String displayName;
  RawUserModel({
    required this.id,
    required this.email,
    required this.displayName,
  });
}

class User {
  final String id;
  final String email;
  final String displayName;
  final Color color;
  final String? lastActivity;

  factory User.createNewUser(
    RawUserModel usr,
  ) {
    return User(
      id: usr.id,
      email: usr.email,
      displayName: usr.displayName,
      color: () {
        return RandomColor().randomColor(colorBrightness: ColorBrightness.light);
      }(),
      lastActivity: DateTime.now().toString(),
    );
  }

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.color,
    this.lastActivity,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        email = json['email'] as String,
        lastActivity = json['lastActivity'] as String,
        color = Color(int.parse(json['color'] ?? Colors.pink.value.toString())).withOpacity(1),
        displayName = json['displayName'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'color': color.value.toString(),
        'lastActivity': lastActivity,
      };
}
