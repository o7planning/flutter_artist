part of '../../flutter_artist.dart';

abstract class QuickAction<DATA extends Object> extends BaseAction {
  final List<Type> affectedItemTypes;

  const QuickAction({
    required super.needToConfirm,
    required super.actionInfo,
    required this.affectedItemTypes,
  });

  Future<ApiResult<DATA>?> callApi();

  // TODO: Add document.
  // Future<void> doAfterCallApi({
  //   required bool success,
  //   required DATA? apiData,
  // });
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
