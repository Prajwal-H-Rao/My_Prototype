class Taskmodel {
  final String title;
  final String user;
  Taskmodel({required this.title, required this.user});
  factory Taskmodel.fromJson(Map<String, dynamic> json) {
    return Taskmodel(
      title: json['title'] as String,
      user: json['user'] as String,
    );
  }
}
