import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:learnBuddi/screens/admin/adminProfile_screen.dart';
import 'package:learnBuddi/screens/admin/admin_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AdminReplyScreen extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Reply Screen"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Text("No data found");
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final chatId = doc.id;
              return ListTile(
                title: Text(chatId),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminChatDetailScreen(chatId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                     builder: (context) => AdminScreen(),
                    ),
                  );
                  },
                ),
                GButton(
                  icon: Icons.message,
                  text: 'Messages',
                  onPressed: () {
                    // Your onPressed code for Messages tab
                  },
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                 onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                     builder: (context) => AdminProfileScreen(),
                    ),
                  );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminChatDetailScreen extends StatefulWidget {
  final String chatId;
  AdminChatDetailScreen(this.chatId);
  @override
  _AdminChatDetailScreenState createState() => _AdminChatDetailScreenState();
}

class _AdminChatDetailScreenState extends State<AdminChatDetailScreen> {
  final TextEditingController adminReplyController = TextEditingController();

  Future<void> uploadFile(Uint8List fileBytes, String type) async {
    String filePath = '${widget.chatId}/${DateTime.now().millisecondsSinceEpoch}.$type';
    try {
      await FirebaseStorage.instance.ref(filePath).putData(
        fileBytes,
        SettableMetadata(contentType: type),
      ).then((taskSnapshot) async {
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        FirebaseFirestore.instance.collection('chats').doc(widget.chatId).collection('messages').add({
          'fileUrl': downloadUrl,
          'fileType': type,
          'isByUser': false,
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'file',
        });
      });
    } catch (e) {
      print("An error occurred while uploading the file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Details for ${widget.chatId}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chats').doc(widget.chatId).collection('messages').orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return ListView(
  children: snapshot.data!.docs.map((DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    if (data['type'] == 'file') {
      String? fileType = data['fileType'];
      String? fileUrl = data['fileUrl'];

      return ListTile(
        leading: Icon(Icons.file_present),
        title: Text(fileType ?? 'Unknown type'),
        subtitle: Text(data['isByUser'] ? "User" : "Admin"),
        onTap: () async {
          if (fileUrl != null && await canLaunch(fileUrl)) {
            await launch(fileUrl);
          } else {
            throw 'Could not launch $fileUrl';
          }
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (fileUrl != null && await canLaunch(fileUrl)) {
                  await launch(fileUrl);
                }
              },
              child: Text("View"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
  onPressed: () async {
    if (fileUrl != null && await canLaunch(fileUrl)) {
      await launch(fileUrl);
    }
  },
  child: Text("Download"),
),
          ],
        ),
      );
    } else {
      String text = data['text'] ?? 'No text';
      return ListTile(
        title: Text(text),
        subtitle: Text(data['isByUser'] ? "User" : "Admin"),
      );
    }
  }).toList(),
);



              },
            ),
          ),
          Row(
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
                    uploadFile(fileBytes, extension);
                  }
                },
              ),
              Expanded(
                child: TextField(
                  controller: adminReplyController,
                  decoration: InputDecoration(hintText: "Admin Reply",border: InputBorder.none,),
                  
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  FirebaseFirestore.instance.collection('chats').doc(widget.chatId).collection('messages').add({
                    'text': adminReplyController.text,
                    'isByUser': false,
                    'timestamp': FieldValue.serverTimestamp(),
                    'type': 'text',
                  });
                  adminReplyController.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}