part of '../../flutter_artist.dart';

class Actionable {
  final String? message;
  final bool yes;

  bool get no => !yes;

  Actionable.yes()
      : message = null,
        yes = true;

  Actionable.no({required String this.message}) : yes = false;

  @override
  String toString() {
    return "${getClassName(this)}.$yes";
  }
}
