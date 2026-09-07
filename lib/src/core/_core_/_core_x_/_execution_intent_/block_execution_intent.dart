part of '../../core.dart';

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
        BlockQueryResult> {
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
        BlockBackendActionResult> {
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
        BlockQuickItemUpdateResult> {
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
        BlockQuickItemCreationResult> {
  final BlockQuickItemCreationAction<ID, ITEM, ITEM_DETAIL> action;

  BlockQuickItemCreationIntent({required this.action});
}

final class BlockPrepareFormToCreateItemIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockItemCreationPrecheck,
        PrepareItemCreationResult> {
  final bool initDirty;
  final FormInput? formInput;

  BlockPrepareFormToCreateItemIntent({
    required this.initDirty,
    required this.formInput,
  });
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
        BlockItemDeletionResult<ITEM>> {
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
        BlockItemsDeletionResult<ITEM>> {
  final List<ITEM> items;
  final bool stopIfError;

  BlockDeleteItemsIntent({
    required this.items,
    required this.stopIfError,
  });
}

final class BlockClearCurrentItemIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockClearCurrentItemPrecheck,
        BlockClearCurrentItemResult> {
  BlockClearCurrentItemIntent();
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
        BlockClearItemsResult> {
  BlockClearItemsIntent();
}

final class BlockSetCurrentItemIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockSetCurrentItemPrecheck,
        BlockSetCurrentItemResult<ITEM>> {
  final BlockSetCurrentItemDirective setCurrentItemDirective;
  final List<ITEM> newQueriedList;
  final ITEM? inputCandidateCurrItem;
  final bool forceReloadItem;
  final ForceType? forceTypeForForm;

  BlockSetCurrentItemIntent({
    required this.setCurrentItemDirective,
    required this.newQueriedList,
    required this.inputCandidateCurrItem,
    required this.forceReloadItem,
    required this.forceTypeForForm,
  });
}

final class BlockDoneIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends BlockExecutionIntent<ID, ITEM, ITEM_DETAIL, dynamic,
        EmptyExecutionUnitResult> {
  final String lastIntentInfo;

  BlockDoneIntent({required this.lastIntentInfo});
}

final class BlockNullIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends BlockExecutionIntent<ID, ITEM, ITEM_DETAIL, dynamic,
        EmptyExecutionUnitResult> {
  final String lastIntentInfo;

  BlockNullIntent({required this.lastIntentInfo});
}
