part of '../../flutter_artist.dart';

class Actionable {
  final bool yes;

  final String? message;
  final List<String>? details;
  final StackTrace? stackTrace;

  bool get no => !yes;

  Actionable.yes()
      : message = null,
        details = null,
        stackTrace = null,
        yes = true;

  Actionable.no({
    required String this.message,
    required this.details,
    this.stackTrace,
  }) : yes = false;

  @override
  String toString() {
    return "${getClassName(this)}.$yes";
  }
}
