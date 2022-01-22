class HttpExepstion implements Exception {
  final String message;
  HttpExepstion(this.message);

  @override
  String toString() {
    return message;
  }
}
