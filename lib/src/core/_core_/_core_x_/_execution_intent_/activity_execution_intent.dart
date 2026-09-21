part of '../../core.dart';

sealed class ActivityExecutionIntent<
        PRECHECK, //
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent {
  //
}

final class DefaultActivityExecutionIntent
    extends ActivityExecutionIntent<ActivityPrecheck, ActivityResult> {
  //
}
