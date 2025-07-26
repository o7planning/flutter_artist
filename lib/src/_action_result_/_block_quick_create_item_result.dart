part of '../../flutter_artist.dart';

@_RenameAnnotation()
class BlockQuickCreateItemResult extends ActionResult {
  final BlockQuickCreateItemPrecheck? precheck;
  AppError? _appError;
  StackTrace? _stackTrace;

  AppError? get error => _appError;

  StackTrace? get stackTrace => _stackTrace;

  BlockQuickCreateItemResult({this.precheck, StackTrace? stackTrace})
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
