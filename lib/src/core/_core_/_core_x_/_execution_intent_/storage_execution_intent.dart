part of '../../core.dart';

sealed class StorageExecutionIntent<
        PRECHECK, //
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent<PRECHECK, EXECUTION_RESULT> {
  //
}

final class StorageBackendActionIntent extends StorageExecutionIntent<
    StorageBackendActionPrecheck, StorageBackendActionResult> {
  final StorageBackendAction action;

  StorageBackendActionIntent({required this.action});
}
