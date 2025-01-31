part of '../flutter_artist.dart';

abstract class QuickActionData extends BaseActionData {
  final List<Type> affectedItemTypes;

  const QuickActionData({
    required super.needToConfirm,
    required super.actionInfo,
    required this.affectedItemTypes,
  });

  Future<ApiResult<void>> callApi();
}

abstract class SimpleQuickActionData extends QuickActionData {
  final dynamic data;

  const SimpleQuickActionData({
    required this.data,
    required super.needToConfirm,
    required super.actionInfo,
    required super.affectedItemTypes,
  });
}
