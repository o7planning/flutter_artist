part of '../../flutter_artist.dart';

class ItemCreationResult<ITEM> extends ActionResult {
  final BlockItemCreationPrecheck? precheck;
  AppError? _appError;
  StackTrace? _stackTrace;

  AppError? get error => _appError;
  StackTrace? get stackTrace => _stackTrace;

  ItemCreationResult({this.precheck});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    return _appError != null;
  }

  void _setAppError({
    required AppError appError,
    required StackTrace? stackTrace,
  }) {
    _appError = appError;
    _stackTrace = stackTrace;
  }
}
