part of '../flutter_artist.dart';

class Actionable {
  final String? message;
  final bool yes;

  Actionable.yes()
      : message = null,
        yes = true;

  Actionable.no({required String this.message}) : yes = false;
}
