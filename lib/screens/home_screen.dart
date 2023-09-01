import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:learnBuddi/screens/chatbot/chatbot_screen.dart';
import 'package:learnBuddi/screens/search_screen.dart';
import 'package:learnBuddi/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Razorpay? _razorpay;
  int _currentIndex = 0;
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();

    _children = [
      homeWidget(), // This should be the content for the Home tab
      SearchScreen(),
      ChatbotScreen(),
      ProfileScreen(),
    ];

    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) 
  {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Payment Successful'),
              content: const Text('Your payment was successful!'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'))
              ],
            ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Payment Failed'),
              content: const Text('Your payment has failed.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'))
              ],
            ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet here
  }

  void openCheckout(int amount) {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY',
      'amount': amount * 100,
      'name': 'Your App Name',
      'description': 'Course Purchase',
      'prefill': {'contact': 'Contact Number', 'email': 'Email'},
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  Widget homeWidget() {
  return Column(
    children: [
      const SizedBox(height: 50), // This adds 50 logical pixels of height as empty space
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Courses', // Heading
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Expanded(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('courses').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Text('No Courses Available');
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot course = snapshot.data!.docs[index];
                return ListTile(
                  title: Text(course['name']),
                  subtitle: Text('Cost: INR' + course['cost']),
                  trailing: ElevatedButton(
                    onPressed: () {
                      int amount = int.parse(course['cost']);
                      openCheckout(amount);
                    },
                    child: const Text('Buy'),
                  ),
                );
              },
            );
          },
        ),
      ),
    ],
  );
}
  // Your other methods remain the same

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      backgroundColor: Colors.white,
      //appBar: AppBar(title: const Text("Home"),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _children[_currentIndex],
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
              activeColor: Colors.blueAccent,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.chat_bubble,
                  text: 'Chatbot',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
      
    );
  }
}
