import 'package:client/screens/Auth/login.dart';
import 'package:client/screens/Auth/sign_up.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login', // Set the initial route
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUp(),
        // '/home': (context) => LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
