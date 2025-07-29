part of '../_fa_core.dart';

@RenameAnnotation()
class PrepareItemCreationResult extends ActionResult {
  final BlockItemCreationPrecheck? precheck;
  AppError? _appError;
  StackTrace? _stackTrace;

  AppError? get error => _appError;

  StackTrace? get stackTrace => _stackTrace;

  PrepareItemCreationResult({this.precheck, StackTrace? stackTrace})
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
