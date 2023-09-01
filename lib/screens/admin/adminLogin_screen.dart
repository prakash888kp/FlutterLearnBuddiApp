import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learnBuddi/screens/admin/admin_screen.dart';
import 'package:learnBuddi/screens/onboarding_screen.dart';  // Import your Onboarding Screen here

final authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

class AdminLoginScreen extends ConsumerWidget {
  final TextEditingController adminEmailController = TextEditingController();
  final TextEditingController adminPasswordController = TextEditingController();
  final GlobalKey<FormState> _adminFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final auth = watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Admin Login"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _adminFormKey,
          child: ListView(
            children: [
              // Logo
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 50.0),
                  child: ClipOval(
                    child: Image.asset('lib/media/logo.png', width: 150, height: 150, fit: BoxFit.cover),
                  ),
                ),
              ),
              // Email Input
              TextFormField(
                controller: adminEmailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Admin Email",
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || !value.contains("@admin.com")) {
                    return "Please enter a valid admin email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Password Input
              TextFormField(
                controller: adminPasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Admin Password",
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Password must be at least 6 characters long";
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // Admin Login Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  if (_adminFormKey.currentState?.validate() ?? false) {
                    try {
                      UserCredential userCredential = await auth.signInWithEmailAndPassword(
                        email: adminEmailController.text,
                        password: adminPasswordController.text,
                      );
                      // Navigate to Admin Screen
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminScreen()));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to login as admin: $e")),
                      );
                    }
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.userShield, color: Colors.white),
                    SizedBox(width: 15),
                    Text("Admin Login", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Go back to Intro Page Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  textStyle: const TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                    SizedBox(width: 15),
                    Text("Go back to Intro Page", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
