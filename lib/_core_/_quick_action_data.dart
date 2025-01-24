part of '../flutter_artist.dart';

abstract class QuickActionData {
  final bool needToConfirm;
  final String? actionInfo;

  QuickActionData({
    required this.needToConfirm,
    required this.actionInfo,
  });
}

class SimpleQuickActionData extends QuickActionData {
  dynamic data;

  SimpleQuickActionData({
    required this.data,
    required super.needToConfirm,
    required super.actionInfo,
  });
}
