import 'package:client/models/response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  static const String baseUrl = "http://localhost:4000";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Signup",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: "Name", border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: "Email", border: OutlineInputBorder())),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: "Password", border: OutlineInputBorder()),
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final name = _nameController.text.trim();
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (name.isEmpty || email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text("All fields are required!")));
                        return;
                      }

                      try {
                        final response =
                            await signupUser(name, email, password);

                        if (response.isSuccess) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text('Signup Successful')));
                            Navigator.pushNamed(context, "/login");
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response.message)),
                            );
                          }
                        }
                      } catch (err) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Signup failed!")),
                          );
                        }
                      }
                    },
                    child: const Text("Sign Up")),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: const Text("Already have an account? Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<ResponseModel> signupUser(
      String name, String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/register");
    try {
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "name": name,
            "email": email,
            "password": password,
          }));
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ResponseModel(
          isSuccess: data['success'],
          message: data['message'],
        );
      } else {
        // Handle error responses (e.g., 400 Bad Request)
        final data = jsonDecode(response.body);
        return ResponseModel(
          isSuccess: false,
          message: data['message'] ?? "Something went wrong.",
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
