part of '../core.dart';

abstract class TaskResult<PRECHECK> {
  PRECHECK? _precheck;
  AppError? _appError;
  StackTrace? _stackTrace;

  PRECHECK? get precheck => _precheck;

  AppError? get error => _appError;

  StackTrace? get stackTrace => _stackTrace;

  TaskResult({
    PRECHECK? precheck,
    StackTrace? stackTrace,
  })  : _precheck = precheck,
        _stackTrace = stackTrace;

  bool get successForFirst;

  bool get successForAll => successForFirst;

  void _setPrecheck(PRECHECK? precheck) {
    _precheck = precheck;
  }

  void _setAppError({
    required AppError appError,
    required StackTrace? stackTrace,
  }) {
    _appError = appError;
    _stackTrace = stackTrace;
  }
}
