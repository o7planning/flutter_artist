part of '../../core.dart';

sealed class ScalarExecutionIntent<
        ID extends Comparable, //
        VALUE extends Identifiable<ID>,
        PRECHECK,
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent<PRECHECK, EXECUTION_RESULT> {
  //
}

final class ScalarQueryIntent<
        ID extends Comparable, //
        VALUE extends Identifiable<ID>>
    extends ScalarExecutionIntent<ID, VALUE, ScalarQueryPrecheck,
        ScalarQueryResult> {
  //
}

final class ScalarClearIntent<
        ID extends Comparable, //
        VALUE extends Identifiable<ID>>
    extends ScalarExecutionIntent<ID, VALUE, ScalarClearPrecheck,
        ScalarClearResult> {
  //
}

final class ScalarLoadExtraDataQuickActionIntent<
        ID extends Comparable, //
        VALUE extends Identifiable<ID>,
        DATA extends Object>
    extends ScalarExecutionIntent<ID, VALUE, ScalarLoadExtraDataPrecheck,
        ScalarLoadExtraDataResult> {
  final ScalarQuickExtraDataLoadAction<DATA> action;
  final AfterScalarLoadExtraDataQuickAction afterQuickAction;

  ScalarLoadExtraDataQuickActionIntent({
    required this.action,
    required this.afterQuickAction,
  });
}

final class ScalarDoneIntent<
        ID extends Comparable, //
        VALUE extends Identifiable<ID>>
    extends ScalarExecutionIntent<ID, VALUE, dynamic,
        EmptyExecutionUnitResult> {
  //
}
