import 'dart:convert';

import 'package:flutter/material.dart';

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
  final String color;
  final String? lastActivity;
  final Map<String, dynamic>? content;

  factory User.createNewUser(
    RawUserModel usr,
  ) {
    return User(
      id: usr.id,
      email: usr.email,
      displayName: usr.displayName,
      color: () {
        final randomColor = ([...Colors.primaries]..shuffle()).first;
        return '#${randomColor.value.toRadixString(16).padLeft(8, '0')}';
      }(),
      content: {},
      lastActivity: DateTime.now().toString(),
    );
  }

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.color,
    this.lastActivity,
    this.content = const {},
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        email = json['email'] as String,
        lastActivity = json['lastActivity'] as String,
        color = json['color'] as String,
        content = jsonDecode(json['content'] ?? '{}') as Map<String, dynamic>,
        displayName = json['displayName'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'color': color,
        'lastActivity': lastActivity,
        'content': content,
      };
}
