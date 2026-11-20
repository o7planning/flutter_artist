part of '../core.dart';

class BlockCurrentItemModel<
    ID extends Comparable,
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>,
    FILTER_PATCH extends FilterPatch, // EmptyFilterPatch
    FILTER_CRITERIA extends FilterCriteria, // EmptyFilterCriteria
    CREATION_PRESET extends CreationPreset, // EmptyCreationPreset
    FORM_PATCH extends FormPatch // EmptyFormPatch
    > extends _Core {
  String get name => block.name;

  Shelf get shelf => block.shelf;

  _BlockCurrentData<ID, ITEM, ITEM_DETAIL> _currentData =
      _BlockCurrentData.ofNull();

  ID? get currentItemId => _currentData._id;

  ITEM? get currentItem => _currentData._item;

  ITEM_DETAIL? get currentItemDetail => _currentData._itemDetail;

  bool __isRefreshingCurrentItem = false;

  bool get isRefreshingCurrentItem => __isRefreshingCurrentItem;

  bool __isPreparingFormCreation = false;

  bool get isPreparingFormCreation => __isPreparingFormCreation;

  _BlockItemSyncSessionState<ID>? _blockItemSyncSessionState;

  _BlockItemSyncSessionState<ID>? get blockItemSyncSessionState =>
      _blockItemSyncSessionState;

  BlockItemDataState _dataState = BlockItemDataStateNone();

  BlockItemDataState get dataState => _dataState;

  void _setBlockItemDataState({
    required BlockItemDataState newBlockItemDataState,
  }) {
    _dataState = newBlockItemDataState;
  }

  final Block<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FILTER_PATCH,
      FILTER_CRITERIA,
      CREATION_PRESET,
      FORM_PATCH> block;

  final BlockFormModel<
      ID, //
      ITEM_DETAIL,
      CREATION_PRESET,
      FORM_PATCH,
      FormOutput,
      AdditionalFormRelatedData>? formModel;

  // ***************************************************************************
  // Constructor
  // ***************************************************************************

  BlockCurrentItemModel({required this.block, required this.formModel}) {
    formModel?.blockCurrentItemModel = this;
  }

  // ***************************************************************************

  XBlockCurrentItemModel _createXBlockCurrentItemModel({
    required XBlockFormModel<ID, ITEM_DETAIL, FORM_PATCH>? xBlockFormModel,
  }) {
    return XBlockCurrentItemModel<
        ID, //
        ITEM,
        ITEM_DETAIL,
        FORM_PATCH>(
      blockCurrentItemModel: this,
      xBlockFormModel: xBlockFormModel,
    );
  }

  // ***************************************************************************

  void _resetBlockItemSyncSessionState({
    required ExecutionTrace? executionTrace,
  }) {
    _blockItemSyncSessionState = null;
  }

  // ***************************************************************************

  /// Manages item sync session instantiation, appends the received event info targeting
  /// the active [currentItem], and marks [dataState] as stale.
  void _updateBlockItemSyncSessionState({
    required ExecutionTrace executionTrace,
    required EventSourceType eventSourceType,
    required List<Type> mainDataTypes,
    required List<Type> extraDataTypes,
    required List<ID> effectedItemIds,
  }) {
    final ID? activeItemId = currentItemId;
    if (activeItemId == null) {
      return;
    }
    executionTrace.addNonControllableCall(
      codeId: "#086700",
      caller: this,
      methodName: "_updateBlockItemSyncSessionState",
      suffixShortDesc: "",
      parameters: {
        "eventSourceType": eventSourceType,
        "mainDataTypes": mainDataTypes,
        "extraDataTypes": extraDataTypes,
        "activeItemId": activeItemId,
        "effectedItemIds": effectedItemIds,
      },
    );

    // 1. Initialize or reset item session if missing or bound to a previous item identity
    if (_blockItemSyncSessionState == null ||
        !_blockItemSyncSessionState!.isValidFor(activeItemId)) {
      _blockItemSyncSessionState = _BlockItemSyncSessionState<ID>(
        block: block,
        targetItemId: activeItemId,
      );
    }

    // 2. Append received event metadata targeting this active item
    _blockItemSyncSessionState!._addReceivedEventInfo(
      eventSourceType: eventSourceType,
      mainDataTypes: mainDataTypes,
      extraDataTypes: extraDataTypes,
      effectedItemIds: effectedItemIds,
    );

    executionTrace.addInfo(
      codeId: "#086800",
      shortDesc: "Added BlockReceivedEventInfo to active item sync session",
    );

    // 3. Mark the BlockItemDataState as stale to prompt an in-place currentItem reload
    if (!dataState.isLoadedStale) {
      executionTrace.addInfo(
        codeId: "#086900",
        shortDesc:
            "Transiting BlockItem dataState to stale for active item ID: $activeItemId",
      );
      _dataState = const BlockItemDataStateLoadedStale();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setCurrentDataAndItemDataState({
    required ID? id,
    required ITEM? item,
    required ITEM_DETAIL? itemDetail,
  }) {
    final ID? oldId = currentItemId;
    //
    _currentData = id == null
        ? _BlockCurrentData.ofNull()
        : _BlockCurrentData(
            id: id,
            item: item!,
            itemDetail: itemDetail!,
          );
    //
    final bool changed = oldId != id;
    //
    if (changed) {
      block.debug._currentItemChangeCount++;
      if (formModel != null) {
        formModel!._triggerItemIdChanged();
      }
      //
      _resetBlockItemSyncSessionState(
        executionTrace: null,
      );
    }
    if (id == null) {
      _dataState = BlockItemDataStateNone();
    } else {
      _dataState = BlockItemDataStateLoadedFresh();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Entry point called when this Block receives an event targeted specifically
  /// at the active [currentItem] level (e.g., [BlockReactionTarget.currentItem]).
  ///
  /// This bypasses dataset queries and instead updates the [_blockItemSyncSessionState],
  /// marking the active item data state as stale to command an in-place detail refresh.
  void _receiveEvent({
    required ExecutionTrace executionTrace,
    required EventSourceType eventSourceType,
    required EventDataKind eventDataKind,
    required List<Type> eventDataTypes,
    required List<ID>? effectedItemIds,
  }) {
    // 1. Guard against inactive item states or uninitialized blocks
    if (block.dataState.isNone || currentItem == null) {
      return;
    }

    if (eventDataTypes.isEmpty) {
      return;
    }

    // 2. Resolve data types that this block listens to for currentItem reactions
    final Set<Type> currentItemReactionTypes =
        block.getResolvedReactionDataTypes(
      target: BlockReactionTarget.currentItem,
    );

    if (currentItemReactionTypes.isEmpty) {
      return;
    }

    final bool isEffected = DataTypeEventUtils.hasIntersection(
      currentItemReactionTypes,
      eventDataTypes.toSet(),
    );

    if (!isEffected) {
      return;
    }

    // 3. Check ID relevance:
    // If effectedItemIds is provided (same domain), verify whether the current item ID is affected.
    // If effectedItemIds is null (cross-domain invalidation or global signal), unconditionally invalidate.
    final ID? activeItemId = currentItemId;
    if (effectedItemIds != null && activeItemId != null) {
      if (!effectedItemIds.contains(activeItemId)) {
        // Current item ID is unaffected by this specific mutation
        return;
      }
    }

    executionTrace.addNonControllableCall(
      codeId: "#086500",
      caller: this,
      methodName: "_updateBlockItemSyncSessionState",
      suffixShortDesc: "",
      parameters: {
        "eventSourceType": eventSourceType,
        "eventDataKind": eventDataKind,
        "eventDataTypes": eventDataTypes,
        "effectedItemIds": effectedItemIds,
      },
    );

    // 4. Update the item sync session state and transition BlockItemDataState to stale
    _updateBlockItemSyncSessionState(
      executionTrace: executionTrace,
      eventSourceType: eventSourceType,
      mainDataTypes: eventDataKind == EventDataKind.main ? eventDataTypes : [],
      extraDataTypes: eventDataKind == EventDataKind.extra //
          ? eventDataTypes
          : [],
      effectedItemIds:
          effectedItemIds ?? (activeItemId != null ? [activeItemId] : []),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Prepares the block's [formModel] to edit the active [currentItem].
  ///
  /// - Runs [BlockItemEditPrecheck] first (blocking dataset-level stale,
  ///   missing form/target, or business rule denial).
  /// - When [forceReload] is `false` (default): refreshes [currentItem] only if
  ///   item-level data is stale or missing, and loads the form only if it is not
  ///   already loaded-fresh in edit mode; if both are already ready, skips all
  ///   network calls and focuses the form immediately.
  /// - When [forceReload] is `true`: forces a fresh reload of both [currentItemDetail]
  ///   and [formModel].
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<BlockPrepareItemEditResult<ID, ITEM, ITEM_DETAIL>>
      __prepareFormToEditCurrentItem({
    required ExecutionTrace executionTrace,
    required bool forceReload,
  }) async {
    final ITEM? targetItem = currentItem;
    const bool checkBusyTrue = true;
    const bool checkAllowTrue = true;

    executionTrace.addNonControllableCall(
      codeId: "#078000",
      caller: this,
      methodName: "_checkBeforeEditCurrentItemOnForm",
      suffixShortDesc: "",
      parameters: {
        "checkBusy": checkBusyTrue,
        "checkAllow": checkAllowTrue,
      },
    );

    final Actionable<BlockItemEditPrecheck> actionable =
        _checkBeforeEditCurrentItemOnForm(
      checkBusy: checkBusyTrue,
      checkAllow: checkAllowTrue,
    );

    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#078040",
        prefixShortDesc: '_checkBeforeEditCurrentItemOnForm()',
        module: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockPrepareItemEditResult<ID, ITEM, ITEM_DETAIL>(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
        targetItem: targetItem,
        currentItem: currentItem,
        formReady: false,
      );
    }

    final ITEM validTargetItem = targetItem!;
    final bool needRefreshItem = forceReload ||
        dataState.isLoadedStale ||
        _blockItemSyncSessionState != null ||
        currentItemDetail == null;

    final bool needLoadForm = forceReload ||
        needRefreshItem ||
        !formModel!.dataState.isLoadedFresh ||
        formModel!.formMode != BlockFormMode.edit;

    executionTrace.addInfo(
      codeId: "#078100",
      shortDesc: "Resolved edit preparation plan:",
      parameters: {
        "forceReload": forceReload,
        "needRefreshItem": needRefreshItem,
        "needLoadForm": needLoadForm,
      },
    );

    // Case 1: Both currentItemDetail and FormModel are already fresh in edit mode.
    // Skip ExecutionUnit queue and move keyboard focus directly to the form.
    if (!needRefreshItem && !needLoadForm) {
      executionTrace.addInfo(
        codeId: "#078120",
        shortDesc:
            "Both currentItemDetail and formModel are already loaded-fresh in edit mode -> skip reload and focus form.",
      );
      _GlobalFocusGuard.requestFocusAfterExecution(
        ActiveFocusRegion(
          moduleName: shelf.name,
          unitName: name,
          regionType: FocusRegionType.blockFormView,
        ),
      );
      _GlobalFocusGuard.onExecutionQueueCompleted();

      return BlockPrepareItemEditResult<ID, ITEM, ITEM_DETAIL>(
        precheck: null,
        errorInfo: null,
        targetItem: validTargetItem,
        currentItem: currentItem,
        formReady: true,
      );
    }

    // Case 2 & 3: At least one of ItemDetail or FormModel needs to be loaded.
    final XShelf xShelf = _XShelfBlockSetItemAsCurrent(block: block);
    final thisXBlockCurrentItemModel =
        xShelf.findXBlockCurrentItemModelByName(name)
            as XBlockCurrentItemModel<ID, ITEM, ITEM_DETAIL, FORM_PATCH>;
    final XBlockFormModel<ID, ITEM_DETAIL, FORM_PATCH> xBlockFormModel =
        thisXBlockCurrentItemModel.xBlockFormModel!;

    xBlockFormModel.focusFlag = true;

    BlockCurrentItemModelSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL,
        FORM_PATCH>? setItemIntent;

    if (needRefreshItem) {
      // Step 1 (Refresh ItemDetail) -> Step 2 (Load FormModel via directive)
      thisXBlockCurrentItemModel.setForceReloadCurrItem(true);
      setItemIntent = thisXBlockCurrentItemModel
          ._createAndSetBlockCurrentItemModelExecutionIntentSetCurrentItem(
        setCurrentItemDirective:
            BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm,
        newQueriedList: const [],
        inputCandidateCurrItem: validTargetItem,
        forceReloadItem: true,
        formLoadHint:
            forceReload ? FormLoadHint.force : FormLoadHint.forceIfNeed,
      );
    } else {
      // ItemDetail is already fresh; only load FormModel directly.
      // TODO (Change to FormLoadHint.force): Need to decide after run Test Cases.
      xBlockFormModel.setForceType(
        forceReload ? FormLoadHint.force : FormLoadHint.forceIfNeed,
      );
      xBlockFormModel._createAndSetFormModelExecutionIntentLoad();
    }

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();

    final BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>? setItemResult =
        setItemIntent?.resultWrapper.result;
    final FormModelDataLoadResult? formLoadResult =
        xBlockFormModel._lastDataLoadIntent?.resultWrapper.result;

    final ErrorInfo? combinedErrorInfo =
        setItemResult?.errorInfo ?? formLoadResult?.errorInfo;

    final bool formReady = combinedErrorInfo == null &&
        currentItem?.id == validTargetItem.id &&
        formModel!.dataState.isLoadedFresh &&
        formModel!.formMode == BlockFormMode.edit;

    final result = BlockPrepareItemEditResult<ID, ITEM, ITEM_DETAIL>(
      precheck: null,
      errorInfo: combinedErrorInfo,
      targetItem: validTargetItem,
      currentItem: currentItem,
      formReady: formReady,
    );

    if (setItemResult != null) {
      for (final step in setItemResult.journalSteps) {
        result.recordStep(step);
      }
      if (setItemResult.nextResult != null) {
        result.linkNextResult(setItemResult.nextResult!);
      }
    }

    return result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_BlockFormModelLoadDataAnnotation()
  @_BlockRefreshCurrentItemAnnotation()
  @_BlockSetItemAsCurrentAnnotation()
  @_BlockSelectNextItemAsCurrentAnnotation()
  @_BlockSelectFirstItemAsCurrentAnnotation()
  @_BlockSelectPreviousItemAsCurrentAnnotation()
  Future<void> _unitSetItemAsCurrent({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlockCurrentItemModel<ID, ITEM, ITEM_DETAIL, FORM_PATCH>
        thisXBlockCurrentItemModel,
    required final BlockCurrentItemModelSetCurrentItemIntent<ID, ITEM,
            ITEM_DETAIL, FORM_PATCH>
        executionIntent,
  }) async {
    __assertThisXBlockCurrentItemModel(thisXBlockCurrentItemModel);

    thisXBlockCurrentItemModel
        ._createAndSetBlockCurrentItemModelExecutionIntentDone(
      lastIntentInfo: "Set Item As Current",
    );
    //
    final thisXBlock = thisXBlockCurrentItemModel.xBlock;
    final effectiveConfig = block.effectiveConfig;
    final List<ITEM> newQueriedList = executionIntent.newQueriedList;
    final ITEM? inputCandidateCurrItem = executionIntent.inputCandidateCurrItem;
    //
    executionTrace.addInfo(
      codeId: "#028000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()}.",
      parameters: {
        "inputCandidateCurrItem": inputCandidateCurrItem,
        "newQueriedList": newQueriedList,
        "setCurrentItemDirective": executionIntent.setCurrentItemDirective,
      },
    );
    //
    final bool manualDirty = false;
    if (formModel != null) {
      executionTrace.addInfo(
        codeId: "#028020",
        shortDesc:
            "${debugObjHtml(formModel)} -> set <b>manualDirty</b> to ${debugObjHtml(manualDirty)}.",
      );
      formModel?._formModelStructure._setManualDirty(manualDirty);
    }
    //
    final blockSetCurrentItemResult = executionIntent.resultWrapper._setResult(
      BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>(
        precheck: null,
        setCurrentItemDirective: executionIntent.setCurrentItemDirective,
        candidateItem: inputCandidateCurrItem,
        oldCurrentItem: currentItem,
        currentItem: currentItem,
      ),
      objectCaller: this,
      methodName: '_unitSetItemAsCurrent',
    );
    thisXBlock.attachToPredecessorIfAny(blockSetCurrentItemResult);
    //
    if (block.dataState.isPending || block.dataState.isLoadedStale) {
      // This case never runs in normal lifecycle
      print("NEVER RUN: dataState.isPending || dataState.isLoadedStale");
      return;
    }
    //
    final ITEM? currItemOrigin = currentItem;
    final ITEM? currItem;
    if (currItemOrigin != null) {
      if (block.containsItem(currItemOrigin)) {
        currItem = currItemOrigin;
      } else {
        currItem = null;
      }
    } else {
      currItem = null;
    }
    //
    ITEM? candidateCurrItem;
    //
    if (inputCandidateCurrItem != null) {
      if (!block.containsItem(inputCandidateCurrItem)) {
        executionTrace.addInfo(
          codeId: "#028120",
          shortDesc:
              "inputCandidateCurrItem: ${debugObjHtml(inputCandidateCurrItem)} not in the list items of the block.",
        );
        candidateCurrItem = null;
      } else {
        candidateCurrItem = inputCandidateCurrItem;
      }
    }
    int? suggestIdx = block.specifyItemIndexToSetAsCurrent();
    final ITEM? suggestCandidateItem;
    if (suggestIdx != null) {
      suggestCandidateItem = block.findItemByIndex(suggestIdx);
    } else {
      suggestCandidateItem = null;
    }
    candidateCurrItem = candidateCurrItem ??
        currItem ??
        newQueriedList.firstOrNull ??
        suggestCandidateItem ??
        block.firstItem;
    //
    if (candidateCurrItem == null) {
      executionTrace.addInfo(
        codeId: "#028080",
        shortDesc:
            "${debugObjHtml(this)} has no item -> clear all data in child blocks and set them to <b>none</b>."
            "${block._childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      );

      // Record transition to null as there are no items available
      blockSetCurrentItemResult.recordCurrentTransition(
        previousItem: currentItem,
        candidateItem: null,
        finalItem: null,
        trigger: CurrentItemTransitionTrigger.resetToNull,
      );
      blockSetCurrentItemResult.setCurrentItem(null);

      // Record cascaded state changes for child blocks
      for (final child in thisXBlock.childXBlocks) {
        blockSetCurrentItemResult.recordCascadedEviction(
          childBlockName: child.name,
          targetState: const BlockDataStateNone(),
        );
      }
      //
      _dataState = const BlockItemDataStateNone();
      _resetBlockItemSyncSessionState(
        executionTrace: executionTrace,
      );

      if (formModel != null) {
        formModel!._clearDataWithDataState(formDataState: FormDataStateNone());
      }

      block._clearAllChildrenBlocksToNone(
        thisXBlock: thisXBlock,
      );
      return;
    }
    //
    // OK, now candidateCurrItem is NOT NULL.
    //
    final bool isCandidateCurrentItemInNewQueriedList =
        FaItemsUtils.isListContainItem<ITEM, ID>(
      targetList: newQueriedList,
      item: candidateCurrItem,
      getItemId: block._getItemIdInternal,
    );
    //
    final bool provideItemsContext = block.ui.hasBlockContext(
      includeDescendants: true,
    );
    final bool provideItemDetailContext = block.ui.hasItemContext(
      includeDescendants: true,
    );
    final bool provideFormContext = block.ui.hasFormContext() ||
        (formModel != null &&
            executionIntent.setCurrentItemDirective ==
                BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm);
    final bool inputForceReloadItem =
        thisXBlockCurrentItemModel.forceReloadCurrItem ||
            executionIntent.forceReloadItem;
    final bool currItemMaybeChanged =
        candidateCurrItem.id != currItemOrigin?.id;
    //
    executionTrace.addInfo(
      codeId: "#028640",
      shortDesc: "Debug:",
      parameters: {
        "provideItemsContext": provideItemsContext,
        "provideItemDetailContext": provideItemDetailContext,
        "provideFormContext": provideFormContext,
        "inputForceReloadItem": inputForceReloadItem,
      },
    );
    //
    executionTrace.addSeparator();
    //
    executionTrace.addNonControllableCall(
      codeId: "#028660",
      caller: BlockCurrentItemResolver,
      methodName: "resolveCurrentItem",
      suffixShortDesc: "",
      parameters: {
        "ITEM == ITEM_DETAIL?": ITEM == ITEM_DETAIL,
        "candidateCurrItem": candidateCurrItem,
        "inputForceReloadItem": inputForceReloadItem,
        "provideItemsContext": provideItemsContext,
        "provideItemDetailContext": provideItemDetailContext,
        "provideFormContext": provideFormContext,
        "absentItemContextPolicy": effectiveConfig.absentItemContextPolicy,
        "unifiedItemRefreshPolicy": effectiveConfig.unifiedItemRefreshPolicy,
        "setCurrentItemDirective": executionIntent.setCurrentItemDirective,
        "isCandidateCurrentItemInNewQueriedList":
            isCandidateCurrentItemInNewQueriedList,
        "isCandidateItemDifferentFromCurrent": currItemMaybeChanged,
      },
    );
    //
    final BlockCurrentItemPlan blkState =
        BlockCurrentItemResolver.resolveCurrentItem(
      executionTrace: executionTrace,
      debug: false,
      thisXBlock: thisXBlock,
      candidateCurrItem: candidateCurrItem,
      inputForceReloadItem: inputForceReloadItem,
      provideItemsContext: provideItemsContext,
      provideItemDetailContext: provideItemDetailContext,
      provideFormContext: provideFormContext,
      absentItemContextPolicy: effectiveConfig.absentItemContextPolicy,
      unifiedItemRefreshPolicy: effectiveConfig.unifiedItemRefreshPolicy,
      setCurrentItemDirective: executionIntent.setCurrentItemDirective,
      isCandidateCurrentItemInNewQueriedList:
          isCandidateCurrentItemInNewQueriedList,
      isCandidateItemDifferentFromCurrent: currItemMaybeChanged,
    );
    //
    executionTrace.addSeparator();
    //
    final forceReloadItem = blkState.forceReloadItem;
    final candidateItemAccepted = blkState.candidateAccepted;
    final currentItemChanged = currItemMaybeChanged && candidateItemAccepted;

    if (!candidateItemAccepted) {
      executionTrace.addInfo(
        codeId: "#028670",
        shortDesc:
            "@candidateItemAccepted: <b>false</b> --> Clean all data of child blocks and set them to none.",
      );
      // Record candidate rejection step
      blockSetCurrentItemResult.recordCurrentTransition(
        previousItem: currentItem,
        candidateItem: candidateCurrItem,
        finalItem: null,
        trigger: CurrentItemTransitionTrigger.resetToNull,
      );
      //
      _setCurrentDataAndItemDataState(
        id: null,
        item: null,
        itemDetail: null,
      );
      blockSetCurrentItemResult.setCurrentItem(null);
      //
      for (final child in thisXBlock.childXBlocks) {
        blockSetCurrentItemResult.recordCascadedEviction(
          childBlockName: child.name,
          targetState: const BlockDataStateNone(),
        );
      }

      if (formModel != null) {
        formModel!._clearDataWithDataState(formDataState: FormDataStateNone());
      }

      block._clearAllChildrenBlocksToNone(
        thisXBlock: thisXBlock,
      );
      return;
    }
    //
    // NOW candidateItemAccepted.
    //
    executionTrace.addInfo(
      codeId: "#028700",
      shortDesc: "Calculated:",
      parameters: {
        "forceReloadItem": forceReloadItem,
        "candidateItemAccepted": candidateItemAccepted,
      },
    );
    //
    final bool isCandidateIsCurrent = block.isCurrentItem(candidateCurrItem);
    //
    executionTrace.addInfo(
      codeId: "#028720",
      shortDesc: "Calculated:",
      parameters: {
        "ITEM == ITEM_DETAIL?": ITEM == ITEM_DETAIL,
        "candidateCurrItem": candidateCurrItem,
        "isCandidateIsCurrent": isCandidateIsCurrent,
        "isCandidateCurrentItemInNewQueriedList":
            isCandidateCurrentItemInNewQueriedList,
        "absentItemContextPolicy": effectiveConfig.absentItemContextPolicy,
      },
    );
    //
    final ID candidateCurrItemId = block.__getItemIdShowErr(
      candidateCurrItem,
      showErr: true,
    );
    ITEM_DETAIL? refreshedCurrentItemDetail = currentItemDetail;

    final bool itemRefreshed;
    if (!forceReloadItem) {
      itemRefreshed = false;
      //
      executionTrace.addInfo(
        codeId: "#028800",
        shortDesc:
            "The candidate ${debugObjHtml(candidateCurrItem)} will not need to be reloaded.",
      );
      final ITEM? candidateCurrItemInNewQueriedList =
          FaItemsUtils.findItemInList(
        item: candidateCurrItem,
        targetList: executionIntent.newQueriedList,
        getItemId: block._getItemIdInternal,
      );
      if (ITEM == ITEM_DETAIL && candidateCurrItemInNewQueriedList != null) {
        refreshedCurrentItemDetail =
            candidateCurrItemInNewQueriedList as ITEM_DETAIL;
      }
    }
    // forceReloadItem
    else {
      itemRefreshed = true;
      String? methodName;
      final _BlockCurrentData? loadedCoupleItem =
          thisXBlock._getRecentLoadedItem(
        itemId: candidateCurrItemId,
      );
      refreshedCurrentItemDetail = loadedCoupleItem?._itemDetail;

      if (refreshedCurrentItemDetail == null) {
        methodName = "performLoadItemDetailById";
        try {
          __refreshRefreshingCurrentItemState(
            isRefreshingCurrentItem: true,
          );
          //
          executionTrace.addControllableCall(
            codeId: "#028900",
            caller: block,
            methodName: methodName,
            suffixShortDesc: "",
            parameters: {
              "candidateCurrItemId": candidateCurrItemId,
            },
          );
          //
          block.debug._performLoadItemDetailByIdCount++;
          thisXBlockCurrentItemModel.currentItemReloadedInSession = true;
          ApiResult<ITEM_DETAIL> result = await block.performLoadItemDetailById(
            itemId: candidateCurrItemId,
          );
          result.throwIfError();
          //
          refreshedCurrentItemDetail = result.data;
          thisXBlockCurrentItemModel.setForceReloadCurrItemDone();
          //
          executionTrace.addInfo(
            codeId: "#028920",
            shortDesc:
                "Result --> @refreshedCurrentItemDetail: ${debugObjHtml(refreshedCurrentItemDetail)}.",
          );
        } catch (e, stackTrace) {
          final ErrorInfo errorInfo = _handleError(
            module: shelf,
            methodName: methodName,
            error: e,
            stackTrace: stackTrace,
            showSnackBar: true,
            tipDocument: TipDocument.blockPerformLoadItemDetailById,
          );
          //
          blockSetCurrentItemResult._setErrorInfo(
            errorInfo: errorInfo,
          );

          blockSetCurrentItemResult.recordItemOperationFailure(
            item: candidateCurrItem,
            operation: methodName,
            errorInfo: errorInfo,
          );

          // Cancel pending form load/focus hints on item fetch failure
          thisXBlockCurrentItemModel.xBlockFormModel?.focusFlag = false;
          thisXBlockCurrentItemModel.xBlockFormModel
              ?.setForceType(FormLoadHint.auto);

          executionTrace.addInfo(
            codeId: "#029000",
            shortDesc:
                "The ${debugObjHtml(this)}.$methodName() method was called with an error!",
            errorInfo: errorInfo,
          );
          return;
        } finally {
          __refreshRefreshingCurrentItemState(
            isRefreshingCurrentItem: false,
          );
        }
      }
    } // end of forceReloadItem.

    // ===========================================================================
    // (***) STAGE 1: REMOTE NOT FOUND / EVICTION & FALLBACK HANDLING
    // ===========================================================================
    if (refreshedCurrentItemDetail == null) {
      // Do not move focus to the form if the targeted item was evicted remotely
      thisXBlockCurrentItemModel.xBlockFormModel?.focusFlag = false;

      executionTrace.addInfo(
        codeId: "#029040",
        shortDesc:
            "Candidate ${debugObjHtml(candidateCurrItem)} seems to have been deleted from the system "
            "--> remove it from the block..",
      );

      blockSetCurrentItemResult.recordEviction(
        item: candidateCurrItem,
        reason: ItemEvictionReason.remoteNotFound,
      );
      // Find sibling before removing..
      final ITEM? siblingItem = block.findSiblingItem(item: candidateCurrItem);

      // 1.1 Remove the evicted item from the current dataset
      executionTrace.addInfo(
        codeId: "#029060",
        shortDesc: "Remove ${debugObjHtml(candidateCurrItem)} from the list.",
      );
      await block._removeItemFromList(
        executionTrace: executionTrace,
        removeItem: candidateCurrItem,
      );
      // Test Case: [04a].
      if (candidateCurrItem.id == currentItem?.id) {
        _setCurrentDataAndItemDataState(
          id: null,
          item: null,
          itemDetail: null,
        );
      }
      // 1.2 Non-current candidate evicted with a surviving current item -> Keep current item stable
      if (!isCandidateIsCurrent && currItem != null) {
        return;
      }

      // 1.3 Case A: Found a sibling to fall back to
      if (siblingItem != null) {
        executionTrace.addInfo(
          codeId: "#029100",
          shortDesc:
              "Found new candidate ${debugObjHtml(siblingItem)} --> set it as current.",
        );

        blockSetCurrentItemResult.recordCurrentTransition(
          previousItem: isCandidateIsCurrent ? candidateCurrItem : currentItem,
          candidateItem: candidateCurrItem,
          finalItem: siblingItem,
          trigger: CurrentItemTransitionTrigger.siblingFallback,
        );

        thisXBlockCurrentItemModel
            ._createAndSetBlockCurrentItemModelExecutionIntentSetCurrentItem(
          setCurrentItemDirective: executionIntent.setCurrentItemDirective,
          newQueriedList: executionIntent.newQueriedList,
          inputCandidateCurrItem: siblingItem,
          forceReloadItem:
              !isCandidateIsCurrent && executionIntent.forceReloadItem,
          formLoadHint: null,
        );
        return;
      }

      // 1.4 Case B: No sibling available -> Clear current item and reset consumers to None
      if (isCandidateIsCurrent) {
        executionTrace.addInfo(
          codeId: "#029180",
          shortDesc: "Set current item to <b>null</b>.",
        );
        //
        _setCurrentDataAndItemDataState(
          id: null,
          item: null,
          itemDetail: null,
        );
        blockSetCurrentItemResult.setCurrentItem(null);
        //
        if (formModel != null) {
          executionTrace.addInfo(
            codeId: "#029200",
            shortDesc:
                "Set ${debugObjHtml(formModel!)} dataState to <b>none</b>.",
          );
          formModel!
              ._clearDataWithDataState(formDataState: FormDataStateNone());
        }

        executionTrace.addInfo(
          codeId: "#029220",
          shortDesc:
              "Clear all data in child blocks and set them to <b>none</b>."
              "${block._childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        );

        for (final child in thisXBlock.childXBlocks) {
          blockSetCurrentItemResult.recordCascadedEviction(
            childBlockName: child.name,
            targetState: const BlockDataStateNone(),
          );
        }

        block._clearAllChildrenBlocksToNone(thisXBlock: thisXBlock);
      }
      return;
    }

    // ===========================================================================
    // STAGE 2: ITEM MUTATION, CONVERSION & STATE COMMIT
    // ===========================================================================
    if (currentItemChanged || itemRefreshed) {
      executionTrace.addInfo(
        codeId: "#029400",
        shortDesc: "Debug",
        parameters: {
          "currentItemChanged": currentItemChanged,
          "itemRefreshed": itemRefreshed,
        },
      );

      // 2.1 Convert loaded ITEM_DETAIL to domain ITEM
      final String methodName = "convertItemDetailToItem";
      try {
        executionTrace.addControllableCall(
          codeId: "#029410",
          caller: this,
          methodName: methodName,
          suffixShortDesc:
              "To convert <b>ITEM_DETAIL</b> to <b>ITEM</b>, ${debugObjHtml(refreshedCurrentItemDetail)} --> ${block._debugItemTypeHtml()}.",
        );

        candidateCurrItem = block._convertItemDetailToItem(
          itemDetail: refreshedCurrentItemDetail,
        );

        executionTrace.addInfo(
          codeId: "#029420",
          shortDesc: "Got value: ${debugObjHtml(candidateCurrItem)}.",
        );
      } catch (e, stackTrace) {
        final ErrorInfo errorInfo = _handleError(
          module: shelf,
          methodName: methodName,
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: TipDocument.blockConvertItemDetailToItem,
        );

        blockSetCurrentItemResult._setErrorInfo(
          errorInfo: errorInfo,
        );

        blockSetCurrentItemResult.recordItemOperationFailure(
          item: candidateCurrItem,
          operation: methodName,
          errorInfo: errorInfo,
        );

        // Cancel pending form load/focus hints on item conversion failure
        thisXBlockCurrentItemModel.xBlockFormModel?.focusFlag = false;
        thisXBlockCurrentItemModel.xBlockFormModel
            ?.setForceType(FormLoadHint.auto);

        executionTrace.addInfo(
          codeId: "#029440",
          shortDesc:
              "The ${debugObjHtml(this)}.$methodName() method was called with an error!",
          errorInfo: errorInfo,
        );
        return;
      }

      // 2.2 Synchronize list data and commit current item pointer
      executionTrace.addNonControllableCall(
        codeId: "#029480",
        caller: block._blockData,
        methodName: "_insertOrReplaceItem",
        suffixShortDesc: "",
        parameters: {
          "item": candidateCurrItem,
        },
      );
      block._blockData._insertOrReplaceItem(item: candidateCurrItem);

      executionTrace.addInfo(
        codeId: "#029500",
        shortDesc: "Set ${debugObjHtml(candidateCurrItem)} as current.",
      );

      blockSetCurrentItemResult.recordCurrentTransition(
        previousItem: currItemOrigin,
        candidateItem: inputCandidateCurrItem,
        finalItem: candidateCurrItem,
        trigger: itemRefreshed
            ? CurrentItemTransitionTrigger.explicitSelect
            : CurrentItemTransitionTrigger.initialQueryDefault,
      );
      //
      _setCurrentDataAndItemDataState(
        id: candidateCurrItemId,
        item: candidateCurrItem,
        itemDetail: refreshedCurrentItemDetail,
      );
      blockSetCurrentItemResult.setCurrentItem(candidateCurrItem);
      //
      _resetBlockItemSyncSessionState(executionTrace: executionTrace);
    }

    // ===========================================================================
    // STAGE 3: FORM MODEL LIFECYCLE COORDINATION
    // ===========================================================================
    if (formModel != null) {
      if (currentItemChanged || isCandidateCurrentItemInNewQueriedList) {
        executionTrace.addInfo(
          codeId: "#029520",
          shortDesc:
              "Current Item Changed/Queried --> Clear form and set to Pending.",
        );
        formModel!._clearDataWithDataState(
          formDataState: FormDataStatePending(),
        );
      } else if (itemRefreshed) {
        executionTrace.addInfo(
          codeId: "#029530",
          shortDesc: "Current Item Refreshed --> Set Form to Stale.",
        );
        final newFormDataState =
            BlockFormDataStateUtils.calculateNewLazyDataState(
          currentFormDataState: formModel!.dataState,
          hasCurrentItem: true,
          currentItemChanged: false,
        );
        formModel!._formModelStructure._setFormDataState(
          formDataState: newFormDataState,
          error: null,
        );
      }

      // Explicit directive demanding immediate Form Load
      if (executionIntent.setCurrentItemDirective ==
          BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm) {
        final FormLoadHint targetHint =
            executionIntent.formLoadHint ?? FormLoadHint.forceIfNeed;
        thisXBlock.xBlockCurrentItemModel.xBlockFormModel!
            .setForceTypeIfLessThan(targetHint);

        executionTrace.addExecutionIntent(
          codeId: "#029540",
          owner: thisXBlock.xBlockCurrentItemModel.xBlockFormModel!.formModel,
          executionIntentType: FormModelDataLoadIntent,
          suffixShortDesc: "",
        );
        thisXBlock.xBlockCurrentItemModel.xBlockFormModel!
            ._createAndSetFormModelExecutionIntentLoad();
      }
    }

    // ===========================================================================
    // STAGE 4: CASCADE CHILD BLOCKS TO PENDING
    // ===========================================================================
    if (currentItemChanged) {
      executionTrace.addInfo(
        codeId: "#029640",
        shortDesc:
            "The <b>currentItem</b> has changed --> clear all data in child blocks and set them to <b>pending</b>."
            "${block._childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      );

      for (final child in thisXBlock.childXBlocks) {
        blockSetCurrentItemResult.recordCascadedEviction(
          childBlockName: child.name,
          targetState: const BlockDataStatePending(),
        );
      }

      block._clearAllChildrenBlocksToPending(
        thisXBlock: thisXBlock,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_BlockClearCurrentItemAnnotation()
  Future<void> _unitClearCurrentItem({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlockCurrentItemModel<ID, ITEM, ITEM_DETAIL, FORM_PATCH>
        thisXBlockCurrentItemModel,
    required BlockCurrentItemModelClearCurrentItemIntent<
            ID, //
            ITEM,
            ITEM_DETAIL,
            FORM_PATCH>
        executionIntent,
  }) async {
    __assertThisXBlockCurrentItemModel(thisXBlockCurrentItemModel);
    thisXBlockCurrentItemModel
        ._createAndSetBlockCurrentItemModelExecutionIntentDone(
            lastIntentInfo: "Clear Current Item");
    //
    executionTrace.addInfo(
      codeId: "#013000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()}",
    );
    //
    executionTrace.addInfo(
      codeId: "#013100",
      shortDesc: "${debugObjHtml(this)} -> set currentItem to null.",
    );
    executionIntent.resultWrapper._setResult(
      BlockClearCurrentItemResult<ID, ITEM, ITEM_DETAIL>(precheck: null),
      objectCaller: this,
      methodName: '_unitClearCurrentItem',
    );
    //
    _setCurrentDataAndItemDataState(
      id: null,
      item: null,
      itemDetail: null,
    );
    //
    if (formModel != null) {
      executionTrace.addInfo(
        codeId: "#013200",
        shortDesc:
            "${debugObjHtml(formModel)} clear data and set state to <b>none</b>.",
      );
      formModel!._clearDataWithDataState(formDataState: FormDataStateNone());
    }
    //
    executionTrace.addInfo(
      codeId: "#013400",
      shortDesc: "Clear data of all child blocks and set them to <b>none</b>."
          "${block._childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
    );
    // Test Case: [38b].
    block._clearAllChildrenBlocksToNone(
      thisXBlock: thisXBlockCurrentItemModel.xBlock,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_BlockPrepareFormToCreateItemAnnotation()
  Future<bool> _unitPrepareFormToCreateItem({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlockCurrentItemModel<ID, ITEM, ITEM_DETAIL, FORM_PATCH>
        thisXBlockCurrentItemModel,
    required BlockCurrentItemModelPrepareFormToCreateItemIntent<ID, ITEM,
            ITEM_DETAIL, FORM_PATCH>
        executionIntent,
  }) async {
    __assertThisXBlockCurrentItemModel(thisXBlockCurrentItemModel);
    thisXBlockCurrentItemModel
        ._createAndSetBlockCurrentItemModelExecutionIntentDone(
      lastIntentInfo: "Prepare Form To Create Item",
    );

    executionTrace.addInfo(
      codeId: "#004000",
      shortDesc: "Begin ${executionUnitType.asDebugExecutionUnit()}.",
      parameters: {
        "formPatch": executionIntent.formPatch,
        "initDirty": executionIntent.initDirty,
      },
    );

    executionTrace.addInfo(
      codeId: "#004020",
      shortDesc: "${debugObjHtml(this)} set currentItem to null.",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      BlockPrepareItemCreationResult<ID, ITEM, ITEM_DETAIL>(),
      objectCaller: this,
      methodName: '_unitPrepareFormToCreateItem',
    );

    const ID? nullId = null;
    const ITEM? nullItem = null;
    const ITEM_DETAIL? nullItemDetail = null;
    _setCurrentDataAndItemDataState(
      id: nullId,
      item: nullItem,
      itemDetail: nullItemDetail,
    );

    executionTrace.addInfo(
      codeId: "#004040",
      shortDesc: "Clear all data of child blocks and set them to <b>none</b>."
          "${block._childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
    );
    block._clearAllChildrenBlocksToNone(
      thisXBlock: thisXBlockCurrentItemModel.xBlock,
    );

    executionTrace.addInfo(
      codeId: "#004060",
      shortDesc: "${debugObjHtml(formModel)} set formMode to creation.",
    );
    formModel!._formModelStructure._setInternalFormModeAndState(
      internalFormMode: InternalFormMode.creation,
      formDataState: FormDataStateLoadedFresh(),
    );

    bool success = false;
    try {
      __refreshPreparingFormCreationState(
        isPreparingFormCreation: true,
      );

      final activityType = FormActivityType.startCreatingOrEditing;

      executionTrace.addNonControllableCall(
        codeId: "#004100",
        caller: formModel!,
        methodName: "_startNewFormActivity",
        suffixShortDesc: "",
        parameters: {
          "activityType": activityType,
          "formPatch": executionIntent.formPatch,
        },
      );

      // Delegate form initialization directly to the form model (creationPreset is resolved polymorphically)
      success = await formModel!._startNewFormActivity(
        executionTrace: executionTrace,
        formPatch: executionIntent.formPatch,
        activityType: activityType,
        formKeyInstantValuesInUI: null,
      );

      if (success) {
        executionTrace.addInfo(
          codeId: "#004120",
          shortDesc:
              "${debugObjHtml(formModel)} manually set dirty to ${executionIntent.initDirty}.",
        );
        formModel!._formModelStructure
            ._setManualDirty(executionIntent.initDirty);
        formModel!._formModelStructure._setFormDataState(
          formDataState: FormDataStateLoadedFresh(),
          error: null,
        );
        // *new-focus*
        final xBlockFormModel = thisXBlockCurrentItemModel.xBlockFormModel;
        if (xBlockFormModel != null) {
          xBlockFormModel.focusFlag = true;
          _GlobalFocusGuard.requestFocusAfterExecution(
            ActiveFocusRegion(
              moduleName: shelf.name,
              unitName: name,
              regionType: FocusRegionType.blockFormView,
            ),
          );
        }
      } else {
        final ErrorInfo? fatalErrorInfo = switch (formModel!.dataState) {
          FormDataStateFatalError(:final errorInfo) => errorInfo,
          _ => null,
        };
        if (fatalErrorInfo != null) {
          executionResult._setErrorInfo(errorInfo: fatalErrorInfo);
        }
      }
    } finally {
      __refreshPreparingFormCreationState(
        isPreparingFormCreation: false,
      );
    }
    return success;
  }

  // ***************************************************************************
  // ***************************************************************************

  // ***************************************************************************
  // ***************************************************************************

  @_BlockRefreshCurrentItemAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<BlockRefreshCurrentItemResult<ID, ITEM, ITEM_DETAIL>>
      __refreshCurrentItem({
    required ExecutionTrace executionTrace,
    required FormContextAvailability formContextAvailability,
  }) async {
    final ITEM? targetItem = currentItem;
    final bool checkBusyTrue = true;

    executionTrace.addNonControllableCall(
      codeId: "#069500",
      caller: this,
      methodName: "_checkBeforeRefreshCurrentItem",
      suffixShortDesc: "",
      parameters: {
        "checkBusy": checkBusyTrue,
      },
    );

    final Actionable<BlockRefreshCurrentItemPrecheck> actionable =
        _checkBeforeRefreshCurrentItem(
      checkBusy: checkBusyTrue,
    );

    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#069520",
        prefixShortDesc: '_checkBeforeRefreshCurrentItem()',
        module: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockRefreshCurrentItemResult<ID, ITEM, ITEM_DETAIL>(
        precheck: actionable.errCode,
        targetItem: targetItem,
        oldCurrentItem: targetItem,
        currentItem: targetItem,
      );
    }

    final BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL> internalResult =
        await __dispatchSetItemAsCurrentAfterPrecheck(
      executionTrace: executionTrace,
      item: targetItem!,
      forceLoadItem: true,
      formContextAvailability: formContextAvailability,
    );

    return BlockRefreshCurrentItemResult<ID, ITEM,
        ITEM_DETAIL>._fromSetCurrentItemResult(internalResult);
  }

  // ***************************************************************************
  // ***************************************************************************

  @_BlockSetItemAsCurrentAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>>
      __refreshItemAndSetAsCurrent({
    required ExecutionTrace executionTrace,
    required String methodName,
    required ITEM? item,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
    required bool forceLoadItem,
    required FormContextAvailability formContextAvailability,
  }) async {
    final bool effectiveWithFormContext =
        formContextAvailability == FormContextAvailability.assumeAvailable &&
            formModel != null;
    final BlockSetCurrentItemDirective setCurrentItemDirective =
        effectiveWithFormContext
            ? BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm
            : BlockSetCurrentItemDirective.setAnItemAsCurrent;

    executionTrace.addInfo(
      codeId: "#069000",
      shortDesc:
          "Calculated > @setCurrentItemDirective: ${debugObjHtml(setCurrentItemDirective)}",
    );

    final bool checkBusyTrue = true;
    executionTrace.addNonControllableCall(
      codeId: "#069100",
      caller: this,
      methodName: "_checkBeforeSetItemAsCurrent",
      suffixShortDesc: "",
      parameters: {
        "checkBusy": checkBusyTrue,
        "errCodeIfItemIsNull": errCodeIfItemIsNull,
      },
    );

    final Actionable<BlockSetCurrentItemPrecheck> actionable =
        _checkBeforeSetItemAsCurrent(
      item: item,
      errCodeIfItemIsNull: errCodeIfItemIsNull,
      checkBusy: checkBusyTrue,
    );

    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#069200",
        prefixShortDesc: '_checkBeforeSetItemAsCurrent()',
        module: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>(
        precheck: actionable.errCode,
        setCurrentItemDirective: setCurrentItemDirective,
        candidateItem: item,
        oldCurrentItem: currentItem,
        currentItem: currentItem,
      );
    }

    return await __dispatchSetItemAsCurrentAfterPrecheck(
      executionTrace: executionTrace,
      item: item!,
      forceLoadItem: forceLoadItem,
      formContextAvailability: formContextAvailability,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Dispatches the internal set-current-item execution unit after precheck passes.
  ///
  /// When [formContextAvailability] is [FormContextAvailability.assumeAvailable]
  /// and this block has a [formModel], the execution
  /// behaves as if a [BlockFormView] is actively visible (using [FormLoadHint.forceIfNeed]).
  Future<BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>>
      __dispatchSetItemAsCurrentAfterPrecheck({
    required ExecutionTrace executionTrace,
    required ITEM item,
    required bool forceLoadItem,
    required FormContextAvailability formContextAvailability,
  }) async {
    final bool effectiveWithFormContext =
        formContextAvailability == FormContextAvailability.assumeAvailable &&
            formModel != null;
    final BlockSetCurrentItemDirective setCurrentItemDirective =
        effectiveWithFormContext
            ? BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm
            : BlockSetCurrentItemDirective.setAnItemAsCurrent;

    executionTrace.addInfo(
      codeId: "#069300",
      shortDesc: "Creating <b>_XShelfBlockSetItemAsCurrent</b>...",
    );

    final XShelf xShelf = _XShelfBlockSetItemAsCurrent(block: block);
    final thisXBlockCurrentItemModel =
        xShelf.findXBlockCurrentItemModelByName(name)
            as XBlockCurrentItemModel<ID, ITEM, ITEM_DETAIL, FORM_PATCH>;

    final executionIntent = thisXBlockCurrentItemModel
        ._createAndSetBlockCurrentItemModelExecutionIntentSetCurrentItem(
      setCurrentItemDirective: setCurrentItemDirective,
      newQueriedList: [],
      inputCandidateCurrItem: item,
      forceReloadItem: forceLoadItem,
      formLoadHint: effectiveWithFormContext
          ? FormLoadHint.forceIfNeed
          : FormLoadHint.auto,
    );

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockClearCurrentItemPrecheck> _checkBeforeClearCurrentItem({
    required bool checkBusy,
  }) {
    return BlockClearCurrentItemPrecheckUtils.checkBeforeClearCurrentItem<ITEM>(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      currentItem: currentItem,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockRefreshCurrentItemPrecheck> _checkBeforeRefreshCurrentItem({
    required bool checkBusy,
  }) {
    return BlockRefreshCurrentItemPrecheckUtils.checkBeforeRefreshCurrentItem<
        ITEM>(
      currentItem: currentItem,
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      findItemSameIdWith: (targetItem) =>
          block.findItemSameIdWith(item: targetItem),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshRefreshingCurrentItemState({
    required bool isRefreshingCurrentItem,
  }) {
    try {
      __isRefreshingCurrentItem = isRefreshingCurrentItem;
      block.ui.refreshControlBars(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshPreparingFormCreationState({
    required bool isPreparingFormCreation,
  }) {
    try {
      __isPreparingFormCreation = isPreparingFormCreation;
      block.ui.refreshControlBars(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  // @seeAlso: _checkBeforeRefreshCurrentItem()
  Actionable<BlockSetCurrentItemPrecheck> _checkBeforeSetItemAsCurrent({
    required ITEM? item,
    required bool checkBusy,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
  }) {
    return BlockSetCurrentItemPrecheckUtils.checkBeforeSetItemAsCurrent<ITEM>(
      item: item,
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      errCodeIfItemIsNull: errCodeIfItemIsNull,
      findItemSameIdWith: (targetItem) =>
          block.findItemSameIdWith(item: targetItem),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemCreationPrecheck> _checkBeforeCreateItemOnForm({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    return BlockItemCreationPrecheckUtils.checkBeforeCreateItemOnForm(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      hasForm: formModel != null,
      blockDataState: block.dataState,
      checkAllow: checkAllow,
      checkCreationAllowed: () => block._checkCreateItemOnFormAllowed(),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockFormResetPrecheck> _checkBeforeResetForm({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    return BlockFormResetPrecheckUtils.checkBeforeResetForm(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      hasForm: formModel != null,
      formDataState: formModel?.dataState,
      isDirty: formModel?.isDirty() ?? false,
      checkAllow: checkAllow,
      checkFormResetAllowed: () => _checkFormResetAllowed(),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows resetting the form or not...
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult _checkFormResetAllowed() {
    try {
      bool allow = block.isFormResetAllowed();
      return allow ? CheckAllowResult.allowed() : CheckAllowResult.notAllowed();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        errorInfo: ErrorInfo.fromError(
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockFormSavePrecheck> _checkBeforeSaveForm({
    required bool checkBusy,
    required bool checkValidate,
  }) {
    return BlockFormSavePrecheckUtils.checkBeforeSaveForm(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      hasForm: formModel != null,
      formDataState: formModel?.dataState,
      isDirty: formModel?.isDirty() ?? false,
      checkValidate: checkValidate,
      getActiveFormStates: formModel != null
          ? () => formModel!.ui._visibleFormBuilderStates
          : null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemEditPrecheck> _checkBeforeEditItemOnForm({
    required bool checkBusy,
    required ITEM? item,
    required bool checkAllow,
  }) {
    return BlockItemEditPrecheckUtils.checkBeforeEditItemOnForm<ITEM>(
      checkBusy: checkBusy,
      isBusy: FlutterArtist.executor.isBusy,
      hasForm: formModel != null,
      blockDataState: block.dataState,
      item: item,
      checkAllow: checkAllow,
      checkItemEditAllowed: (validItem) =>
          block._checkEditItemOnFormAllowed(item: validItem),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemEditPrecheck> _checkBeforeEditCurrentItemOnForm({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    return _checkBeforeEditItemOnForm(
      item: currentItem,
      checkBusy: checkBusy,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXBlockCurrentItemModel(
      XBlockCurrentItemModel thisXBlockCurrentItemModel) {
    if (thisXBlockCurrentItemModel.blockCurrentItemModel != this ||
        thisXBlockCurrentItemModel.name != name) {
      String message =
          "Error Assert BlockCurrentItemModel: ${thisXBlockCurrentItemModel.blockCurrentItemModel} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
