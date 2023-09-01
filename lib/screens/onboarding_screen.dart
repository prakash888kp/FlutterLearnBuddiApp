import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learnBuddi/screens/signup_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'admin/adminLogin_screen.dart';
import '../res/app_color.dart'; // Assuming this is your app's custom colors

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  double _posX = 0.0;
  double _posY = 0.0;
  double _beginAlign = -1.0;
  Color _color = Colors.red;
  late Timer _timerGradient;
  late Timer _timerBubble;

  @override
  void initState() {
    super.initState();
    
    _timerGradient = Timer.periodic(
      Duration(seconds: 7),
      (Timer timer) => _updateGradient(),
    );

    _timerBubble = Timer.periodic(
      Duration(seconds: 5),
      (Timer timer) => _updatePosition(),
    );
  }

  void _updatePosition() {
    final random = Random();
    setState(() {
      _posX = random.nextDouble();
      _posY = random.nextDouble();
      _color = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    });
  }

  void _updateGradient() {
    setState(() {
      _beginAlign = _beginAlign == -1.0 ? 1.0 : -1.0;
    });
  }

  @override
  void dispose() {
    _timerGradient.cancel();
    _timerBubble.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 7),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(_beginAlign, 0),
                end: Alignment(_beginAlign.abs(), 0),
                colors: [Colors.blueAccent, Colors.purple, Colors.blueAccent],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 5),
            curve: Curves.easeInOut,
            left: _posX * MediaQuery.of(context).size.width,
            top: _posY * MediaQuery.of(context).size.height,
            child: Icon(
              FontAwesomeIcons.book,  // FontAwesome book icon
              color: Colors.white.withOpacity(0.8),  // Setting opacity
              size: 50,
            ),
          ),
          // Your other UI elements
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  margin: const EdgeInsets.only(bottom: 50.0),
                  child: ClipOval(
                  child: Image.asset(
                    'lib/media/logo.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover, // You can use this property for better fitting
                  ),
                ),
                ),
                const SizedBox(height: 30),
                // Login Button
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBackgroundColor, // Replace with your primary color
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.rightToBracket),
                        SizedBox(width: 15),
                        Text("Login"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Register Button
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBackgroundColor, // Replace with your primary color
                      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.userPlus),
                        SizedBox(width: 15),
                        Text("Register"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Admin Button
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBackgroundColor, // Replace with your primary color
                      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLoginScreen()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.userShield),
                        SizedBox(width: 15),
                        Text("Admin"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
