part of '../../flutter_artist.dart';

class ScalarQueryResult extends ActionResult {
  ScalarQueryPrecheck? _precheck;

  ScalarQueryPrecheck? get precheck => _precheck;
  AppError? _appError;
  StackTrace? _stackTrace;

  AppError? get error => _appError;

  StackTrace? get stackTrace => _stackTrace;

  ScalarQueryResult({required ScalarQueryPrecheck? precheck})
      : _precheck = precheck;

  void _setFilterError() {
    _precheck = ScalarQueryPrecheck.filterError;
  }

  void _setAppError({required AppError appError, StackTrace? stackTrace}) {
    _appError = appError;
    _stackTrace = stackTrace;
  }

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return _appError == null;
  }
}
