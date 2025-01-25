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
