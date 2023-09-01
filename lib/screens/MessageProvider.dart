import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProvider = StateNotifierProvider<MessageNotifier, List<ChatMessage>>(
  (ref) => MessageNotifier(),
);

class ChatMessage {
  final String message;
  final bool isByUser;
  ChatMessage(this.message, this.isByUser);
}

class MessageNotifier extends StateNotifier<List<ChatMessage>> {
  MessageNotifier() : super([]);

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }
}
