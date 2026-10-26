part of '../core.dart';

class BlockCurrentItemModel<
    ID extends Comparable,
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>,
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria, // EmptyFilterCriteria
    CREATION_PRESET extends CreationPreset, // EmptyCreationPreset
    FORM_INPUT extends FormInput // EmptyFormInput
    > extends _Core {
  String get name => block.name;

  _BlockCurrentData<ID, ITEM, ITEM_DETAIL> _currentData =
      _BlockCurrentData.ofNull();

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
      FILTER_INPUT,
      FILTER_CRITERIA,
      CREATION_PRESET,
      FORM_INPUT> block;

  final BlockFormModel<
      ID, //
      ITEM_DETAIL,
      CREATION_PRESET,
      FORM_INPUT,
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
    required XBlockFormModel<ID, ITEM_DETAIL>? xBlockFormModel,
  }) {
    return XBlockCurrentItemModel<
        ID, //
        ITEM,
        ITEM_DETAIL>(
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
    final ID? activeItemId = _currentData._id;
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
    _blockItemSyncSessionState!.addReceivedEventInfo(
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
    if (!dataState.isStale) {
      executionTrace.addInfo(
        codeId: "#086900",
        shortDesc:
            "Transiting BlockItem dataState to stale for active item ID: $activeItemId",
      );
      _dataState = const BlockItemDataStateStale();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setCurrentDataAndItemDataState({
    required ID? id,
    required ITEM? item,
    required ITEM_DETAIL? itemDetail,
  }) {
    final ID? oldId = _currentData._id;
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
      _dataState = BlockItemDataStateFresh();
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
    if (block.dataState.isNone || _currentData._item == null) {
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
    final ID? activeItemId = _currentData._id;
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
}
