part of '../_fa_core.dart';

class BlockQuickActionResult extends ActionResult {
  final BlockQuickActionPrecheck? precheck;
  AppError? _appError;
  StackTrace? _stackTrace;

  AppError? get error => _appError;

  StackTrace? get stackTrace => _stackTrace;

  BlockQuickActionResult({this.precheck, StackTrace? stackTrace})
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
