class ResponseModel {
  final bool isSuccess;
  final String message;
  final String? token;
  ResponseModel({required this.isSuccess, required this.message, this.token});
}
