import 'package:flutter/material.dart';

class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final bool isResolved;

  ChatMessage(this.id, this.text, this.senderId, this.isResolved);

  // You might want to add methods like toJson() and fromJson() for database operations.
}
