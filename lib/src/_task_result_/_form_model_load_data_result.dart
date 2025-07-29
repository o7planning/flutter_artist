part of '../_fa_core.dart';

@_RenameAnnotation("FormModelDataLoadResult")
class FormModelLoadDataResult extends ActionResult {
  final FormModelLoadDataPrecheck? precheck;

  AppError? _appError;
  StackTrace? _stackTrace;

  AppError? get error => _appError;

  StackTrace? get stackTrace => _stackTrace;

  FormModelLoadDataResult({this.precheck});

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
