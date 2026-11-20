part of '../core.dart';

sealed class BlockExecutionIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>,
        PRECHECK,
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent<PRECHECK, EXECUTION_RESULT> {
  BlockExecutionIntent();
}

final class BlockQueryIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockQueryPrecheck,
        BlockQueryResult<ID, ITEM, ITEM_DETAIL>> {
  final bool isQueryMoreFlow;

  BlockQueryIntent({
    required this.isQueryMoreFlow,
  });
}

final class BlockBackendActionIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockBackendActionPrecheck,
        BlockBackendActionResult<ID, ITEM, ITEM_DETAIL>> {
  final BlockBackendAction<ID> action;

  BlockBackendActionIntent({required this.action});
}

final class BlockQuickItemUpdateIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockQuickItemUpdatePrecheck,
        BlockQuickItemUpdateResult<ID, ITEM, ITEM_DETAIL>> {
  final BlockQuickItemUpdateAction<ID, ITEM, ITEM_DETAIL> action;

  BlockQuickItemUpdateIntent({required this.action});
}

final class BlockQuickItemCreationIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockQuickItemCreationPrecheck,
        BlockQuickItemCreationResult<ID, ITEM, ITEM_DETAIL>> {
  final BlockQuickItemCreationAction<ID, ITEM, ITEM_DETAIL> action;

  BlockQuickItemCreationIntent({required this.action});
}

final class BlockDeleteItemIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockItemDeletionPrecheck,
        BlockItemDeletionResult<ID, ITEM, ITEM_DETAIL>> {
  final ITEM item;

  BlockDeleteItemIntent({
    required this.item,
  });
}

final class BlockDeleteItemsIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockItemsDeletionPrecheck,
        BlockItemsDeletionResult<ID, ITEM, ITEM_DETAIL>> {
  final List<ITEM> items;
  final bool stopIfError;

  BlockDeleteItemsIntent({
    required this.items,
    required this.stopIfError,
  });
}

final class BlockClearItemsIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockClearItemsPrecheck,
        BlockClearItemsResult<ID, ITEM, ITEM_DETAIL>> {
  BlockClearItemsIntent();
}

final class BlockDoneIntent<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> extends BlockExecutionIntent<
    ID, //
    ITEM,
    ITEM_DETAIL,
    dynamic,
    EmptyExecutionUnitResult> {
  final String lastIntentInfo;

  BlockDoneIntent({required this.lastIntentInfo});
}

final class BlockNullIntent<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> extends BlockExecutionIntent<
    ID, //
    ITEM,
    ITEM_DETAIL,
    dynamic,
    EmptyExecutionUnitResult> {
  final String lastIntentInfo;

  BlockNullIntent({required this.lastIntentInfo});
}
