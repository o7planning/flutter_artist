part of '../_fa_core.dart';

@_RenameAnnotation()
class BlockQuickUpdateItemResult extends ActionResult {
  final BlockQuickUpdateItemPrecheck? precheck;
  AppError? _appError;
  StackTrace? _stackTrace;

  AppError? get error => _appError;

  StackTrace? get stackTrace => _stackTrace;

  BlockQuickUpdateItemResult({this.precheck, StackTrace? stackTrace})
      : _stackTrace = stackTrace;

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return _appError == null;
  }

  void _setAppError({
    required AppError appError,
    required StackTrace? stackTrace,
  }) {
    _appError = appError;
    _stackTrace = stackTrace;
  }
}
