part of '../core.dart';

class XBlockCurrentItemModel<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> {
  String get name => blockCurrentItemModel.name;

  late final XBlock<
      ID, //
      ITEM,
      ITEM_DETAIL> xBlock;

  final XBlockFormModel? xBlockFormModel;

  XShelf get xShelf => xBlock.xShelf;

  int get xModuleId => xShelf.xModuleId;

  bool currentItemReloadedInSession = false;

  bool __forceReloadCurrItem = false;

  bool get forceReloadCurrItem => __forceReloadCurrItem;

  void setForceReloadCurrItemDone() {
    __forceReloadCurrItem = false;
  }

  void setForceReloadCurrItem(bool forceReloadCurrItem) {
    __forceReloadCurrItem = forceReloadCurrItem;
  }

  BlockCurrentItemModelExecutionIntent<
      ID, //
      ITEM,
      ITEM_DETAIL,
      dynamic,
      ExecutionUnitResult<dynamic>>? _stashedIntent;

  BlockCurrentItemModelExecutionIntent<
      ID, //
      ITEM,
      ITEM_DETAIL,
      dynamic,
      ExecutionUnitResult<dynamic>>? _executionIntent;

  BlockCurrentItemModelSetCurrentItemIntent<
      ID, //
      ITEM,
      ITEM_DETAIL>? _pendingSetCurrentItemIntent;

  final BlockCurrentItemModel<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FilterInput,
      FilterCriteria,
      CreationPreset,
      FormInput> blockCurrentItemModel;

  XBlockCurrentItemModel({
    required this.blockCurrentItemModel,
    required this.xBlockFormModel,
  });

  // ***************************************************************************
  // ***************************************************************************

  NxtExecutionUnit _getNextExecutionUnit({required bool debug}) {
    NxtExecutionUnit next = __getNextExecutionUnit(debug: debug);
    if (next.yes) {
      return next;
    }
    if (xBlockFormModel != null) {
      next = xBlockFormModel!._getNextExecutionUnit(debug: debug);
      if (next.yes) {
        return next;
      }
    }
    return next;
  }

  // ***************************************************************************
  // ***************************************************************************

  // BlockCurrentItemModel only (Not find in FormModel).
  NxtExecutionUnit __getNextExecutionUnit({required bool debug}) {
    return NxtExecutionUnit.no(info: "XXX", debug: debug);
  }

  void _createAndSetBlockCurrentItemModelExecutionIntentDone({
    required String lastIntentInfo,
  }) {
    _executionIntent = BlockCurrentItemModelDoneIntent<ID, ITEM, ITEM_DETAIL>(
      lastIntentInfo: lastIntentInfo,
    );
  }

  BlockCurrentItemModelSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockCurrentItemModelExecutionIntentSetCurrentItem({
    required BlockSetCurrentItemDirective setCurrentItemDirective,
    required List<ITEM> newQueriedList,
    required ITEM? inputCandidateCurrItem,
    required bool forceReloadItem,
    required FormLoadHint? formLoadHint,
  }) {
    final executionIntent =
        BlockCurrentItemModelSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>(
      setCurrentItemDirective: setCurrentItemDirective,
      newQueriedList: newQueriedList,
      inputCandidateCurrItem: inputCandidateCurrItem,
      forceReloadItem: forceReloadItem,
      formLoadHint: formLoadHint,
    );
    _executionIntent = executionIntent;
    _pendingSetCurrentItemIntent ??= executionIntent;
    return executionIntent;
  }

  BlockCurrentItemModelClearCurrentItemIntent<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockCurrentItemModelExecutionIntentClearCurrentItem() {
    final executionIntent =
        BlockCurrentItemModelClearCurrentItemIntent<ID, ITEM, ITEM_DETAIL>();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  BlockCurrentItemModelPrepareFormToCreateItemIntent<ID, ITEM, ITEM_DETAIL>
      _createAndSetBlockCurrentItemModelExecutionIntentPrepareFormToCreateItem({
    required XBlock<ID, ITEM, ITEM_DETAIL> xBlock,
    required bool initDirty,
    required FormInput? formInput,
  }) {
    final executionIntent = BlockCurrentItemModelPrepareFormToCreateItemIntent<
        ID, ITEM, ITEM_DETAIL>(
      initDirty: initDirty,
      formInput: formInput,
    );
    _executionIntent = executionIntent;
    return executionIntent;
  }
}
