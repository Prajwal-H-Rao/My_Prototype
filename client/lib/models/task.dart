//This model is to convert the response json file from the server and convert into a task object
//The factory constructor has been used in the init funtion in dashboard.dart file
//to get the list of all tasks associated with a used and parse each object in the
//response list to an instance of Task model

class Taskmodel {
  final String title;
  final String user;
  bool isDashed;
  Taskmodel({required this.title, required this.user, required this.isDashed});
  factory Taskmodel.fromJson(Map<String, dynamic> json) {
    return Taskmodel(
        title: json['title'] as String,
        user: json['user'] as String,
        isDashed: json['isDashed'] as bool);
  }
}
