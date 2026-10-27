part of '../core.dart';

sealed class BlockCurrentItemModelExecutionIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>,
        PRECHECK,
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent<PRECHECK, EXECUTION_RESULT> {
  BlockCurrentItemModelExecutionIntent();
}

final class BlockCurrentItemModelPrepareFormToCreateItemIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockCurrentItemModelExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockItemCreationPrecheck,
        PrepareItemCreationResult> {
  final bool initDirty;
  final FormInput? formInput;

  BlockCurrentItemModelPrepareFormToCreateItemIntent({
    required this.initDirty,
    required this.formInput,
  });
}

final class BlockCurrentItemModelClearCurrentItemIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockCurrentItemModelExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockClearCurrentItemPrecheck,
        BlockClearCurrentItemResult> {
  BlockCurrentItemModelClearCurrentItemIntent();
}

final class BlockCurrentItemModelSetCurrentItemIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockCurrentItemModelExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockSetCurrentItemPrecheck,
        BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>> {
  final BlockSetCurrentItemDirective setCurrentItemDirective;
  final List<ITEM> newQueriedList;
  final ITEM? inputCandidateCurrItem;
  final bool forceReloadItem;
  final FormLoadHint? formLoadHint;

  BlockCurrentItemModelSetCurrentItemIntent({
    required this.setCurrentItemDirective,
    required this.newQueriedList,
    required this.inputCandidateCurrItem,
    required this.forceReloadItem,
    required this.formLoadHint,
  });
}

final class BlockCurrentItemModelDoneIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends BlockCurrentItemModelExecutionIntent<ID, ITEM, ITEM_DETAIL, dynamic,
        EmptyExecutionUnitResult> {
  final String lastIntentInfo;

  BlockCurrentItemModelDoneIntent({required this.lastIntentInfo});
}
