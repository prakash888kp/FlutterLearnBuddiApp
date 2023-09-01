import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnBuddi/screens/chatbot/ChatMessage.dart';


class ChatService {
  final CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  Future<void> sendMessage(String chatId, ChatMessage message) async {
    await chats.doc(chatId).collection('messages').add({
      'text': message.text,
      'senderId': message.senderId,
      'isResolved': message.isResolved,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
  
  // Other methods like deleteMessage, resolveChat etc.
}
