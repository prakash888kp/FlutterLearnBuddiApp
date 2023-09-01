import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:learnBuddi/screens/admin/AdminReplyScreen.dart';
import 'package:learnBuddi/screens/admin/adminProfile_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController courseController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  File? file;
  String fileType = '';
  String fileName = '';

  Future<void> pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [type],
    );

    if (result != null) {
      file = File(result.files.single.path!);
      fileType = type;
      fileName = result.files.single.name;
      setState(() {});
    }
  }

  Future<void> uploadFile() async {
    if (file != null) {
      try {
        await FirebaseStorage.instance
            .ref('courses/${courseController.text}/$fileName')
            .putFile(file!);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Courses',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Fill the following details to add a new course.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: courseController,
                decoration: const InputDecoration(
                  hintText: "Course Name",
                  border: OutlineInputBorder(),
                  labelText: "Course Name",
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: costController,
                decoration: const InputDecoration(
                  hintText: "Cost (INR)",
                  border: OutlineInputBorder(),
                  labelText: "Cost",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection("courses").add({
                    "name": courseController.text,
                    "cost": costController.text,
                  });
                  await uploadFile();
                },
                child: const Text("Add Course"),
              ),
              const SizedBox(height: 30),
              const Text(
                'Add Related Materials and Contents',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Upload the course-related materials here.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => pickFile('pdf'),
                child: const Text("Pick PDF"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => pickFile('jpg'),
                child: const Text("Pick Image"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => pickFile('mp4'),
                child: const Text("Pick MP4"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble),
              onPressed: () 
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminReplyScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
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
    );
  }
}
