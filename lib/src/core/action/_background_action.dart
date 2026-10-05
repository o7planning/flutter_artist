part of '__action.dart';

abstract class BackgroundAction extends Action {
  BackgroundAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<void>> run();
}
