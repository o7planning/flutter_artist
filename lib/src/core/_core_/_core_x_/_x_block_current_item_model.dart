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
    // 1. Restore the stashed intent if the current intent has been consumed
    if (_executionIntent == null && _stashedIntent != null) {
      _executionIntent = _stashedIntent;
      _stashedIntent = null;
    }

    final input = BlockCurrentItemNextUnitInput(
      dataState: blockCurrentItemModel.dataState,
      currentIntent: _executionIntent,
      formMode: xBlockFormModel?.formModel.formMode ?? BlockFormMode.none,
      isVisible: xBlock.block.ui.hasItemContext(includeDescendants: true),
      forceReloadCurrItem: forceReloadCurrItem,
      modelName: getClassNameWithoutGenerics(blockCurrentItemModel),
    );

    final output = BlockCurrentItemExecutionCalculator.calculate(input);

    // 2. Preserve the old Intent in case of data-loading contention
    // (e.g., a 'stale' state triggering an implicit SetItem)
    if (output.preserveCurrentIntent) {
      _stashedIntent = _executionIntent;
    }

    String finalDebugInfo = output.debugInfo;

    // 3. Inject Missing Intent (if it is necessary to re-fetch the currentItem
    // due to it being stale or requiring a forced reload)
    if (output.missingIntent == MissingIntentType.setItemAsCurrent) {
      final intentToUse =
          _createAndSetBlockCurrentItemModelExecutionIntentSetCurrentItem(
        // Giữ lại bản ghi hiện tại, chỉ load lại dữ liệu (forceReloadItem = true)
        setCurrentItemDirective:
            BlockSetCurrentItemDirective.setAnItemAsCurrent,
        newQueriedList: const [],
        inputCandidateCurrItem: blockCurrentItemModel.currentItem,
        forceReloadItem: true,
        formLoadHint: null,
      );
      finalDebugInfo = finalDebugInfo.replaceFirst(
          "_executionIntent: $_stashedIntent",
          "_executionIntent: $_stashedIntent --> $intentToUse");
    }

    // 4. Prioritize processing the pending intent, if present (similar to the mechanism in the original Block)
    if (output.action == BlockCurrentItemExecutionAction.setCurrentItem &&
        _pendingSetCurrentItemIntent != null) {
      _executionIntent = _pendingSetCurrentItemIntent;
      _pendingSetCurrentItemIntent = null; // Consume
    }

    // 5. Return the appropriate Execution Unit
    switch (output.action) {
      case BlockCurrentItemExecutionAction.setCurrentItem:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockCurrentItemModelSetItemAsCurrentExecutionUnit<ID,
              ITEM, ITEM_DETAIL>(
            xBlockCurrentItemModel: this,
            executionIntent: _executionIntent
                as BlockCurrentItemModelSetCurrentItemIntent<ID, ITEM,
                    ITEM_DETAIL>,
          ),
          info: finalDebugInfo,
        );
      case BlockCurrentItemExecutionAction.clearCurrentItem:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockCurrentItemModelClearCurrentExecutionUnit<ID,
              ITEM, ITEM_DETAIL>(
            xBlockCurrentItemModel: this,
            executionIntent: _executionIntent
                as BlockCurrentItemModelClearCurrentItemIntent<ID, ITEM,
                    ITEM_DETAIL>,
          ),
          info: finalDebugInfo,
        );
      case BlockCurrentItemExecutionAction.prepareFormToCreate:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit:
              _BlockCurrentItemModelPrepareFormToCreateItemExecutionUnit<ID,
                  ITEM, ITEM_DETAIL>(
            xBlockCurrentItemModel: this,
            executionIntent: _executionIntent
                as BlockCurrentItemModelPrepareFormToCreateItemIntent<ID, ITEM,
                    ITEM_DETAIL>,
          ),
          info: finalDebugInfo,
        );
      case BlockCurrentItemExecutionAction.none:
      default:
        return NxtExecutionUnit.no(
          debug: debug,
          info: finalDebugInfo,
        );
    }
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
