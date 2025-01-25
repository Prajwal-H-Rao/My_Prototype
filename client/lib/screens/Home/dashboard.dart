import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:client/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String baseUrl = Config.baseUrl;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String email = "";
  String authToken = "";
  List<String> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? "Not Provided";
      authToken = prefs.getString('key') ?? "";
    });
  }

  void addTask(String task) {
    setState(() {
      tasks.add(task);
    });
  }

  void editTask(int index, String newTask) {
    setState(() {
      setState(() {
        tasks[index] = newTask;
      });
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void showAddTaskDialog() {
    String newTask = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: TextField(
            onChanged: (value) {
              newTask = value;
            },
            decoration: InputDecoration(hintText: "Enter task"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  addTask(newTask);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showEditTaskDialog(int index) {
    String updatedTask = tasks[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            onChanged: (value) {
              updatedTask = value;
            },
            decoration: InputDecoration(hintText: "Update task"),
            controller: TextEditingController(text: tasks[index]),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (updatedTask.isNotEmpty) {
                  editTask(index, updatedTask);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get It Done"),
        backgroundColor: Colors.purple.shade200,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Task List
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => showEditTaskDialog(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteTask(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Add Task Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade200),
              onPressed: showAddTaskDialog,
              child: Text('Add Task'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
