import 'package:client/models/task.dart';
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
  List<Taskmodel> tasks = [];

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

    final uri = Uri.parse('${HomePage.baseUrl}/tasks');
    final response =
        await http.get(uri, headers: {'Authorisation': 'Bearer $authToken'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Taskmodel> temp = (data['tasks'] as List)
          .map((task) => Taskmodel.fromJson(task))
          .toList();
      setState(() {
        tasks = temp;
      });
    }
    //get all the tasks from the database
  }

  void addTask(String task) async {
    final uri = Uri.parse('${HomePage.baseUrl}/tasks');
    final response = await http.post(uri,
        headers: {
          'Content-Type': "application/json",
          'Authorisation': 'Bearer $authToken'
        },
        body: jsonEncode({"title": task}));
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body)['newTask'];
      final newTask = Taskmodel(
          title: data['title'], user: data['user'], isDashed: data['isDashed']);
      setState(() {
        tasks.add(newTask);
      });
    }
  }

  void editTask(int index, String newTask) async {
    final uri = Uri.parse('${HomePage.baseUrl}/tasks');
    final response = await http.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorisation': 'Bearer $authToken'
        },
        body: jsonEncode({
          "title": tasks[index].title,
          "newtitle": newTask,
          "isDashed": tasks[index].isDashed
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        tasks[index] = Taskmodel(
            title: data['title'],
            user: data['user'],
            isDashed: data['isDashed']);
      });
    }
  }

  void deleteTask(int index) async {
    final uri = Uri.parse('${HomePage.baseUrl}/tasks');
    final response = await http.delete(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorisation': 'Bearer $authToken'
        },
        body: jsonEncode(
            {"title": tasks[index].title, "user": tasks[index].user}));
    if (response.statusCode == 200) {
      setState(() {
        tasks.removeAt(index);
      });
    }
  }

  void showAddTaskDialog() {
    String newTask = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Task',
            style: TextStyle(color: Colors.purple.shade300),
          ),
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
    String updatedTask = tasks[index].title;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Task',
            style: TextStyle(color: Colors.purple.shade200),
          ),
          content: TextField(
            onChanged: (value) {
              updatedTask = value;
            },
            decoration: InputDecoration(hintText: "Update task"),
            controller: TextEditingController(text: tasks[index].title),
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Get It Done",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple.shade100,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.red.shade300,
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Task List
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Your Tasks:",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tasks[index].isDashed = !tasks[index].isDashed;
                      });
                    },
                    child: ListTile(
                      leading: tasks[index].isDashed
                          ? CircleAvatar(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.check,
                                size: 30,
                              ),
                            )
                          : CircleAvatar(),
                      title: Text(
                        tasks[index].title,
                        style: TextStyle(
                            decoration: tasks[index].isDashed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: Colors.green.shade600,
                            decorationThickness: 2,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.purple.shade200),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.lightBlue.shade200,
                            ),
                            onPressed: () => showEditTaskDialog(index),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade300,
                            ),
                            onPressed: () => deleteTask(index),
                          ),
                        ],
                      ),
                    ),
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
                  backgroundColor: Colors.purple.shade100),
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
