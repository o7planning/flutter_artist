part of '../flutter_artist.dart';

abstract class _WidgetState<W extends _StatefulWidget> extends State<W> {
  ShowMode showMode = ShowMode.production;

  late final String keyId;

  WidgetStateType get type;

  String get locationInfo;

  String get description;

  void refreshState();

  @override
  void initState() {
    super.initState();
  }
}
