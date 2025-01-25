import 'package:client/screens/Auth/login.dart';
import 'package:client/screens/Auth/sign_up.dart';
import 'package:client/screens/Home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUp(),
        '/home': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
