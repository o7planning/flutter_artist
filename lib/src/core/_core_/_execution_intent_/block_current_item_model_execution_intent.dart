part of '../core.dart';

sealed class BlockCurrentItemModelExecutionIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>,
        FORM_PATCH extends FormPatch,
        PRECHECK,
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionIntent<PRECHECK, EXECUTION_RESULT> {
  BlockCurrentItemModelExecutionIntent();
}

final class BlockCurrentItemModelPrepareFormToCreateItemIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>,
        FORM_PATCH extends FormPatch> //
    extends BlockCurrentItemModelExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        FORM_PATCH,
        BlockItemCreationPrecheck,
        BlockPrepareItemCreationResult<ID, ITEM, ITEM_DETAIL>> {
  final bool initDirty;
  final FORM_PATCH? formPatch;

  BlockCurrentItemModelPrepareFormToCreateItemIntent({
    required this.initDirty,
    required this.formPatch,
  });
}

final class BlockCurrentItemModelClearCurrentItemIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>,
        FORM_PATCH extends FormPatch> //
    extends BlockCurrentItemModelExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        FORM_PATCH,
        BlockClearCurrentItemPrecheck,
        BlockClearCurrentItemResult<ID, ITEM, ITEM_DETAIL>> {
  BlockCurrentItemModelClearCurrentItemIntent();
}

final class BlockCurrentItemModelSetCurrentItemIntent<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>,
        FORM_PATCH extends FormPatch> //
    extends BlockCurrentItemModelExecutionIntent<
        ID, //
        ITEM,
        ITEM_DETAIL,
        FORM_PATCH,
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
    ITEM_DETAIL extends Identifiable<ID>,
    FORM_PATCH extends FormPatch> extends BlockCurrentItemModelExecutionIntent<
    ID, //
    ITEM,
    ITEM_DETAIL,
    FORM_PATCH,
    dynamic,
    EmptyExecutionUnitResult> {
  final String lastIntentInfo;

  BlockCurrentItemModelDoneIntent({required this.lastIntentInfo});
}
