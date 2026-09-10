part of '../core.dart';

class ExecutionUnitResultWrapper<
    PRECHECK, //
    EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>> {
  EXECUTION_RESULT? _result;

  EXECUTION_RESULT? get result => _result;

  ExecutionUnitResultWrapper();

  EXECUTION_RESULT _setResult(
    EXECUTION_RESULT result, {
    required Object objectCaller,
    required String methodName,
  }) {
    print("@@@._setResult: ${getClassName(objectCaller)}.$methodName");
    if (_result != null) {
      throw StateError("Internal library error: Invalid Logic");
    }
    _result = result;
    return result;
  }
}

abstract class ExecutionUnitResult<PRECHECK> {
  PRECHECK? _precheck;
  ErrorInfo? _errorInfo;

  PRECHECK? get precheck => _precheck;

  ErrorInfo? get errorInfo => _errorInfo;

  ExecutionUnitResult({
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

class EmptyExecutionUnitResult extends ExecutionUnitResult<dynamic> {
  @override
  bool get successForFirst => true;
}
