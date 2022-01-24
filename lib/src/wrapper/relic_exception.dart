class RelicException implements Exception {
  final dynamic message;

  RelicException({this.message = "Relic Exception"});
  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
