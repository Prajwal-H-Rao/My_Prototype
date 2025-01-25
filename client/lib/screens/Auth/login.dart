import 'package:client/config.dart';
import 'package:client/models/response.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static String? baseUrl = Config.baseUrl;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Email and Password are required!")),
                      );
                      return;
                    }

                    try {
                      final response = await loginUser(email, password);

                      if (response.isSuccess && context.mounted) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', true);
                        await prefs.setString('name', response.name ?? "Guest");
                        await prefs.setString(
                            'email', response.email ?? "Not Provided");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login successful!")),
                        );
                        Navigator.pushReplacementNamed(
                            context, "/home"); // Navigate to Home Screen
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response.message)),
                          );
                        }
                      }
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login failed!")),
                        );
                      }
                    }
                  },
                  child: Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/signup");
                  },
                  child: Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<ResponseModel> loginUser(String email, String password) async {
    final uri = Uri.parse("$baseUrl/auth/login");
    try {
      final response = await post(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print(data);
        return ResponseModel(
            isSuccess: true,
            message: 'Logged in sucessfully',
            token: data['token'],
            name: data['name'],
            email: data['email']);
      } else {
        final data = jsonDecode(response.body);
        return ResponseModel(
          isSuccess: false,
          message: data['error'] ?? "Something went wrong.",
        );
      }
    } catch (error) {
      return ResponseModel(
        isSuccess: false,
        message: "An error occurred. Please try again later.",
      );
    }
  }
}
