part of '../../flutter_artist.dart';

abstract class ScalarLoadExtraDataQuickAction<DATA extends Object>
    extends BaseAction {
  const ScalarLoadExtraDataQuickAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<DATA>?> callApiLoadExtraData();

  Future<void> doWithExtraData(
    BuildContext context, {
    required bool success,
    required DATA? extraData,
  });
}
