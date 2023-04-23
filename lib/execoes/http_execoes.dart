class HttpExecoes implements Exception {
  final String msg;
  final int statusCode;

  HttpExecoes({
    required this.msg,
    required this.statusCode,
  });

  @override
  String toString() {
    return msg;
  }
}
