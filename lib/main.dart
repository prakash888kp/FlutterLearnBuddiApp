import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnBuddi/screens/MessageProvider.dart';
import 'package:learnBuddi/screens/admin/admin_screen.dart';
import 'package:learnBuddi/screens/chatbot/chatbot_screen.dart';
import 'package:learnBuddi/screens/forgotPassword_screen.dart';
import 'package:learnBuddi/screens/home_screen.dart';
import 'package:learnBuddi/screens/login_screen.dart';
import 'package:learnBuddi/screens/onboarding_screen.dart';
import 'package:learnBuddi/screens/profile_screen.dart';
import 'package:learnBuddi/screens/register_screen.dart';
import 'package:learnBuddi/screens/search_screen.dart';
import 'package:learnBuddi/screens/signup_screen.dart';
import 'package:learnBuddi/screens/whatsapp_chatbot_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:xxx:android:xxx',
      apiKey: 'xxx',
      authDomain: "xxx-xxx.firebaseapp.com",
      storageBucket: "xxx-xxxadx33x.appspot.com",
      databaseURL: "https://xxx-xx-xxx-xxx.firebaseio.com",
      projectId: 'xxx-xxxx',
      messagingSenderId: 'xxxx',
      measurementId: "G-xxxx"
    ),
  );
  await Permission.storage.request();
  await Permission.mediaLibrary.request();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/whatsapp_chatbot': (context) => WhatsAppChatbotScreen(),
        '/profile': (context) => ProfileScreen(),
        '/admin': (context) => AdminScreen(),
        '/chatbot':(context) => ChatbotScreen(),
        '/forgotPassword':(context) => ForgotPasswordScreen(),
      },
    );
  }
}
