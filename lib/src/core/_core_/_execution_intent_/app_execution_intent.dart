part of '../core.dart';

sealed class AppExecutionIntent<
        PRECHECK, //
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent<PRECHECK, EXECUTION_RESULT> {
  //
}

final class AppBackendActionIntent extends AppExecutionIntent<
    AppBackendActionPrecheck, AppBackendActionResult> {
  final AppBackendAction action;

  AppBackendActionIntent({required this.action});
}
