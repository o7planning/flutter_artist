part of '../core.dart';

sealed class LovExecutionIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        PRECHECK,
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent<PRECHECK, EXECUTION_RESULT> {
  LovExecutionIntent();
}

final class LovQueryIntent<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> extends LovExecutionIntent<
    ID, //
    ITEM,
    LovQueryPrecheck,
    LovQueryResult<ID, ITEM>> {
  final bool isQueryMoreFlow;

  LovQueryIntent({
    required this.isQueryMoreFlow,
  });
}

final class LovClearItemsIntent<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> extends LovExecutionIntent<
    ID, //
    ITEM,
    LovClearItemsPrecheck,
    LovClearItemsResult<ID, ITEM>> {
  LovClearItemsIntent();
}

final class LovDoneIntent<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> extends LovExecutionIntent<
    ID, //
    ITEM,
    dynamic,
    EmptyExecutionUnitResult> {
  final String lastIntentInfo;

  LovDoneIntent({required this.lastIntentInfo});
}

final class LovNullIntent<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>> extends LovExecutionIntent<
    ID, //
    ITEM,
    dynamic,
    EmptyExecutionUnitResult> {
  final String lastIntentInfo;

  LovNullIntent({required this.lastIntentInfo});
}
