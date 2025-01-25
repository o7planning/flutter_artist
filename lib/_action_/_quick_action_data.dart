part of '../flutter_artist.dart';

abstract class QuickActionData extends BaseActionData {
  const QuickActionData({
    required super.needToConfirm,
    required super.actionInfo,
  });
}

class SimpleQuickActionData extends QuickActionData {
  final dynamic data;

  const SimpleQuickActionData({
    required this.data,
    required super.needToConfirm,
    required super.actionInfo,
  });
}
