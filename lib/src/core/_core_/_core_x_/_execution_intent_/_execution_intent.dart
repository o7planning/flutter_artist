part of '../../core.dart';

sealed class ExecutionIntent<
    PRECHECK, //
    EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>> {
  final Completer<EXECUTION_RESULT> _completer = Completer<EXECUTION_RESULT>();

  Future<EXECUTION_RESULT> get result => _completer.future;

  final resultWrapper =
      ExecutionUnitResultWrapper<PRECHECK, EXECUTION_RESULT>();

  ExecutionIntent();

  /// Safely complete the intent with its corresponding result.
  void complete() {
    try {
      if (!_completer.isCompleted) {
        _completer.complete(resultWrapper._result);
      }
    } catch (e) {
      print("ERROR ExecutionIntent.complete(): $this");
      rethrow;
    }
  }

  /// Safely fail the intent if an unhandled error aborts execution.
  void completeError(Object error, [StackTrace? stackTrace]) {
    if (!_completer.isCompleted) {
      _completer.completeError(error, stackTrace);
    }
  }

  @override
  String toString() => getClassNameWithoutGenerics(this);
}
