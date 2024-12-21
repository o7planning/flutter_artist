part of '../flutter_artist.dart';

abstract class _WidgetState<W extends StatefulWidget> extends State<W> {
  ShowMode showMode = ShowMode.production;

  WidgetStateType get type;

  String get locationInfo;

  String get description;

  void refreshState();
}
