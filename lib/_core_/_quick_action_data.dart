part of '../flutter_artist.dart';

abstract class QuickActionData {
  final bool needToConfirm;
  final String? actionInfo;

  QuickActionData({
    required this.needToConfirm,
    required this.actionInfo,
  });

  void executeRoute(BuildContext context);
}

class SimpleQuickActionData extends QuickActionData {
  dynamic data;
  final Function(BuildContext context) route;

  SimpleQuickActionData({
    required this.data,
    required super.needToConfirm,
    required this.route,
    required super.actionInfo,
  });

  @override
  void executeRoute(BuildContext context) {
    route(context);
  }
}
