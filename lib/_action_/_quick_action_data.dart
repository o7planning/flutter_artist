part of '../flutter_artist.dart';

abstract class QuickAction extends BaseAction {
  final List<Type> affectedItemTypes;

  const QuickAction({
    required super.needToConfirm,
    required super.actionInfo,
    required this.affectedItemTypes,
  });

  Future<ApiResult<void>> callApi();
}

abstract class SimpleQuickAction extends QuickAction {
  final dynamic data;

  const SimpleQuickAction({
    required this.data,
    required super.needToConfirm,
    required super.actionInfo,
    required super.affectedItemTypes,
  });
}
