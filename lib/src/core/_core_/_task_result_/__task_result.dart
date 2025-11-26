part of '../core.dart';

abstract class TaskResult<PRECHECK> {
  PRECHECK? _precheck;
  ErrorInfo? _errorInfo;

  PRECHECK? get precheck => _precheck;

  ErrorInfo? get errorInfo => _errorInfo;

  TaskResult({
    PRECHECK? precheck,
    ErrorInfo? errorInfo,
  })  : _precheck = precheck,
        _errorInfo = errorInfo;

  bool get successForFirst;

  bool get successForAll => successForFirst;

  void _setPrecheck(PRECHECK? precheck) {
    _precheck = precheck;
  }

  void _setErrorInfo({
    required ErrorInfo errorInfo,
  }) {
    _errorInfo = errorInfo;
  }
}
