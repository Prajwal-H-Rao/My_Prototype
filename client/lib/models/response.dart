class ResponseModel {
  final bool isSuccess;
  final String message;
  final String? token;
  final String? name;
  final String? email;
  ResponseModel(
      {required this.isSuccess,
      required this.message,
      this.token,
      this.name,
      this.email});
}
