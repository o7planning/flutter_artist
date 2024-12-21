part of '../flutter_artist.dart';

abstract class QuickActionData {
  QuickActionData();

  void executeRoute(BuildContext context);
}

class SimpleQuickActionData extends QuickActionData {
  dynamic data;
  final Function(BuildContext context) route;

  SimpleQuickActionData({
    required this.data,
    required this.route,
  });

  @override
  void executeRoute(BuildContext context) {
    route(context);
  }
}
