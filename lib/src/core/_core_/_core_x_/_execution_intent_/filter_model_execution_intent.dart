part of '../../core.dart';

sealed class FilterModelExecutionIntent<
        PRECHECK, //
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent<PRECHECK, EXECUTION_RESULT> {
  //
}

// FilterPanel change!
final class FilterModelFilterPanelChangeIntent
    extends FilterModelExecutionIntent<dynamic, EmptyExecutionUnitResult> {
  final Map<String, dynamic> formKeyInstantValuesInUI;

  FilterModelFilterPanelChangeIntent({
    required this.formKeyInstantValuesInUI,
  });
}

final class FilterModelLoadIntent
    extends FilterModelExecutionIntent<dynamic, EmptyExecutionUnitResult> {
  // Nothing
}

final class FilterModelDoneIntent
    extends FilterModelExecutionIntent<dynamic, EmptyExecutionUnitResult> {
  // Nothing
}
