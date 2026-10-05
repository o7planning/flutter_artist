part of '../core.dart';

sealed class ActivityV1ExecutionIntent<
PRECHECK, //
EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent<PRECHECK, EXECUTION_RESULT> {
  //
}

final class DefaultActivityV1ExecutionIntent
    extends ActivityV1ExecutionIntent<ActivityPrecheck, ActivityResult> {
  //
}
