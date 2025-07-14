part of '../../flutter_artist.dart';

abstract class BlockQuickAction<DATA extends Object> extends BaseAction {
  final List<Type> affectedItemTypes;

  const BlockQuickAction({
    required super.needToConfirm,
    required super.actionInfo,
    required this.affectedItemTypes,
  });

  Future<ApiResult<DATA>?> callApi();
}

abstract class SimpleQuickAction extends BlockQuickAction {
  final dynamic data;

  const SimpleQuickAction({
    required this.data,
    required super.needToConfirm,
    required super.actionInfo,
    required super.affectedItemTypes,
  });
}
