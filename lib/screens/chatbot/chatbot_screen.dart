import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController textController = TextEditingController();
  double? uploadPercent;

  @override
  Widget build(BuildContext context) {
    final String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No Email';
    final bool isAdmin = userEmail.contains("@admin");
    String encodedEmail = userEmail.replaceAll('.', '').replaceAll('@', '');
    final chatId = "UserChat" + encodedEmail;

    Future<void> uploadFile(Uint8List fileBytes, String type, String fileName) async {
      String filePath = '$chatId/${DateTime.now().millisecondsSinceEpoch}.$type';
      try {
        UploadTask task = FirebaseStorage.instance.ref(filePath).putData(fileBytes);

        task.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            uploadPercent = (snapshot.bytesTransferred.toDouble() / snapshot.totalBytes.toDouble());
          });
        });

        TaskSnapshot taskSnapshot = await task;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').add({
          'fileUrl': downloadURL,
          'fileName': fileName, // Added file name
          'fileType': type,
          'isByUser': !isAdmin,
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'file',
        });

        setState(() {
          uploadPercent = null; // Reset the upload percent
        });
      } catch (e) {
        print("An error occurred while uploading the file: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          uploadPercent != null ? LinearProgressIndicator(value: uploadPercent) : Container(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').orderBy('timestamp').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    if (data['type'] == 'text') {
                      return ListTile(
                        title: Text(data['text'] ?? 'Unknown'),
                        subtitle: Text(data['isByUser'] ? "You" : "Admin"),
                      );
                    } else if (data['type'] == 'file') {
                      String fileName = data['fileName'] ?? 'Unknown file'; // File Name
                      String fileUrl = data['fileUrl'] ?? '';
                      return ListTile(
                        title: Text(fileName),
                        subtitle: Text(data['isByUser'] ? "You" : "Admin"),
                        leading: Icon(Icons.attach_file),
                        onTap: () async {
                          if (await canLaunch(fileUrl)) {
                            await launch(fileUrl);
                          }
                        },
                        trailing: ElevatedButton(
                          onPressed: () async {
                            if (await canLaunch(fileUrl)) {
                              await launch(fileUrl);
                            }
                          },
                          child: Text("Download"),
                        ),
                      );
                    } else {
                      return ListTile(title: Text('Unknown Message Type'));
                    }
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'pdf', 'mp4', 'png'],
                    );
                    if (result != null) {
                      Uint8List fileBytes = result.files.first.bytes!;
                      String extension = result.files.single.extension!;
                      String fileName = result.files.single.name!;
                      uploadFile(fileBytes, extension, fileName);
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final text = textController.text;
                    textController.clear();
                    final messageCollection = FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages');
                    messageCollection.add({
                      'text': text,
                      'isByUser': !isAdmin,
                      'timestamp': FieldValue.serverTimestamp(),
                      'type': 'text',
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
