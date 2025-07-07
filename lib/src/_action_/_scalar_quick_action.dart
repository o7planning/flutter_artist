part of '../../flutter_artist.dart';

abstract class ScalarQuickAction<DATA extends Object> extends BaseAction {
  final List<Type> affectedItemTypes;

  const ScalarQuickAction({
    required super.needToConfirm,
    required super.actionInfo,
    required this.affectedItemTypes,
  });

  Future<ApiResult<DATA>?> callApi();

  Future<void> doAfterCallApi({
    required bool success,
    required DATA? apiData,
  });
}
