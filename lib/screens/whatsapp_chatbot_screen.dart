import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppChatbotScreen extends StatefulWidget {
  @override
  _WhatsAppChatbotScreenState createState() => _WhatsAppChatbotScreenState();
}

class _WhatsAppChatbotScreenState extends State<WhatsAppChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? _message;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  _sendMessage() async {
    String whatsappNumber = "whatsapp:+919876543210"; // Replace with admin's WhatsApp number
    String message = _message ?? "Hello, I need help!"; // Default message if _message is null

    String url = "https://api.whatsapp.com/send?phone=$whatsappNumber&text=$message";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not launch WhatsApp"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsApp Chatbot'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message here',
              ),
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send to WhatsApp'),
            ),
          ],
        ),
      ),
    );
  }
}
