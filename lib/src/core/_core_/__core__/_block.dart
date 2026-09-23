part of '../core.dart';

///
/// Block example:
/// ```dart
/// class EmployeeBlock
///       extends Block<int, EmployeeInfo, EmployeeData,
///                     EmptyFilerInput, EmptyFilterCriteria,
///                     EmptyFormInput, AdditionalFormRelatedData> {
///
/// }
/// ```
/// [ID] is Id Type of Item. For Example: [int].
///
/// [ITEM] is item. For example:
/// ```dart
/// class EmployeeInfo {
///     int id;
///     String name;
///     ...
/// }
/// ```
///
/// [ITEM_DETAIL]: Item Detail.
/// You need to implement [convertItemDetailToItem] method to convert Item-Detail to Item.
/// ```dart
///  class EmployeeData  {
///     int id;
///     String name;
///     String email;
///     String phoneNumber;
/// }
///
/// class EmployeeBlock extends Block<...> {
///
///     EmployeeInfo convertItemDetailToItem({EmployeeData itemDetail}) {
///       return EmployeeInfo(itemDetail.id, itemDetail.name);
///     }
/// }
/// ```
///
/// [FILTER_INPUT]: Additional data to create or modify [FilterModel].
/// ```
/// class EmployeeFilterInput extends FilterInput {
///    String? searchText,
///    int? departmentId;
/// }
/// ```
///
/// [FILTER_CRITERIA]: These are the criteria for filtering the this.data.
///
/// When the [Block.query] or [Scalar.query] method is called,
/// this [FilterCriteria] is created automatically by the [FilterModel]
/// via the [FilterModel.createNewFilterCriteria] method
/// and passed to the [Block.performQuery] or [Scalar.performQuery] method.
/// ```
/// class EmployeeFilterCriteria extends FilterCriteria {
///    String? searchText,
///    DepartmentInfo? department;
/// }
/// ```
///
/// [ADDITIONAL_FORM_RELATED_DATA]: Ancestral Data used for Form.
/// ```
/// class EmployeeFormRelatedData  {
///    final int departmentId;
///    final String departmentName;
/// }
/// ```
///
/// [FORM_INPUT]: Form data are used to create a record in the Form.
/// For example: Create an employee with the specified name,...
/// ```
/// class EmployeeFormInput extends FormInput {
///    String? name;
/// }
/// ```
///
abstract class Block<
    ID extends Comparable,
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>,
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria, // EmptyFilterCriteria
    FORM_INPUT extends FormInput, // EmptyFormInput
    ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData // EmptyAdditionalFormRelatedData
    > extends _Core {
  late final Shelf shelf;

  bool __isQuerying = false;

  bool get isQuerying => __isQuerying;

  bool __isSaving = false;

  bool get isSaving => __isSaving;

  bool __isDeleting = false;

  bool get isDeleting => __isDeleting;

  bool __isRefreshingCurrentItem = false;

  bool get isRefreshingCurrentItem => __isRefreshingCurrentItem;

  bool __isPreparingFormCreation = false;

  bool get isPreparingFormCreation => __isPreparingFormCreation;

  late final _BlockDebugInfo<ID> debug = _BlockDebugInfo<ID>(block: this);

  final BlockConfig config;

  final BlockEffectiveConfig effectiveConfig;

  // TODO: LOGIC-01
  final bool _alwaysTrySelectAnItemAsCurrent = true;

  bool get alwaysTrySelectAnItemAsCurrent => _alwaysTrySelectAnItemAsCurrent;

  ///
  /// Block name. It is unique in a Shelf.
  ///
  final String name;

  String get _shortPathName {
    return "${shelf.name} > $name";
  }

  String get pathInfo {
    return "block > ${shelf.name} > $name";
  }

  final String? description;

  ///
  /// FilterModel Name registered in [Shelf.defineShelfStructure()] method.
  ///
  final String? registeredFilterModelName;

  ///
  /// This field is not null.
  /// If this block does not declare a [FilterModel], it will have the default [FilterModel].
  ///
  late final FilterModel<FILTER_INPUT, FILTER_CRITERIA>
      _registeredOrDefaultFilterModel;

  ///
  /// This field is not null.
  /// If this block does not declare a [FilterModel], it will have the default [FilterModel].
  ///
  FilterModel<FILTER_INPUT, FILTER_CRITERIA>
      get registeredOrDefaultFilterModel => _registeredOrDefaultFilterModel;

  ///
  /// Returns a FilterModel declared in the [Shelf.defineShelfStructure()] method.
  /// The return value may be null.
  ///
  FilterModel<FILTER_INPUT, FILTER_CRITERIA>? get filterModel {
    if (_registeredOrDefaultFilterModel is _DefaultFilterModel) {
      return null;
    } else {
      return _registeredOrDefaultFilterModel;
    }
  }

  late final Block? parent;

  String? get parentBlockName => parent?.name;

  bool get isRoot => parent == null;

  Block get rootBlock {
    if (parent == null) {
      return this;
    }
    return parent!.rootBlock;
  }

  bool isSameWith(Block other) {
    if (shelf.name != other.shelf.name) {
      return false;
    }
    if (name == other.name) {
      return true;
    }
    return false;
  }

  bool isAncestorOf(Block other) {
    if (shelf.name != other.shelf.name) {
      return false;
    }
    if (name == other.name) {
      return false;
    }
    Block b = other;
    while (true) {
      Block? p = b.parent;
      if (p == null) {
        return false;
      }
      if (p.name == name) {
        return true;
      }
      b = p;
    }
  }

  bool isDescendantOf(Block other) {
    return other.isAncestorOf(this);
  }

  final BlockFormModel<
      ID, //
      ITEM_DETAIL,
      FORM_INPUT,
      ADDITIONAL_FORM_RELATED_DATA>? formModel;

  final List<Block> _childBlocks;

  List<Block> get childBlocks => List.unmodifiable(_childBlocks);

  List<Block> get descendantBlocks {
    List<Block> ret = [];
    for (Block childBlock in _childBlocks) {
      ret.add(childBlock);
      ret.addAll(childBlock.descendantBlocks);
    }
    return ret;
  }

  List<Block> get descendantBlocksWithSameFilterModel {
    if (filterModel == null) {
      return [];
    }
    List<Block> ret = [];
    for (Block childBlock in _childBlocks) {
      if (childBlock.filterModel != null) {
        if (filterModel!.name == childBlock.filterModel!.name) {
          ret.add(childBlock);
        }
      }
      ret.addAll(childBlock.descendantBlocksWithSameFilterModel);
    }
    return ret;
  }

  List<Block> get ancestorBlocks {
    return ascendingAncestorBlocks.reversed.toList();
  }

  ///
  /// Ancestor Blocks + this Block + descendant Blocks.
  ///
  List<Block> get lineageBlocks {
    return <Block>[...ancestorBlocks, this, ...descendantBlocks];
  }

  ///
  /// Ascending ancestor blocks.
  ///
  List<Block> get ascendingAncestorBlocks {
    List<Block> list = [];
    Block blk = this;
    while (true) {
      Block? p = blk.parent;
      if (p == null) {
        break;
      }
      list.add(p);
      blk = p;
    }
    return list;
  }

  ///
  /// Descending ancestor blocks.
  ///
  List<Block> get descendingAncestorBlocks {
    return ascendingAncestorBlocks.reversed.toList();
  }

  QueryType _lastQueryType = QueryType.realQuery;

  late final _blockData = _BlockData<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FILTER_INPUT,
      FILTER_CRITERIA,
      ADDITIONAL_FORM_RELATED_DATA,
      FORM_INPUT>._(
    block: this,
    pageable: config.pageable,
    nativeQueryMode: effectiveConfig.nativeQueryMode,
  );

  /// Indicates whether the block or its underlying filter model currently has an active error.
  bool get hasError {
    return blockErrorInfo != null || filterErrorInfo != null;
  }

  /// Resolves the active [BlockErrorInfo] attached to this block, if any.
  BlockErrorInfo? get blockErrorInfo {
    return switch (dataState) {
      BlockDataStatePending(:final errorInfo?) => errorInfo,
      BlockDataStateLoadedStale(:final errorInfo?) => errorInfo,
      _ => null,
    };
  }

  ErrorInfo? get filterErrorInfo {
    return filterModel?.errorInfo;
  }

  late final ui = _BlockUiComponents(block: this);

  // ***************************************************************************
  // *** DATA STATE ************************************************************
  // ***************************************************************************

  ///
  /// ```dart
  /// if(thisBlock.lastQueryResult == null) {
  ///   ...
  /// } else if(thisBlock.lastQueryResult is YourType) {
  ///   ...
  /// } else {
  ///   // Empty PageData<I>.
  ///   // Occurs if there is no "Item" currently selected on the parent Block
  ///   // or this Block was previously in Lazy Query State.
  /// }
  /// ```
  ///
  PageData<ITEM>? get lastQueryResult => _blockData._lastQueryResult;

  ActionResultState? get lastQueryResultState =>
      _blockData._lastQueryResultState;

  BlockDataState get dataState => _blockData._blockDataState;

  BlockItemDataState get blockItemDataState => _blockData._blockItemDataState;

  /// Does the FilterPanel contain uncommitted draft criteria that differs
  /// from the currently applied dataset criteria?
  bool get hasUnappliedFilter =>
      filterModel != null &&
      filterModel!.committedFilterCriteria != filterCriteria;

  // nearestAncestorNonNoneDataState?
  BlockDataState get ancestralNonNoneDataState {
    if (parent == null) {
      return BlockDataStateLoadedFresh();
    }
    if (parent!.dataState is BlockDataStateNone) {
      return parent!.dataState;
    }
    return parent!.ancestralNonNoneDataState;
  }

  FormMode? get formMode {
    if (formModel == null) {
      return null;
    }
    return formModel!.formMode;
  }

  late final SortModel<ITEM>? _clientSideSortModel;

  late final SortModel<ITEM>? _serverSideSortModel;

  SortModel<ITEM>? get clientSideSortModel => _clientSideSortModel;

  SortModel<ITEM>? get serverSideSortModel => _serverSideSortModel;

  FILTER_CRITERIA? get filterCriteria =>
      _blockData._filterCriteriaSnapshot?.criteriaOrNull;

  FilterCriteriaSnapshot<FILTER_CRITERIA>? get debugFilterCriteriaSnapshot =>
      _blockData._filterCriteriaSnapshot;

  ///
  /// return a copied list of items.
  ///
  List<ITEM> get items {
    return [..._blockData._items];
  }

  List<ID> get itemIds {
    return items.map((item) => item.id).toList();
  }

  int get itemCount => _blockData._items.length;

  BlockNativeQueryMode get nativeQueryMode => _blockData._nativeQueryMode;

  Pageable? get pageable => _blockData._pageable;

  Pageable? get nextPageable {
    if (_lastQueryType == QueryType.emptyQuery) {
      return _blockData._initialPageable;
    }
    Pageable? p = _blockData._pageable;
    return p?.next();
  }

  PaginationInfo? get paginationInfo {
    return PaginationInfo.copy(_blockData._paginationInfo);
  }

  // ***************************************************************************
  // ***************************************************************************

  _BlockSyncSessionState<ID>? _blockSyncSessionState;

  _BlockSyncSessionState<ID>? get blockSyncSessionState =>
      _blockSyncSessionState;

  _BlockItemSyncSessionState<ID>? _blockItemSyncSessionState;

  _BlockItemSyncSessionState<ID>? get blockItemSyncSessionState =>
      _blockItemSyncSessionState;

  // ***************************************************************************

  void _resetBlockSyncSessionState({
    required ExecutionTrace? executionTrace,
  }) {
    _blockSyncSessionState = null;
  }

  // ***************************************************************************

  void _resetBlockItemSyncSessionState({
    required ExecutionTrace? executionTrace,
  }) {
    _blockItemSyncSessionState = null;
  }

  // ***************************************************************************

  /// Manages dataset sync session instantiation, appends the received event info,
  /// records viewport synchronization strategies, and recalculates [dataState].
  void _updateBlockSyncSessionState({
    required ExecutionTrace executionTrace,
    required EventSourceType eventSourceType,
    required List<Type> mainDataTypes,
    required List<Type> extraDataTypes,
    required BlockViewportSyncStrategy? syncStrategyOnFullQueryMode,
    required BlockViewportSyncStrategy? syncStrategyOnPageableQueryMode,
    required List<ID> effectedItemIds,
    required bool requiresMaxSyncStrategy,
  }) {
    executionTrace.addNonControllableCall(
      codeId: "#86100",
      caller: this,
      methodName: "_updateBlockSyncSessionState",
      suffixShortDesc: "",
      parameters: {
        "eventSourceType": eventSourceType,
        "mainDataTypes": mainDataTypes,
        "extraDataTypes": extraDataTypes,
        "syncStrategyOnFullQueryMode": syncStrategyOnFullQueryMode,
        "syncStrategyOnPageableQueryMode": syncStrategyOnPageableQueryMode,
        "effectedItemIds": effectedItemIds,
        "requiresMaxSyncStrategy": requiresMaxSyncStrategy,
      },
    );

    // 1. Initialize or reset session if boundary constraints (filter criteria or parent context) shifted
    if (_blockSyncSessionState == null ||
        _blockSyncSessionState!.filterCriteria != filterCriteria ||
        _blockSyncSessionState!.parentBlockItemId != parent?.currentItemId) {
      _blockSyncSessionState = _BlockSyncSessionState<ID>(
        block: this,
        parentItemId: parent?.currentItemId,
        filterCriteria: filterCriteria,
      );
    }

    // 2. Append received event metadata and resolved viewport strategies into the session
    _blockSyncSessionState!.addReceivedEventInfo(
      eventSourceType: eventSourceType,
      requiresMaxSyncStrategy: requiresMaxSyncStrategy,
      syncStrategyOnFullQueryMode: syncStrategyOnFullQueryMode,
      syncStrategyOnPageableQueryMode: syncStrategyOnPageableQueryMode,
      mainDataTypes: mainDataTypes,
      extraDataTypes: extraDataTypes,
      effectedItemIds: effectedItemIds,
    );

    executionTrace.addInfo(
      codeId: "#86200",
      shortDesc: "Added BlockReceivedEventInfo to dataset sync session",
    );

    // 3. Recalculate BlockDataState upon incoming event invalidation
    final nextState = BlockDataStateUtils.calculateNewLazyDataState(
      currentBlockDataState: dataState,
      hasParentItem: parent == null || parent!.currentItem != null,
      isRootBlock: isRoot,
      parentItemChanged: false,
      filterCriteriaChanged: false,
      hasIncomingEvent: true,
    );

    if (nextState != dataState) {
      _blockData._setBlockDataState(newBlockDataState: nextState);
      executionTrace.addInfo(
        codeId: "#86300",
        shortDesc:
            "Transitioned Block dataState to $nextState due to BlockSyncSession update",
      );
    }
  }

  /// Manages item sync session instantiation, appends the received event info targeting
  /// the active [currentItem], and marks [blockItemDataState] as stale.
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
      codeId: "#86700",
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
        block: this,
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
      codeId: "#86800",
      shortDesc: "Added BlockReceivedEventInfo to active item sync session",
    );

    // 3. Mark the BlockItemDataState as stale to prompt an in-place currentItem reload
    if (!blockItemDataState.isStale) {
      _blockData._setBlockItemDataState(
        newBlockItemDataState: const BlockItemDataStateStale(),
      );
      executionTrace.addInfo(
        codeId: "#86900",
        shortDesc:
            "Transitioned BlockItem dataState to stale for active item ID: $activeItemId",
      );
    }
  }

  // ***************************************************************************

  /// Manages item-level sync session instantiation, appends received events,
  /// and marks the active item's selection data state as stale.
  void _updateItemSyncSessionState({
    required ExecutionTrace executionTrace,
    required XBlock? xBlock,
    required EventSourceType eventSourceType,
    required List<Type> eventDataTypes,
    required List<ID>? addedEffectiveIds,
  }) {
    final ID? activeItemId = currentItemId;
    if (activeItemId == null) {
      return;
    }

    executionTrace.addNonControllableCall(
      codeId: "#83700",
      caller: this,
      methodName: "_updateItemSyncSessionState",
      suffixShortDesc: "",
      parameters: {
        "eventSourceType": eventSourceType,
        "activeItemId": activeItemId,
        "addedEffectiveIds": addedEffectiveIds,
      },
    );

    // Initialize or reset session if target item identity changed
    if (_blockItemSyncSessionState == null ||
        !_blockItemSyncSessionState!.isValidFor(activeItemId)) {
      _blockItemSyncSessionState = _BlockItemSyncSessionState<ID>(
        block: this,
        targetItemId: activeItemId,
      );
    }

    // Append received event metadata to current item sync session
    _blockItemSyncSessionState?.addReceivedEventInfo(
      eventSourceType: eventSourceType,
      mainDataTypes: eventDataTypes,
      extraDataTypes: [],
      effectedItemIds: addedEffectiveIds ?? <ID>[],
    );

    // Transition the selection data state to stale
    _blockData._blockItemDataState = const BlockItemDataStateStale();

    // Mark XBlock to force reload the current item on next scheduler sweep
    xBlock?.setForceReloadCurrItem(true);

    executionTrace.addInfo(
      codeId: "#83750",
      shortDesc:
          "${debugObjHtml(this)} - marked current item ($activeItemId) as stale due to event reaction",
    );
  }

  // ***************************************************************************

  bool _hasReactionBookmark() {
    return _blockSyncSessionState != null || _blockItemSyncSessionState != null;
  }

  bool _isMatchBlockSyncSessionState(
      _BlockSyncSessionState? blockSyncSessionState) {
    if (blockSyncSessionState == null) {
      return false;
    }
    return blockSyncSessionState.parentBlockItemId ==
            parentBlockCurrentItemId &&
        blockSyncSessionState.filterCriteria == filterCriteria;
  }

  // ***************************************************************************
  // *** Constructor ***********************************************************
  // ***************************************************************************

  Block({
    required this.name,
    required this.description,
    required BlockConfig config,
    required String? filterModelName,
    required this.formModel,
    required List<Block>? childBlocks,
    SortModelBuilder<ITEM>? sortModelBuilder,
  })  : registeredFilterModelName = filterModelName,
        config = config.copy(),
        effectiveConfig = BlockEffectiveConfig._fromConfig(config),
        _childBlocks = childBlocks ?? [] {
    for (Block childBlock in _childBlocks) {
      childBlock.parent = this;
    }
    formModel?.block = this;
    //
    _serverSideSortModel = sortModelBuilder?.createServerSideSortModel();
    _clientSideSortModel =
        config.clientSideSortStrategy != SortStrategy.modelBased
            ? null
            : sortModelBuilder?.createClientSideSortModel();
    _serverSideSortModel?.block = this;
    _clientSideSortModel?.block = this;
  }

  // ***************************************************************************

  XBlock<ID, ITEM, ITEM_DETAIL> _createXBlock({
    required XFilterModel xFilterModel,
    required XBlockFormModel? xBlockFormModel,
  }) {
    return XBlock<ID, ITEM, ITEM_DETAIL>._(
      block: this,
      xFilterModel: xFilterModel,
      xBlockFormModel: xBlockFormModel,
    );
  }

  // ***************************************************************************

  /// Checks if this Block exposes or is associated with the given [type].
  /// All comments are in English for global users to read.
  bool _exposesDataType(Type type) {
    // 1. Check against the core data types of the Block
    if (type == ITEM || type == ITEM_DETAIL) {
      return true;
    }

    // 2. Check against custom broadcasted events configured in BlockConfig
    // (Mapping to the types this block is explicitly allowed to broadcast)
    if (effectiveConfig.extraBroadcastEvents.any((event) => event == type)) {
      return true;
    }

    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  Set<Type> getDeclaredMainDataTypes() {
    return {ITEM, ITEM_DETAIL};
  }

  Set<Type> getResolvedMainDataTypes() {
    Set<Type> types = getDeclaredMainDataTypes();
    return DataTypeEventUtils.getProjectionsDataTypes(types);
  }

  Set<Type> getDeclaredBroadcastDataTypes() {
    if (!effectiveConfig.eventBroadcastEnabled) {
      return {};
    }
    return {ITEM, ITEM_DETAIL, ...effectiveConfig.extraBroadcastEvents};
  }

  Set<Type> getDeclaredMainBroadcastDataTypes() {
    if (!effectiveConfig.eventBroadcastEnabled) {
      return {};
    }
    return getDeclaredMainDataTypes();
  }

  Set<Type> getDeclaredExtraBroadcastDataTypes() {
    if (!effectiveConfig.eventBroadcastEnabled) {
      return {};
    }
    return effectiveConfig.extraBroadcastEvents.toSet();
  }

  Set<Type> getResolvedBroadcastDataTypes() {
    if (!effectiveConfig.eventBroadcastEnabled) {
      return {};
    }
    return {
      ...getResolvedMainBroadcastDataTypes(),
      ...getResolvedExtraBroadcastDataTypes()
    };
  }

  Set<Type> getResolvedExtraBroadcastDataTypes() {
    if (!effectiveConfig.eventBroadcastEnabled) {
      return {};
    }
    final declaredTypes = getDeclaredExtraBroadcastDataTypes();
    return DataTypeEventUtils.getProjectionsDataTypes(declaredTypes);
  }

  Set<Type> getResolvedMainBroadcastDataTypes() {
    if (!effectiveConfig.eventBroadcastEnabled) {
      return {};
    }
    final mainTypes = getDeclaredMainBroadcastDataTypes();
    return DataTypeEventUtils.getProjectionsDataTypes(mainTypes);
  }

  Set<Type> getResolvedMainReactionDataTypes() {
    if (!effectiveConfig.eventReactionEnabled) {
      return {};
    }
    final mainTypes = getDeclaredMainDataTypes();
    return DataTypeEventUtils.getProjectionsDataTypes(mainTypes);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Returns the data types explicitly declared in the configuration
  /// that this block should react to.
  Set<Type> getDeclaredReactionDataTypes({
    required BlockReactionTarget? target,
  }) {
    return effectiveConfig.reactions
        .where((reaction) => target == null || reaction.target == target)
        .map((r) => r.dataType)
        .toSet();
  }

  /// Resolves and returns all data types—including those within the same
  /// [ProjectionFamily]—that will actually trigger a reaction in this block.
  Set<Type> getResolvedReactionDataTypes({
    required BlockReactionTarget? target,
  }) {
    final declaredTypes = getDeclaredReactionDataTypes(target: target);
    return DataTypeEventUtils.getProjectionsDataTypes(declaredTypes);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isPendingOrStale({required bool requiresVisible}) {
    final bool visible = ui.hasVisibleViews(includeDescendants: true);
    if (requiresVisible) {
      if (!visible) {
        return false;
      }
    }
    return dataState.isPending || dataState.isStale;
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Rename (+ `Visible` in name)
  bool hasAccumulatedEvents() {
    if (_blockSyncSessionState == null && _blockItemSyncSessionState == null) {
      return false;
    }
    return ui.hasVisibleViews(includeDescendants: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Entry point called when this Block receives an event targeted specifically
  /// at the active [currentItem] level (e.g., [BlockReactionTarget.currentItem]).
  ///
  /// This bypasses dataset queries and instead updates the [_blockItemSyncSessionState],
  /// marking the active item data state as stale to command an in-place detail refresh.
  void _receiveEventAtItemLevel({
    required ExecutionTrace executionTrace,
    required EventSourceType eventSourceType,
    required EventDataKind eventDataKind,
    required List<Type> eventDataTypes,
    required List<ID>? effectedItemIds,
  }) {
    // 1. Guard against inactive item states or uninitialized blocks
    if (dataState.isNone || currentItem == null) {
      return;
    }

    if (eventDataTypes.isEmpty) {
      return;
    }

    // 2. Resolve data types that this block listens to for currentItem reactions
    final Set<Type> currentItemReactionTypes =
        getResolvedReactionDataTypes(target: BlockReactionTarget.currentItem);

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
        return; // Current item ID is unaffected by this specific mutation
      }
    }

    executionTrace.addNonControllableCall(
      codeId: "#86500",
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
      extraDataTypes:
          eventDataKind == EventDataKind.extra ? eventDataTypes : [],
      effectedItemIds:
          effectedItemIds ?? (activeItemId != null ? [activeItemId] : []),
    );
  }

  /// Entry point called when this Block receives an event targeted at the dataset level
  /// (e.g., [BlockReactionTarget.block]).
  ///
  /// Manages session instantiation, appends the received event info, records viewport
  /// strategies, and recalculates the structural [dataState].
  void _receiveEventAtBlockLevel({
    required ExecutionTrace executionTrace,
    required EventSourceType eventSourceType,
    required EventDataKind eventDataKind,
    required List<Type> eventDataTypes,
    required BlockViewportSyncStrategy? syncStrategyOnFullQueryMode,
    required BlockViewportSyncStrategy? syncStrategyOnPageableQueryMode,
    required List<ID>? effectedItemIds,
  }) {
    // 1. Inactive blocks in 'none' state do not accumulate background events
    if (dataState.isNone) {
      return;
    }

    if (eventDataTypes.isEmpty) {
      return;
    }

    // 2. Resolve dataset-level reaction types
    final Set<Type> blockReactionTypes =
        getResolvedReactionDataTypes(target: BlockReactionTarget.block);

    if (blockReactionTypes.isEmpty) {
      return;
    }

    final bool isEffected = DataTypeEventUtils.hasIntersection(
      blockReactionTypes,
      eventDataTypes.toSet(),
    );

    if (!isEffected) {
      return;
    }

    executionTrace.addNonControllableCall(
      codeId: "#87000",
      caller: this,
      methodName: "_updateBlockSyncSessionState",
      suffixShortDesc: "",
      parameters: {
        "eventSourceType": eventSourceType,
        "eventDataKind": eventDataKind,
        "eventDataTypes": eventDataTypes,
        "syncStrategyOnFullQueryMode": syncStrategyOnFullQueryMode,
        "syncStrategyOnPageableQueryMode": syncStrategyOnPageableQueryMode,
        "effectedItemIds": effectedItemIds,
      },
    );

    // 3. Accumulate event metadata and transition BlockDataState to stale
    _updateBlockSyncSessionState(
      executionTrace: executionTrace,
      eventSourceType: eventSourceType,
      mainDataTypes: eventDataKind == EventDataKind.main ? eventDataTypes : [],
      extraDataTypes:
          eventDataKind == EventDataKind.extra ? eventDataTypes : [],
      syncStrategyOnFullQueryMode: syncStrategyOnFullQueryMode,
      syncStrategyOnPageableQueryMode: syncStrategyOnPageableQueryMode,
      effectedItemIds: effectedItemIds ?? [],
      requiresMaxSyncStrategy: syncStrategyOnFullQueryMode != null ||
          syncStrategyOnPageableQueryMode != null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearItemsWithDataState({
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockDataState blockDataState,
    required bool currentHasPendingInvalidation,
    required FormDataState formDataState,
    required bool errorInFilter,
    required bool resetSyncSessionState,
    required bool resetRefreshItemCondition,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    // 🛑 RESET
    //
    // thisXBlock.resetExecutionHints();
    //
    _blockData._clearItemsWithDataState(
      blockDataState: blockDataState,
      errorInFilter: errorInFilter,
      resetSyncSessionState: resetSyncSessionState,
      resetRefreshItemCondition: resetRefreshItemCondition,
    );
    _blockData._setBlockItemDataState(
      newBlockItemDataState: BlockItemDataStateNone(),
    );
    //
    if (formModel != null) {
      formModel!._clearDataWithDataState(formDataState: formDataState);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearWithDataStateAndChildrenToNonCascade({
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockDataState blkDataState,
    required bool currentHasPendingInvalidation,
    required FormDataState frmDataState,
    required bool errorInFilter,
    required bool resetSyncSessionState,
    required bool resetRefreshItemCondition,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    __clearItemsWithDataState(
      thisXBlock: thisXBlock,
      blockDataState: blkDataState,
      currentHasPendingInvalidation: currentHasPendingInvalidation,
      formDataState: frmDataState,
      errorInFilter: errorInFilter,
      resetSyncSessionState: resetSyncSessionState,
      resetRefreshItemCondition: resetRefreshItemCondition,
    );
    //
    for (var childXBlock in thisXBlock.childXBlocks) {
      childXBlock.block.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: childXBlock,
        blkDataState: BlockDataStateNone(),
        currentHasPendingInvalidation: false,
        frmDataState: FormDataStateNone(),
        errorInFilter: false,
        resetSyncSessionState: true,
        resetRefreshItemCondition: true,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearAllChildrenBlocksToNone({
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    for (var childXBlock in thisXBlock.childXBlocks) {
      childXBlock.block.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: childXBlock,
        blkDataState: BlockDataStateNone(),
        currentHasPendingInvalidation: false,
        frmDataState: FormDataStateNone(),
        errorInFilter: false,
        resetSyncSessionState: true,
        resetRefreshItemCondition: true,
      );
    }
  }

  void __clearAllChildrenBlocksToPending({
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    for (var childXBlock in thisXBlock.childXBlocks) {
      childXBlock.block.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: childXBlock,
        blkDataState: BlockDataStatePending(),
        currentHasPendingInvalidation: false,
        frmDataState: FormDataStateNone(),
        errorInFilter: false,
        resetSyncSessionState: true,
        resetRefreshItemCondition: true,
      );
    }
  }

  // ***************************************************************************
  // ************ TYPES ********************************************************
  // ***************************************************************************

  Type getItemIdType() {
    return ID;
  }

  Type getItemType() {
    return ITEM;
  }

  Type getItemDetailType() {
    return ITEM_DETAIL;
  }

  Type getFilterInputType() {
    return FILTER_INPUT;
  }

  Type getFilterCriteriaType() {
    return FILTER_CRITERIA;
  }

  Type getFormInputType() {
    return FORM_INPUT;
  }

  Type getFormRelatedDataType() {
    return ADDITIONAL_FORM_RELATED_DATA;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _broadcastBlockHidden() {
    // FlutterArtist.codeFlowLogger._addEvent(
    //   ownerClassInstance: this,
    //   event: "Block '${getClassName(this)}' just hides all UI Components!",
    //   isLibCode: true,
    // );
    if (effectiveConfig.onHideAction == BlockHiddenAction.clear) {
      Future.delayed(
        const Duration(seconds: 0),
        () {
          clearItems();
        },
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_BlockClearItemsAnnotation()
  Future<void> _unitClearItems({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockClearItemsIntent<ID, ITEM, ITEM_DETAIL> executionIntent,
  }) async {
    __assertThisXBlock(thisXBlock);
    thisXBlock._createAndSetBlockExecutionIntentDone(
      lastIntentInfo: "Clear Items",
    );
    //
    executionTrace.addInfo(
      codeId: "#07000",
      shortDesc:
          "Begin ${debugObjHtml(this)} > ${executionUnitType.asDebugExecutionUnit()}.",
    );
    executionTrace.addInfo(
      codeId: "#07020",
      shortDesc:
          "Clear all item of ${debugObjHtml(this)} and set to <b>pending</b>. "
          "Clear all data of child blocks and set them to <b>none</b>."
          "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
    );
    //
    executionIntent.resultWrapper._setResult(
      BlockClearItemsResult(precheck: null),
      objectCaller: this,
      methodName: '_unitClearItems',
    );
    __clearWithDataStateAndChildrenToNonCascade(
      thisXBlock: thisXBlock,
      blkDataState: BlockDataStatePending(),
      currentHasPendingInvalidation: false,
      frmDataState: FormDataStateNone(),
      errorInFilter: false,
      resetSyncSessionState: true,
      resetRefreshItemCondition: true,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_BlockClearCurrentItemAnnotation()
  Future<void> _unitClearCurrentItem({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockClearCurrentItemIntent<ID, ITEM, ITEM_DETAIL> executionIntent,
  }) async {
    __assertThisXBlock(thisXBlock);
    thisXBlock._createAndSetBlockExecutionIntentDone(
        lastIntentInfo: "Clear Current Item");
    //
    executionTrace.addInfo(
      codeId: "#13000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()}",
    );
    //
    executionTrace.addInfo(
      codeId: "#13100",
      shortDesc: "${debugObjHtml(this)} -> set currentItem to null.",
    );
    executionIntent.resultWrapper._setResult(
      BlockClearCurrentItemResult(precheck: null),
      objectCaller: this,
      methodName: '_unitClearCurrentItem',
    );
    //
    __setCurrentItemOnlyAndItemState(
      id: null,
      item: null,
      itemDetail: null,
    );
    //
    if (formModel != null) {
      executionTrace.addInfo(
        codeId: "#13200",
        shortDesc:
            "${debugObjHtml(formModel)} clear data and set state to <b>none</b>.",
      );
      formModel!._clearDataWithDataState(formDataState: FormDataStateNone());
    }
    //
    executionTrace.addInfo(
      codeId: "#13400",
      shortDesc: "Clear data of all child blocks and set them to <b>none</b>."
          "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
    );
    // Test Case: [38b].
    __clearAllChildrenBlocksToNone(
      thisXBlock: thisXBlock,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_BlockQueryAnnotation()
  @_BlockQueryMorePageAnnotation()
  @_BlockQueryNextPageAnnotation()
  @_BlockQueryPreviousPageAnnotation()
  @_BlockQueryAndPrepareToEditAnnotation()
  @_BlockQueryAndPrepareToCreateAnnotation()
  Future<void> _unitQuery({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockQueryIntent<ID, ITEM, ITEM_DETAIL> executionIntent,
  }) async {
    __assertThisXBlock(thisXBlock);

    final QueryHint initialQueryHint = thisXBlock.queryHint;
    final bool applyForceReloadCurrItem = thisXBlock.forceReloadCurrItem;

    thisXBlock._setQueriedTrue();
    thisXBlock._createAndSetBlockExecutionIntentDone(lastIntentInfo: "Query");
    thisXBlock.resetExecutionHints();

    executionTrace.addInfo(
      codeId: "#03000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()}.",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      BlockQueryResult._(),
      objectCaller: this,
      methodName: '_unitQuery',
    );

    final XFilterModel xFilterModel = thisXBlock.xFilterModel;
    final FilterModel filterModel = xFilterModel.filterModel;
    final FilterCriteriaSnapshot<FILTER_CRITERIA>?
        committedFilterCriteriaSnapshot =
        filterModel._committedFilterCriteriaSnapshot
            as FilterCriteriaSnapshot<FILTER_CRITERIA>?;

    final bool provideBlockContext =
        ui.hasBlockContext(includeDescendants: true);

    executionTrace.addInfo(
      codeId: "#03020",
      shortDesc: "@provideBlockContext: ${debugObjHtml(provideBlockContext)}.",
      tipDocument: TipDocument.blockActiveUiComponents,
    );

    // =========================================================================
    // 1. UNIFIED STRATEGY RESOLUTION (SINGLE SOURCE OF TRUTH)
    // =========================================================================
    final DebugBlockSyncSessionState<ID>? currentSyncSessionState =
        _blockSyncSessionState;

    final BlockQueryPlan<ID> queryPlan =
        BlockQueryStrategyResolver.resolveQueryPlan<ID>(
      block: this,
      syncSessionState: currentSyncSessionState,
      queryHint: initialQueryHint,
      provideBlockContext: provideBlockContext,
    );

    final TraceStep step = executionTrace.addInfo(
      codeId: "#03044",
      shortDesc: "Calculated Query Plan (${debugObjHtml(this)}):",
      parameters: {
        "action": queryPlan.action,
        "viewportSyncStrategy": queryPlan.viewportSyncStrategy,
        "targetItemIds (count)": queryPlan.targetItemIds.length,
      },
      snapshot: _blockSyncSessionState == null
          ? null
          : BlockSyncDiagnosticSnapshot<ID>(
              syncSessionState: _blockSyncSessionState,
              blockDataState: dataState,
              effectiveConfig: effectiveConfig,
              itemIds: itemIds,
              parentBlockCurrentItemId: parentBlockCurrentItemId,
              filterCriteria: filterCriteria,
              queryHint: initialQueryHint,
              provideBlockContext: provideBlockContext,
            ),
    );

    // =========================================================================
    // 2. NO-OP SHORT CIRCUIT (PRESERVE VIEWPORT)
    // =========================================================================
    if (queryPlan.action == null) {
      executionTrace.addInfo(
        codeId: "#03060",
        shortDesc:
            "QueryPlan action is NULL -> Skip query execution and preserve active viewport.",
      );

      // Reconciled successfully with zero mutations: Clear event session
      if (_blockSyncSessionState != null) {
        _resetBlockSyncSessionState(executionTrace: executionTrace);
        if (dataState.isStale) {
          _blockData._setBlockDataState(
            newBlockDataState: const BlockDataStateLoadedFresh(),
          );
        }
      }

      // Delegate selection fallback without triggering network mutations
      _handleSelectionWhenQuerySkipped(
        executionTrace: executionTrace,
        thisXBlock: thisXBlock,
        applyForceReloadCurrItem: applyForceReloadCurrItem,
      );
      return;
    }

    // =========================================================================
    // 3. FILTER MODEL VALIDATION & CASCADE ERROR GUARD
    // =========================================================================
    if (committedFilterCriteriaSnapshot == null ||
        committedFilterCriteriaSnapshot.isError) {
      executionTrace.addInfo(
        codeId: "#03260",
        shortDesc:
            "Error in FilterModel of ${debugObjHtml(this)}, keep block data state",
      );
      __stopQueryWithFilterErrorCascade(
        thisXBlock: thisXBlock,
        blockErrorInfo: null,
      );
      return;
    }

    committedFilterCriteriaSnapshot
        as FilterCriteriaSnapshotSuccess<FILTER_CRITERIA>;
    final bool filterCriteriaChanged =
        _blockData._isFilterCriteriaSnapshotChanged(
      newFilterCriteriaSnapshot: committedFilterCriteriaSnapshot,
    );

    final BlockResolvedQueryAction resolvedQueryAction = queryPlan.action!;
    final BlockViewportSyncStrategy viewportSyncStrategy =
        queryPlan.viewportSyncStrategy ?? BlockViewportSyncStrategy.nativeQuery;

    final BlockErrorMethod performQryMethod = switch (resolvedQueryAction) {
      BlockResolvedQueryAction.performQuery => BlockErrorMethod.performQuery,
      BlockResolvedQueryAction.performQueryByItemIds =>
        BlockErrorMethod.performQueryByItemIds,
    };

    executionTrace.addInfo(
      codeId: "#03050",
      shortDesc: "Resolved Execution Action:",
      parameters: {
        "resolvedQueryAction": resolvedQueryAction.name,
        "viewportSyncStrategy": viewportSyncStrategy.name,
        "performQryMethod": performQryMethod.name,
      },
    );

    BlockDataState newBlockDataState = dataState;
    List<ITEM>? queriedItemList;
    PaginationInfo? queriedPaginationInfo;
    final ITEM? candidateCurrItem;
    bool queried = false;

    ActionResultState queryResultState;
    BlockErrorInfo? blkErrorInfo;
    ListUpdateStrategy realListUpdateStrategy;

    final Pageable? willBeUsedPageable =
        thisXBlock.getWillBeUsedPageable(thisXBlock.queryType);
    List<ID>? itemIdsToQry;

    // =========================================================================
    // 4. REMOTE DATA FETCH EXECUTION
    // =========================================================================
    if (thisXBlock.queryType == QueryType.realQuery) {
      executionTrace.addInfo(
        codeId: "#03280",
        shortDesc: "@queryType: ${debugObjHtml(thisXBlock.queryType)}.",
        tipDocument: TipDocument.blockQueryType,
      );

      _blockData._nativeQueryMode = effectiveConfig.nativeQueryMode;
      final QueryType newQueryType = thisXBlock.queryType;
      final bool queryTypeChanged = _lastQueryType != newQueryType;
      _lastQueryType = newQueryType;

      try {
        _blockData._backupManualArrangementBeforeQueryIfNeed();
        __refreshQueryingState(isQuerying: true);

        final SortableCriteria sortableCriteria = serverSideSortModel != null
            ? serverSideSortModel!.sortableCriteria
            : SortableCriteria._empty();

        if (resolvedQueryAction == BlockResolvedQueryAction.performQuery) {
          debug._performQueryCount++;
          debug._lastPerformQueryItemIds = {};
          debug._lastViewportSyncStrategy = queryPlan.viewportSyncStrategy;

          executionTrace.addControllableCall(
            codeId: "#03340",
            caller: this,
            methodName: "performQuery",
            suffixShortDesc: "",
            parameters: {
              "queryType": _lastQueryType,
              "parentBlockCurrentItem": parent?.currentItem,
              "filterCriteria": committedFilterCriteriaSnapshot.criteriaOrNull,
              "sortableCriteria": sortableCriteria,
              "viewportSyncStrategy": debug._lastViewportSyncStrategy,
              "pageable": willBeUsedPageable,
            },
          );

          final ApiResult<PageData<ITEM>?> result = await performQuery(
            parentBlockCurrentItem: parent?.currentItem,
            filterCriteria: committedFilterCriteriaSnapshot.filterCriteria,
            sortableCriteria: sortableCriteria,
            pageable: willBeUsedPageable,
          );

          result.throwIfError();
          queriedItemList = result.data?.items;
          queriedPaginationInfo = result.data?.paginationInfo;
        }
        // resolvedQueryAction == performQueryByItemIds
        else {
          itemIdsToQry = queryPlan.targetItemIds.toList();
          debug._performQueryByItemIdsCount++;
          debug._lastPerformQueryItemIds = queryPlan.targetItemIds;
          debug._lastViewportSyncStrategy = queryPlan.viewportSyncStrategy;

          executionTrace.addControllableCall(
            codeId: "#03350",
            caller: this,
            methodName: "performQueryByItemIds",
            suffixShortDesc: "",
            parameters: {
              "queryType": _lastQueryType,
              "parentBlockCurrentItem": parent?.currentItem,
              "filterCriteria": committedFilterCriteriaSnapshot.criteriaOrNull,
              "sortableCriteria": sortableCriteria,
              "viewportSyncStrategy": debug._lastViewportSyncStrategy,
              "targetItemIds": itemIdsToQry,
            },
          );

          final ApiResult<ListData<ITEM>?> result = await performQueryByItemIds(
            parentBlockCurrentItem: parent?.currentItem,
            filterCriteria: committedFilterCriteriaSnapshot.filterCriteria,
            sortableCriteria: sortableCriteria,
            itemIds: itemIdsToQry,
          );

          result.throwIfError();
          queriedItemList = result.data?.items;
          queriedPaginationInfo = null;
        }

        _resetBlockSyncSessionState(executionTrace: executionTrace);
        queried = true;
        queryResultState = ActionResultState.success;

        executionTrace.addInfo(
          codeId: "#03360",
          shortDesc: "Got @queriedItemList: ${debugObjHtml(queriedItemList)}.",
          tipDocument: TipDocument.pageData,
        );
      } catch (e, stackTrace) {
        queryResultState = ActionResultState.fail;
        queriedItemList = null;
        queriedPaginationInfo = null;

        blkErrorInfo = BlockErrorInfo(
          blockErrorMethod: performQryMethod,
          error: e,
          errorStackTrace: stackTrace,
        );

        final errorInfo = _handleError(
          shelf: shelf,
          methodName: performQryMethod.name,
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: TipDocument.blockPerformQuery,
        );
        executionResult._setErrorInfo(errorInfo: errorInfo);

        executionTrace.addInfo(
          codeId: "#03400",
          shortDesc:
              "The ${debugObjHtml(this)}.${performQryMethod.name}() method was called with an error!",
          errorInfo: errorInfo,
        );
      } finally {
        __refreshQueryingState(isQuerying: false);
      }

      final bool isPageShifting;
      if (willBeUsedPageable == null) {
        isPageShifting = !filterCriteriaChanged;
      } else {
        final int currentPage = _blockData._paginationInfo?.currentPage ?? 0;
        final int targetPage = willBeUsedPageable.page;
        isPageShifting = !filterCriteriaChanged && currentPage != targetPage;
      }

      final calculationInput = BlockQueryCalculatorInput(
        queryResultState: queryResultState,
        blockErrorOrigin: BlockErrorOrigin.directFetch,
        blockErrorInfo: blkErrorInfo,
        currentDataState: dataState,
        syncStrategy: viewportSyncStrategy,
        filterCriteriaChanged: filterCriteriaChanged,
        isQueryMore: executionIntent.isQueryMoreFlow,
        isPageShifting: isPageShifting,
        hasRemoveItemIds: false,
        queryTypeChanged: queryTypeChanged,
        suggestedListUpdateStrategy: thisXBlock.listUpdateStrategy,
      );

      final BlockQueryCalculatorResult calculationResult =
          BlockQueryStateCalculator.calculate(calculationInput);

      realListUpdateStrategy = calculationResult.realListUpdateStrategy;
      newBlockDataState = calculationResult.newBlockDataState;

      if (blkErrorInfo != null) {
        executionTrace.addInfo(
          codeId: "#03460",
          shortDesc:
              "${debugObjHtml(this)} --> Query error -> newBlockDataState: $newBlockDataState",
        );
        _blockData._updateStateAfterQueryError(
          newBlockDataState: newBlockDataState,
        );
        final List<XBlock> descendantXBlocks = thisXBlock.getDescendantXBlocks(
          sameFilterOnly: true,
        );

        __stopDescendantQueryWithError(
          descendantXBlocks: descendantXBlocks,
          blockErrorOrigin: BlockErrorOrigin.directFetch,
        );
        return;
      }
    }
    // thisXBlock.queryType == QueryType.queryEmpty
    else {
      // Empty Query Mode
      debug._lastPerformQueryItemIds = null;
      debug._lastViewportSyncStrategy = null;
      _blockData._nativeQueryMode = effectiveConfig.nativeQueryMode;
      _lastQueryType = thisXBlock.queryType;
      realListUpdateStrategy = ListUpdateStrategy.replace;
      newBlockDataState = const BlockDataStateLoadedFresh();
      queriedItemList = [];
      queriedPaginationInfo = null;
      queryResultState = ActionResultState.success;

      executionTrace.addInfo(
        codeId: "#03500",
        shortDesc: "Debug:",
        parameters: {
          "queryType": _lastQueryType,
          "viewportSyncStrategy": debug._lastViewportSyncStrategy,
          "performQueryItemIds": debug._lastPerformQueryItemIds,
          "queriedItemList": queriedItemList,
          "queriedPaginationInfo": queriedPaginationInfo,
          "queryResultState": queryResultState,
        },
      );
    }

    executionTrace.addInfo(
      codeId: "#03520",
      shortDesc: "Calculated:",
      parameters: {
        "realListUpdateStrategy": realListUpdateStrategy,
      },
    );

    final List<ID> removeItemIds = [];
    if (queriedItemList != null &&
        realListUpdateStrategy == ListUpdateStrategy.merge) {
      if (itemIdsToQry != null && itemIdsToQry.isNotEmpty) {
        for (final ID itmId in itemIdsToQry) {
          final ITEM? found =
              queriedItemList.firstWhereOrNull((it) => it.id == itmId);
          if (found == null) {
            removeItemIds.add(itmId);
          }
        }
      }
    }

    // =========================================================================
    // 5. UPDATE STORAGE & DATASET
    // =========================================================================
    final ITEM? currItem = currentItem;
    try {
      executionTrace.addNonControllableCall(
        codeId: "#03540",
        caller: this,
        methodName: "__processQueryResult",
        suffixShortDesc: "",
        parameters: {
          "committedFilterCriteriaSnapshot": committedFilterCriteriaSnapshot,
          "usedPageable": willBeUsedPageable,
          "queriedItemList": queriedItemList,
          "queriedPaginationInfo": queriedPaginationInfo,
          "queryResultState": queryResultState,
        },
      );
      final processedQueryResult = __processQueryResult(
        usedFilterCriteriaSnapshot: committedFilterCriteriaSnapshot,
        usedPageable: willBeUsedPageable,
        queriedItemList: queriedItemList,
        queriedPaginationInfo: queriedPaginationInfo,
        newBlockDataState: newBlockDataState,
        queryResultState: queryResultState,
      );

      _blockData._updateData(
        executionTrace: executionTrace,
        forceListUpdateStrategy: realListUpdateStrategy,
        processedQueryResult: processedQueryResult,
        removeItemIds: removeItemIds,
      );
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: '__blockData._updateData()',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
      executionTrace.addInfo(
        codeId: "#03560",
        shortDesc: "Update queried data to block --> error.",
        errorInfo: errorInfo,
      );
      return;
    }

    // =========================================================================
    // 6. CURRENT ITEM EVALUATION & DOWNSTREAM SYNCHRONIZATION
    // =========================================================================
    final bool currentItemInList = currItem != null && containsItem(currItem);
    candidateCurrItem = currentItemInList ? currItem : null;

    executionTrace.addInfo(
      codeId: "#03580",
      shortDesc: "@currentItemInList: ${debugObjHtml(currentItemInList)}.",
    );

    if (!currentItemInList) {
      executionTrace.addInfo(
        codeId: "#03600",
        shortDesc: "Set currentItem to <b>null</b>.",
      );
      __setCurrentItemOnlyAndItemState(
        id: null,
        item: null,
        itemDetail: null,
      );

      if (formModel != null) {
        executionTrace.addInfo(
          codeId: "#03610",
          shortDesc:
              "Clear ${debugObjHtml(formModel)} data and set to <b>none</b>.",
        );
        formModel!
            ._clearDataWithDataState(formDataState: const FormDataStateNone());
      }
      executionTrace.addInfo(
        codeId: "#03620",
        shortDesc:
            "Clear data of all child blocks and set them to <b>none</b> state."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      );
      __clearAllChildrenBlocksToNone(thisXBlock: thisXBlock);
    } else {
      switch (newBlockDataState) {
        case BlockDataStateNone():
        case BlockDataStatePending():
        case BlockDataStateLoadedStale():
          __clearAllChildrenBlocksToNone(thisXBlock: thisXBlock);
        case BlockDataStateLoadedFresh():
          break;
      }
    }

    if (thisXBlock.xShelf.naturalMode && formMode == FormMode.creation) {
      executionTrace.addInfo(
        codeId: "#03660",
        shortDesc:
            "This query in naturalMode and formMode is creation --> do nothing.",
      );
      return;
    }

    final BlockAfterQueryDirective afterQueryDirective =
        thisXBlock.afterQueryDirective;
    if (!thisXBlock.xShelf.naturalMode && !queried) {
      return;
    }

    executionTrace.addInfo(
      codeId: "#03700",
      shortDesc: "@afterQueryDirective: ${debugObjHtml(afterQueryDirective)}.",
    );

    if (afterQueryDirective == BlockAfterQueryDirective.clearCurrentItem) {
      executionTrace.addExecutionIntent(
        codeId: "#03720",
        owner: this,
        executionIntentType: BlockClearCurrentItemIntent,
        suffixShortDesc: "@afterQueryDirective",
      );
      thisXBlock._createAndSetBlockExecutionIntentClearCurrentItem();
      return;
    } else if (afterQueryDirective == BlockAfterQueryDirective.createNewItem) {
      executionTrace.addExecutionIntent(
        codeId: "#03740",
        owner: this,
        executionIntentType: BlockPrepareFormToCreateItemIntent,
        suffixShortDesc: "@afterQueryDirective",
      );
      thisXBlock._createAndSetBlockExecutionIntentPrepareFormToCreateItem(
        xBlock: thisXBlock,
        initDirty: false,
        formInput: null,
      );
      return;
    }

    if (itemCount == 0) {
      return;
    }

    final BlockSetCurrentItemDirective setCurrentItemDirective =
        switch (afterQueryDirective) {
      BlockAfterQueryDirective.clearCurrentItem ||
      BlockAfterQueryDirective.createNewItem =>
        throw UnimplementedError("Handled in early returns above."),
      BlockAfterQueryDirective.setAnItemAsCurrentIfNeed =>
        BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed,
      BlockAfterQueryDirective.setAnItemAsCurrent =>
        BlockSetCurrentItemDirective.setAnItemAsCurrent,
      BlockAfterQueryDirective.setAnItemAsCurrentThenLoadForm =>
        BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm,
    };

    executionTrace.addInfo(
      codeId: "#03780",
      shortDesc:
          "Calculated >> @setCurrentItemDirective: ${debugObjHtml(setCurrentItemDirective)}.",
    );
    executionTrace.addExecutionIntent(
      codeId: "#03800",
      owner: this,
      executionIntentType: BlockSetCurrentItemIntent,
      suffixShortDesc: "@afterQueryDirective",
    );

    thisXBlock._createAndSetBlockExecutionIntentSetCurrentItem(
      setCurrentItemDirective: setCurrentItemDirective,
      newQueriedList: queriedItemList ?? [],
      inputCandidateCurrItem: candidateCurrItem,
      forceReloadItem: false,
      formLoadHint: null,
    );
  }

  /// Handles selection fallback when remote query is short-circuited (Action is NULL).
  void _handleSelectionWhenQuerySkipped({
    required ExecutionTrace executionTrace,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required bool applyForceReloadCurrItem,
  }) {
    BlockSetCurrentItemDirective? setCurrentItemDirective;
    final defaultAfterQueryDirective = FlutterArtist.defaultAfterQueryDirective;
    final defaultDirective =
        defaultAfterQueryDirective.toSetCurrentItemDirective();

    if (thisXBlock.xShelf.naturalMode) {
      executionTrace.addInfo(
        codeId: "#03080",
        shortDesc: "Currently, ${debugObjHtml(this)} query in naturalMode.",
      );
      if (formModel?.formMode == FormMode.creation) {
        executionTrace.addInfo(
          codeId: "#03100",
          shortDesc:
              "The ${debugObjHtml(this)} is in creation mode --> cancel query.",
        );
        return;
      }
      setCurrentItemDirective = defaultDirective;
    } else {
      if (thisXBlock.setCurrentItemDirective != null) {
        setCurrentItemDirective = thisXBlock.setCurrentItemDirective!;
      }
    }

    if (currentItem == null && setCurrentItemDirective == null) {
      executionTrace.addInfo(
        codeId: "#03120",
        shortDesc:
            "The block has no currentItem and @setCurrentItemDirective is null --> Cancel query.",
      );
      return;
    }

    executionTrace.addExecutionIntent(
      codeId: "#03140",
      owner: this,
      executionIntentType: BlockSetCurrentItemIntent,
      suffixShortDesc: "",
    );

    thisXBlock._createAndSetBlockExecutionIntentSetCurrentItem(
      setCurrentItemDirective: setCurrentItemDirective ??
          BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed,
      newQueriedList: const [],
      inputCandidateCurrItem: null,
      forceReloadItem: applyForceReloadCurrItem,
      formLoadHint: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_FormModelLoadDataAnnotation()
  @_BlockRefreshCurrentItemAnnotation()
  @_BlockSetItemAsCurrentAnnotation()
  @_BlockSelectNextItemAsCurrentAnnotation()
  @_BlockSelectFirstItemAsCurrentAnnotation()
  @_BlockSelectPreviousItemAsCurrentAnnotation()
  Future<void> _unitSetItemAsCurrent({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required final BlockSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>
        executionIntent,
  }) async {
    __assertThisXBlock(thisXBlock);
    thisXBlock._createAndSetBlockExecutionIntentDone(
      lastIntentInfo: "Set Item As Current",
    );
    //
    final List<ITEM> newQueriedList = executionIntent.newQueriedList;
    final ITEM? inputCandidateCurrItem = executionIntent.inputCandidateCurrItem;
    //
    executionTrace.addInfo(
      codeId: "#28000",
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
        codeId: "#28020",
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
    // In: _unitSetItemAsCurrent
    //
    if (dataState.isPending || dataState.isStale) {
      // This case never runs in normal lifecycle
      print("NEVER RUN: dataState.isPending || dataState.isStale");
      return;
    }
    //
    final ITEM? currItemOrigin = currentItem;
    final ITEM? currItem;
    if (currItemOrigin != null) {
      if (containsItem(currItemOrigin)) {
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
      if (!containsItem(inputCandidateCurrItem)) {
        executionTrace.addInfo(
          codeId: "#28120",
          shortDesc:
              "inputCandidateCurrItem: ${debugObjHtml(inputCandidateCurrItem)} not in the list items of the block.",
        );
        candidateCurrItem = null;
      } else {
        candidateCurrItem = inputCandidateCurrItem;
      }
    }
    int? suggestIdx = specifyItemIndexToSetAsCurrent();
    final ITEM? suggestCandidateItem;
    if (suggestIdx != null) {
      suggestCandidateItem = findItemByIndex(suggestIdx);
    } else {
      suggestCandidateItem = null;
    }
    candidateCurrItem = candidateCurrItem ??
        currItem ??
        newQueriedList.firstOrNull ??
        suggestCandidateItem ??
        firstItem;
    //
    if (candidateCurrItem == null) {
      executionTrace.addInfo(
        codeId: "#28080",
        shortDesc:
            "${debugObjHtml(this)} has no item -> clear all data in child blocks and set them to <b>none</b>."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      );

      // Record transition to null as there are no items available
      blockSetCurrentItemResult.recordCurrentTransition(
        previousItem: currentItem,
        candidateItem: null,
        finalItem: null,
        trigger: CurrentItemTransitionTrigger.resetToNull,
      );

      // Record cascaded state changes for child blocks
      for (final child in thisXBlock.childXBlocks) {
        blockSetCurrentItemResult.recordCascadedEviction(
          childBlockName: child.name,
          targetState: const BlockDataStateNone(),
        );
      }
      //
      _blockData._blockItemDataState = const BlockItemDataStateNone();
      _resetBlockItemSyncSessionState(executionTrace: executionTrace);

      if (formModel != null) {
        formModel!._clearDataWithDataState(formDataState: FormDataStateNone());
      }

      __clearAllChildrenBlocksToNone(
        thisXBlock: thisXBlock,
      );
      return;
    }
    //
    // OK, Now candidateCurrItem is NOT NULl.
    //
    final bool isCandidateCurrentItemInNewQueriedList =
        FaItemsUtils.isListContainItem<ITEM, ID>(
      targetList: newQueriedList,
      item: candidateCurrItem,
      getItemId: _getItemIdInternal,
    );
    //
    final bool provideBlockContext = ui.hasBlockContext(
      includeDescendants: true,
    );
    final bool provideItemContext = ui.hasItemContext(
      includeDescendants: true,
    );
    final bool provideFormContext = ui.hasFormContext();
    final bool inputForceReloadItem = thisXBlock.forceReloadCurrItem;
    final bool currItemMaybeChanged =
        candidateCurrItem.id != currItemOrigin?.id;
    //
    executionTrace.addInfo(
      codeId: "#28640",
      shortDesc: "Debug:",
      parameters: {
        "provideBlockContext": provideBlockContext,
        "provideItemContext": provideItemContext,
        "provideFormContext": provideFormContext,
        "inputForceReloadItem": inputForceReloadItem,
      },
    );
    //
    executionTrace.addSeparator();
    //
    executionTrace.addNonControllableCall(
      codeId: "#28660",
      caller: BlockCurrentItemResolver,
      methodName: "resolveCurrentItem",
      suffixShortDesc: "",
      parameters: {
        "ITEM == ITEM_DETAIL?": ITEM == ITEM_DETAIL,
        "candidateCurrItem": candidateCurrItem,
        "inputForceReloadItem": inputForceReloadItem,
        "provideBlockContext": provideBlockContext,
        "provideItemContext": provideItemContext,
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
      provideBlockContext: provideBlockContext,
      provideItemContext: provideItemContext,
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
        codeId: "#28670",
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
      __setCurrentItemOnlyAndItemState(
        id: null,
        item: null,
        itemDetail: null,
      );
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

      __clearAllChildrenBlocksToNone(
        thisXBlock: thisXBlock,
      );
      return;
    }
    //
    // NOW candidateItemAccepted.
    //
    executionTrace.addInfo(
      codeId: "#28700",
      shortDesc: "Calculated:",
      parameters: {
        "forceReloadItem": forceReloadItem,
        "candidateItemAccepted": candidateItemAccepted,
      },
    );
    //
    final bool isCandidateIsCurrent = isCurrentItem(candidateCurrItem);
    //
    executionTrace.addInfo(
      codeId: "#28720",
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
    final ID candidateCurrItemId = __getItemIdShowErr(
      candidateCurrItem,
      showErr: true,
    );
    ITEM_DETAIL? refreshedCurrentItemDetail = currentItemDetail;

    final bool itemRefreshed;
    if (!forceReloadItem) {
      itemRefreshed = false;
      //
      executionTrace.addInfo(
        codeId: "#28800",
        shortDesc:
            "The candidate ${debugObjHtml(candidateCurrItem)} will not need to be reloaded.",
      );
      final ITEM? candidateCurrItemInNewQueriedList =
          FaItemsUtils.findItemInList(
        item: candidateCurrItem,
        targetList: executionIntent.newQueriedList,
        getItemId: _getItemIdInternal,
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
      final _BlockItem2Wrap? loadedCoupleItem = thisXBlock._getRecentLoadedItem(
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
            codeId: "#28900",
            caller: this,
            methodName: methodName,
            suffixShortDesc: "",
            parameters: {
              "candidateCurrItemId": candidateCurrItemId,
            },
          );
          //
          debug._performLoadItemDetailByIdCount++;
          thisXBlock.currentItemReloadedInSession = true;
          ApiResult<ITEM_DETAIL> result = await performLoadItemDetailById(
            itemId: candidateCurrItemId,
          );
          result.throwIfError();
          //
          refreshedCurrentItemDetail = result.data;
          thisXBlock.setForceReloadCurrItemDone();
          //
          executionTrace.addInfo(
            codeId: "#28920",
            shortDesc:
                "Result --> @refreshedCurrentItemDetail: ${debugObjHtml(refreshedCurrentItemDetail)}.",
          );
        } catch (e, stackTrace) {
          final ErrorInfo errorInfo = _handleError(
            shelf: shelf,
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

          executionTrace.addInfo(
            codeId: "#29000",
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
      executionTrace.addInfo(
        codeId: "#29040",
        shortDesc:
            "Candidate ${debugObjHtml(candidateCurrItem)} seems to have been deleted from the system "
            "--> remove it from the block..",
      );

      blockSetCurrentItemResult.recordEviction(
        item: candidateCurrItem,
        reason: ItemEvictionReason.remoteNotFound,
      );
      // Find sibling before removing..
      final ITEM? siblingItem = findSiblingItem(item: candidateCurrItem);

      // 1.1 Remove the evicted item from the current dataset
      executionTrace.addInfo(
        codeId: "#29060",
        shortDesc: "Remove ${debugObjHtml(candidateCurrItem)} from the list.",
      );
      await __removeItemFromList(
        executionTrace: executionTrace,
        removeItem: candidateCurrItem,
      );
      // Test Case: [04a].
      if (candidateCurrItem.id == currentItem?.id) {
        __setCurrentItemOnlyAndItemState(
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
          codeId: "#29100",
          shortDesc:
              "Found new candidate ${debugObjHtml(siblingItem)} --> set it as current.",
        );

        blockSetCurrentItemResult.recordCurrentTransition(
          previousItem: isCandidateIsCurrent ? candidateCurrItem : currentItem,
          candidateItem: candidateCurrItem,
          finalItem: siblingItem,
          trigger: CurrentItemTransitionTrigger.siblingFallback,
        );

        thisXBlock._createAndSetBlockExecutionIntentSetCurrentItem(
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
          codeId: "#29180",
          shortDesc: "Set current item to <b>null</b>.",
        );
        //
        __setCurrentItemOnlyAndItemState(
            id: null, item: null, itemDetail: null);
        //
        if (formModel != null) {
          executionTrace.addInfo(
            codeId: "#29200",
            shortDesc:
                "Set ${debugObjHtml(formModel!)} dataState to <b>none</b>.",
          );
          formModel!
              ._clearDataWithDataState(formDataState: FormDataStateNone());
        }

        executionTrace.addInfo(
          codeId: "#29220",
          shortDesc:
              "Clear all data in child blocks and set them to <b>none</b>."
              "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        );

        for (final child in thisXBlock.childXBlocks) {
          blockSetCurrentItemResult.recordCascadedEviction(
            childBlockName: child.name,
            targetState: const BlockDataStateNone(),
          );
        }

        __clearAllChildrenBlocksToNone(thisXBlock: thisXBlock);
      }
      return;
    }

    // ===========================================================================
    // STAGE 2: ITEM MUTATION, CONVERSION & STATE COMMIT
    // ===========================================================================
    if (currentItemChanged || itemRefreshed) {
      executionTrace.addInfo(
        codeId: "#29400",
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
          codeId: "#29410",
          caller: this,
          methodName: methodName,
          suffixShortDesc:
              "To convert <b>ITEM_DETAIL</b> to <b>ITEM</b>, {debugObjHtml(refreshedCurrentItemDetail)} --> ${_debugItemTypeHtml()}.",
        );

        candidateCurrItem = __convertItemDetailToItem(
          itemDetail: refreshedCurrentItemDetail,
        );

        executionTrace.addInfo(
          codeId: "#29420",
          shortDesc: "Got value: ${debugObjHtml(candidateCurrItem)}.",
        );
      } catch (e, stackTrace) {
        final ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: methodName,
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: TipDocument.blockConvertItemDetailToItem,
        );

        blockSetCurrentItemResult.recordItemOperationFailure(
          item: candidateCurrItem,
          operation: methodName,
          errorInfo: errorInfo,
        );

        executionTrace.addInfo(
          codeId: "#29440",
          shortDesc:
              "The ${debugObjHtml(this)}.$methodName() method was called with an error!",
          errorInfo: errorInfo,
        );
        return;
      }

      // 2.2 Synchronize list data and commit current item pointer
      if (candidateCurrItem != null) {
        executionTrace.addNonControllableCall(
          codeId: "#29480",
          caller: _blockData,
          methodName: "_insertOrReplaceItem",
          suffixShortDesc: "",
          parameters: {
            "item": candidateCurrItem,
          },
        );
        _blockData._insertOrReplaceItem(item: candidateCurrItem);
      }

      executionTrace.addInfo(
        codeId: "#29500",
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
      __setCurrentItemOnlyAndItemState(
        id: candidateCurrItemId,
        item: candidateCurrItem,
        itemDetail: refreshedCurrentItemDetail,
      );
      //
      _resetBlockItemSyncSessionState(executionTrace: executionTrace);
    }

    // ===========================================================================
    // STAGE 3: FORM MODEL LIFECYCLE COORDINATION
    // ===========================================================================
    if (formModel != null) {
      if (currentItemChanged || isCandidateCurrentItemInNewQueriedList) {
        executionTrace.addInfo(
          codeId: "#29520",
          shortDesc:
              "Current Item Changed/Queried --> Clear form and set to Pending.",
        );
        formModel!._clearDataWithDataState(
          formDataState: FormDataStatePending(),
        );
      } else if (itemRefreshed) {
        executionTrace.addInfo(
          codeId: "#29530",
          shortDesc: "Current Item Refreshed --> Set Form to Stale.",
        );
        final newFormDataState = FormDataStateUtils.calculateNewLazyDataState(
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
        thisXBlock.xBlockFormModel!
            .setForceTypeIfLessThan(FormLoadHint.forceIfNeed);

        executionTrace.addExecutionIntent(
          codeId: "#29540",
          owner: thisXBlock.xBlockFormModel!.formModel,
          executionIntentType: FormModelDataLoadIntent,
          suffixShortDesc: "",
        );
        thisXBlock.xBlockFormModel!._createAndSetFormModelExecutionIntentLoad();
      }
    }

    // ===========================================================================
    // STAGE 4: CASCADE CHILD BLOCKS TO PENDING
    // ===========================================================================
    if (currentItemChanged) {
      blockSetCurrentItemResult._currentItem = candidateCurrItem;

      executionTrace.addInfo(
        codeId: "#29640",
        shortDesc:
            "The <b>currentItem</b> has changed --> clear all data in child blocks and set them to <b>pending</b>."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      );

      for (final child in thisXBlock.childXBlocks) {
        blockSetCurrentItemResult.recordCascadedEviction(
          childBlockName: child.name,
          targetState: const BlockDataStatePending(),
        );
      }

      __clearAllChildrenBlocksToPending(
        thisXBlock: thisXBlock,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_BlockDeleteSelectedItemsAnnotation()
  @_BlockDeleteCheckedItemsAnnotation()
  @_BlockDeleteCurrentItemAnnotation()
  @_BlockDeleteItemAnnotation()
  Future<void> _unitDeleteItem({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockDeleteItemIntent<ID, ITEM, ITEM_DETAIL> executionIntent,
  }) async {
    __assertThisXBlock(thisXBlock);
    thisXBlock._createAndSetBlockExecutionIntentDone(
      lastIntentInfo: "Delete Item",
    );

    executionTrace.addInfo(
      codeId: "#08000",
      shortDesc:
          "${debugObjHtml(this)} --> Begin ${executionUnitType.asDebugExecutionUnit()} for ${debugObjHtml(this)}.",
    );

    const bool errorIfItemNotInTheBlock = true;

    executionTrace.addNonControllableCall(
      codeId: "#08020",
      caller: this,
      methodName: "canDeleteItem",
      suffixShortDesc: "",
      parameters: {
        "item": executionIntent.item,
        "errorIfItemNotInTheBlock": errorIfItemNotInTheBlock,
      },
      note: "Call this method to check before deleting an item. "
          "(**) You can override ${debugObjHtml(this)}.isItemDeletionAllowed() method.",
    );

    final deletionResult = executionIntent.resultWrapper._setResult(
      BlockItemDeletionResult<ID, ITEM, ITEM_DETAIL>(
        candidateItem: executionIntent.item,
        precheck: null,
        errorInfo: null,
      ),
      objectCaller: this,
      methodName: '_unitDeleteItem',
    );

    final bool isCurrent = isCurrentItem(executionIntent.item);

    executionTrace.addInfo(
      codeId: "#08060",
      shortDesc: isCurrent
          ? "You are deleting the current item - ${debugObjHtml(executionIntent.item)}."
          : "You are deleting an item that is not the current item - ${debugObjHtml(executionIntent.item)}.",
    );

    final String methodName = "performDeleteItemById";
    ApiResult<void> result;
    final List<ID> effectedItemIds = [];

    try {
      final ID itemId = __getItemIdShowErr(executionIntent.item, showErr: true);
      __refreshDeletingState(isDeleting: true);

      executionTrace.addControllableCall(
        codeId: "#08160",
        caller: this,
        methodName: methodName,
        suffixShortDesc: "",
        parameters: {
          "itemId": itemId,
        },
      );

      result = await performDeleteItemById(itemId: itemId);
      result.throwIfError();

      executionTrace.addBroadcastEvent(
        codeId: "#08180",
        shortDesc:
            "${debugObjHtml(this)} > Fire event after deleting ${_debugItemTypeHtml()}($itemId).",
      );
      effectedItemIds.add(itemId);

      // Audit journal tracking via BlockOperationStep
      deletionResult.recordEviction(
        item: executionIntent.item,
        reason: ItemEvictionReason.explicitDeletion,
      );

      // External event propagation to observing shelves
      __broadcastEventFromBlockToOtherShelves(
        executionTrace: executionTrace,
        eventType: EventType.deletion,
        effectedItemIds: effectedItemIds,
      );
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: methodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.blockPerformDeleteItemById,
      );

      // Audit journal tracking for failures via BlockOperationStep
      deletionResult.recordItemOperationFailure(
        item: executionIntent.item,
        operation: methodName,
        errorInfo: errorInfo,
      );
      deletionResult._setErrorInfo(errorInfo: errorInfo);

      executionTrace.addInfo(
        codeId: "#08200",
        shortDesc:
            "The ${debugObjHtml(this)}.$methodName() method was called with an error!",
        errorInfo: errorInfo,
      );
      return;
    } finally {
      __refreshDeletingState(isDeleting: false);
    }

    showDeletedSnackBar();

    ITEM? siblingItem;

    // Branch A: Item is not the active currentItem
    if (!isCurrent) {
      executionTrace.addInfo(
        codeId: "#08240",
        shortDesc:
            "Remove ${debugObjHtml(executionIntent.item)} from ${debugObjHtml(this)}. (*) This item was not current item.",
      );
      await __removeItemFromList(
        executionTrace: executionTrace,
        removeItem: executionIntent.item,
      );
    }
    // Branch B: Item is the active currentItem -> Evict and select sibling fallback
    else {
      final String? itemContextComponent = ui.findVisibleItemContextView(
        includeDescendants: true,
      );
      executionTrace.addInfo(
        codeId: "#08250",
        shortDesc: "Debug:",
        parameters: {
          "itemContextComponent": itemContextComponent,
        },
        tipDocument: TipDocument.blockActiveUiComponents,
      );

      if (itemContextComponent != null) {
        executionTrace.addInfo(
          codeId: "#08260",
          shortDesc: "Finding sibling item...",
        );
        siblingItem = findSiblingItem(item: executionIntent.item);
      } else {
        siblingItem = null;
      }

      executionTrace.addInfo(
        codeId: "#08270",
        shortDesc: "Found sibling item:",
        parameters: {
          "siblingItem": siblingItem,
        },
      );

      executionTrace.addInfo(
        codeId: "#08280",
        shortDesc:
            "Remove ${debugObjHtml(executionIntent.item)} from ${debugObjHtml(this)}. (*) This item was current item.",
      );

      await __removeItemFromList(
        executionTrace: executionTrace,
        removeItem: executionIntent.item,
      );

      executionTrace.addInfo(
        codeId: "#08300",
        shortDesc: "${debugObjHtml(this)} --> set current item to <b>null</b>.",
      );
      __setCurrentItemOnlyAndItemState(
        id: null,
        item: null,
        itemDetail: null,
      );

      if (formModel != null) {
        executionTrace.addInfo(
          codeId: "#08320",
          shortDesc:
              "${debugObjHtml(formModel)} --> clear formModel, set dataState to <b>none</b>.",
        );
        formModel!._clearDataWithDataState(
          formDataState: const FormDataStateNone(),
        );
      }

      executionTrace.addInfo(
        codeId: "#08340",
        shortDesc: "Clear data of all child blocks and set them to <b>none</b>."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      );

      for (final child in thisXBlock.childXBlocks) {
        deletionResult.recordCascadedEviction(
          childBlockName: child.name,
          targetState: const BlockDataStateNone(),
        );
      }

      __clearAllChildrenBlocksToNone(
        thisXBlock: thisXBlock,
      );

      // Select fallback sibling if present, otherwise record reset to null
      if (siblingItem != null) {
        deletionResult.recordCurrentTransition(
          previousItem: executionIntent.item,
          candidateItem: executionIntent.item,
          finalItem: siblingItem,
          trigger: CurrentItemTransitionTrigger.siblingFallback,
        );

        final setCurrentItemDirective =
            BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed;

        thisXBlock._createAndSetBlockExecutionIntentSetCurrentItem(
          setCurrentItemDirective: setCurrentItemDirective,
          newQueriedList: const [],
          inputCandidateCurrItem: siblingItem,
          forceReloadItem: false,
          formLoadHint: null,
        );
        thisXBlock.stagePredecessorResult(deletionResult);
      } else {
        deletionResult.recordCurrentTransition(
          previousItem: executionIntent.item,
          candidateItem: executionIntent.item,
          finalItem: null,
          trigger: CurrentItemTransitionTrigger.resetToNull,
        );
      }
    }

    executionTrace.addSeparator();

    executionTrace.addNonControllableCall(
      codeId: "#08400",
      caller: this,
      methodName: "processBroadcastInternal",
      suffixShortDesc: "",
      parameters: {
        "candidateCurrItem": siblingItem,
      },
    );

    // Self & Peer internal event broadcasting
    await processBroadcastInternal(
      executionTrace: executionTrace,
      thisEventXBlock: thisXBlock,
      effectiveItemIds: effectedItemIds,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> processBroadcastInternal({
    required ExecutionTrace executionTrace,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisEventXBlock,
    required List<ID> effectiveItemIds,
  }) async {
    __assertThisXBlock(thisEventXBlock);
    //
    _EventDispatcher.broadcastInternal<ID>(
      eventType: EventType.mix, // TODO Review again.
      eventBlock: thisEventXBlock.block,
      effectedItemIds: effectiveItemIds,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_BlockDeleteItemsAnnotation()
  Future<void> _unitDeleteItems({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockDeleteItemsIntent<ID, ITEM, ITEM_DETAIL> executionIntent,
  }) async {
    __assertThisXBlock(thisXBlock);
    thisXBlock._createAndSetBlockExecutionIntentDone(
      lastIntentInfo: "Delete Items",
    );

    executionTrace.addInfo(
      codeId: "#42000",
      shortDesc:
          "Begin ${debugObjHtml(this)} -> ${executionUnitType.asDebugExecutionUnit()}.",
      parameters: {
        "items": executionIntent.items,
        "stopIfError": executionIntent.stopIfError,
      },
    );

    final deletionResult = executionIntent.resultWrapper._setResult(
      BlockItemsDeletionResult<ID, ITEM, ITEM_DETAIL>(
        candidateItems: executionIntent.items,
      ),
      objectCaller: this,
      methodName: '_unitDeleteItems',
    );

    final ID? currItemId = currentItemId;
    ITEM? siblingItem;
    bool currentItemDeleted = false;

    final String methodName = "performDeleteItemById";

    final String? itemContextComponent = ui.findVisibleItemContextView(
      includeDescendants: true,
    );
    executionTrace.addInfo(
      codeId: "#42560",
      shortDesc: "Debug:",
      parameters: {
        "itemContextComponent": itemContextComponent,
      },
      tipDocument: TipDocument.blockActiveUiComponents,
    );

    for (ITEM delItem in [...executionIntent.items]) {
      ApiResult<void> result;
      try {
        final ID deletingItemId = __getItemIdShowErr(delItem, showErr: true);

        // Pre-capture sibling before the item leaves the memory list
        if (itemContextComponent != null && deletingItemId == currItemId) {
          siblingItem = findSiblingItem(item: delItem);
        }

        __refreshDeletingState(isDeleting: true);

        executionTrace.addControllableCall(
          codeId: "#42600",
          caller: this,
          methodName: methodName,
          suffixShortDesc: currItemId == deletingItemId
              ? ""
              : "* (Deleting an item that is not currentItem).",
          parameters: {
            "itemId": deletingItemId,
          },
        );

        result = await performDeleteItemById(itemId: deletingItemId);
        result.throwIfError();

        executionTrace.addInfo(
          codeId: "#42660",
          shortDesc:
              "The ${debugObjHtml(delItem)} item has been successfully deleted!",
        );

        // 1. Audit journal tracking via BlockOperationStep
        deletionResult.recordEviction(
          item: delItem,
          reason: ItemEvictionReason.explicitDeletion,
        );

        executionTrace.addInfo(
          codeId: "#42720",
          shortDesc: "Remove ${debugObjHtml(delItem)} from the list.",
        );

        // Remove item from in-memory collection
        await __removeItemFromList(
          executionTrace: executionTrace,
          removeItem: delItem,
        );

        // Current item evicted
        if (deletingItemId == currItemId) {
          executionTrace.addInfo(
            codeId: "#42760",
            shortDesc:
                "The current item has been deleted! Set current item to <b>null</b>.",
          );
          currentItemDeleted = true;

          __setCurrentItemOnlyAndItemState(
            id: null,
            item: null,
            itemDetail: null,
          );

          if (formModel != null) {
            executionTrace.addInfo(
              codeId: "#42780",
              shortDesc:
                  "Clear ${debugObjHtml(formModel)} and set to <b>none</b>.",
            );
            formModel!._clearDataWithDataState(
              formDataState: const FormDataStateNone(),
            );
          }

          executionTrace.addInfo(
            codeId: "#42800",
            shortDesc:
                "Clear all data of child blocks and set them to <b>none</b>."
                "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
          );

          for (final child in thisXBlock.childXBlocks) {
            deletionResult.recordCascadedEviction(
              childBlockName: child.name,
              targetState: const BlockDataStateNone(),
            );
          }

          __clearAllChildrenBlocksToNone(
            thisXBlock: thisXBlock,
          );
        }
      } catch (e, stackTrace) {
        final ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: methodName,
          error: e,
          stackTrace: stackTrace,
          showSnackBar: false,
          tipDocument: TipDocument.blockPerformDeleteItemById,
        );

        // 2. Audit journal tracking for failures via BlockOperationStep
        deletionResult.recordItemOperationFailure(
          item: delItem,
          operation: methodName,
          errorInfo: errorInfo,
        );

        executionTrace.addInfo(
          codeId: "#42840",
          shortDesc: "Error deleting item ${debugObjHtml(delItem)}",
          errorInfo: errorInfo,
        );

        if (executionIntent.stopIfError) {
          executionTrace.addInfo(
            codeId: "#42860",
            shortDesc:
                "@stopIfError: ${debugObjHtml(executionIntent.stopIfError)} --> Stop batch deletion!",
            errorInfo: errorInfo,
          );
          break;
        }
      } finally {
        __refreshDeletingState(isDeleting: false);
      }
    }

    final List<ID> effectedItemIds = [];

    // Broadcast external events across shelves if any deletions succeeded
    if (deletionResult.deletedItems.isNotEmpty) {
      effectedItemIds.addAll(deletionResult.deletedItems.map((i) => i.id));

      executionTrace.addBroadcastEvent(
        codeId: "#42900",
        shortDesc:
            "${debugObjHtml(this)} > Fire event after deleting (${deletionResult.deletedItems.length} items deleted!).",
      );

      __broadcastEventFromBlockToOtherShelves(
        executionTrace: executionTrace,
        eventType: EventType.deletion,
        effectedItemIds: effectedItemIds,
      );
    }

    // Feedback notifications derived from journal records
    if (deletionResult.failedOperations.isEmpty) {
      showDeletedSnackBar(
        customMessage: "${deletionResult.deletedItems.length} Item Deleted!",
      );
    } else {
      showMessageSnackBar(
        message: 'Deletion Results',
        details: [
          "${executionIntent.items.length} Target Items",
          "${deletionResult.deletedItems.length} Deleted",
          "${deletionResult.failedOperations.length} Failed",
        ],
      );
    }

    // =========================================================================
    // RESOLVE & SELECT NEXT CURRENT ITEM IF ACTIVE ITEM WAS DELETED
    // =========================================================================
    if (currentItemDeleted && isNotEmpty) {
      ITEM? nextCandidateItem;

      // 1. Verify if the previously captured sibling survived subsequent deletions
      if (siblingItem != null && containsItem(siblingItem)) {
        nextCandidateItem = siblingItem;
      }

      // 2. Fallback to designated index or first surviving item
      if (nextCandidateItem == null) {
        final int? suggestIdx = specifyItemIndexToSetAsCurrent();
        if (suggestIdx != null) {
          nextCandidateItem = findItemByIndex(suggestIdx);
        }
        nextCandidateItem ??= firstItem;
      }

      if (nextCandidateItem != null) {
        final setCurrentItemDirective =
            BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed;

        executionTrace.addExecutionIntent(
          codeId: "#42910",
          owner: this,
          executionIntentType: BlockSetCurrentItemIntent,
          suffixShortDesc:
              "Active item was deleted in batch. Designating fallback candidate: ${debugObjHtml(nextCandidateItem)}.",
        );

        thisXBlock._createAndSetBlockExecutionIntentSetCurrentItem(
          setCurrentItemDirective: setCurrentItemDirective,
          newQueriedList: const [],
          inputCandidateCurrItem: nextCandidateItem,
          forceReloadItem: false,
          formLoadHint: null,
        );
        thisXBlock.stagePredecessorResult(deletionResult);
      }
    }

    executionTrace.addSeparator();

    executionTrace.addInfo(
      codeId: "#42920",
      shortDesc: "After Deleting --> Process Internal Reaction.",
    );
    executionTrace.addNonControllableCall(
      codeId: "#42940",
      caller: this,
      methodName: "processBroadcastInternal",
      suffixShortDesc: "",
      parameters: {
        "candidateCurrItem": siblingItem,
      },
    );

    // Self & Peer internal event broadcasting
    await processBroadcastInternal(
      executionTrace: executionTrace,
      thisEventXBlock: thisXBlock,
      effectiveItemIds: effectedItemIds,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_BlockPrepareFormToCreateItemAnnotation()
  Future<bool> _unitPrepareFormToCreateItem({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockPrepareFormToCreateItemIntent<ID, ITEM, ITEM_DETAIL>
        executionIntent,
  }) async {
    __assertThisXBlock(thisXBlock);
    thisXBlock._createAndSetBlockExecutionIntentDone(
      lastIntentInfo: "Prepare Form To Create Item",
    );
    //
    executionTrace.addInfo(
      codeId: "#04000",
      shortDesc: "Begin ${executionUnitType.asDebugExecutionUnit()}.",
      parameters: {
        "formInput": executionIntent.formInput,
        "initDirty": executionIntent.initDirty,
      },
    );
    //
    executionTrace.addInfo(
      codeId: "#04020",
      shortDesc: "${debugObjHtml(this)} set currentItem to null.",
    );
    //
    final executionResult = executionIntent.resultWrapper._setResult(
      PrepareItemCreationResult(),
      objectCaller: this,
      methodName: '_unitPrepareFormToCreateItem',
    );
    //
    const ID? nullId = null;
    const ITEM? nullItem = null;
    const ITEM_DETAIL? nullItemDetail = null;
    __setCurrentItemOnlyAndItemState(
      id: nullId,
      item: nullItem,
      itemDetail: nullItemDetail,
    );
    //
    executionTrace.addInfo(
      codeId: "#04040",
      shortDesc: "Clear all data of child blocks and set them to <b>none</b>."
          "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
    );
    __clearAllChildrenBlocksToNone(
      thisXBlock: thisXBlock,
    );
    //
    executionTrace.addInfo(
      codeId: "#04060",
      shortDesc: "${debugObjHtml(formModel)} set formMode to creation.",
    );
    formModel!._formModelStructure._setFormMode_TODO_DELETE(
      formMode: FormMode.creation,
      formDataState: FormDataStateLoadedFresh(),
    );
    //
    bool success = false;
    try {
      __refreshPreparingFormCreationState(
        isPreparingFormCreation: true,
      );
      // TODO: Test Cases??
      executionTrace.addInfo(
        codeId: "#04080",
        shortDesc: "${debugObjHtml(formModel)} set formMode to creation.",
      );
      ADDITIONAL_FORM_RELATED_DATA? additionalFormRelatedData =
          await _performLoadAdditionalFormRelatedData(executionTrace);
      if (additionalFormRelatedData == null) {
        return false;
      }
      //
      final activityType = FormActivityType.startCreatingOrEditing;
      //
      executionTrace.addNonControllableCall(
        codeId: "#04100",
        caller: formModel!,
        methodName: "_startNewFormActivity",
        suffixShortDesc: "",
        parameters: {
          "activityType": activityType,
          "formInput": executionIntent.formInput,
          "additionalFormRelatedData": additionalFormRelatedData,
        },
      );
      success = await formModel!._startNewFormActivity(
        executionTrace: executionTrace,
        additionalFormRelatedData: additionalFormRelatedData,
        formInput: executionIntent.formInput as FORM_INPUT?,
        activityType: activityType,
        formKeyInstantValuesInUI: null,
      );
      if (success) {
        executionTrace.addInfo(
          codeId: "#04120",
          shortDesc:
              "${debugObjHtml(formModel)} manually set dirty to ${executionIntent.initDirty}.",
        );
        formModel!._formModelStructure
            ._setManualDirty(executionIntent.initDirty);
        formModel!._formModelStructure._setFormDataState(
          formDataState: FormDataStateLoadedFresh(),
          error: null,
        );
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

  @_ExecutionUnitMethodAnnotation()
  @_BlockQuickItemCreationActionAnnotation()
  Future<void> _unitQuickCreateItem({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockQuickItemCreationIntent<ID, ITEM, ITEM_DETAIL>
        executionIntent,
  }) async {
    __assertThisXBlock(thisXBlock);
    thisXBlock._createAndSetBlockExecutionIntentDone(
        lastIntentInfo: "Quick Item Creation Action");
    //
    executionTrace.addInfo(
      codeId: "#09000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()}",
    );
    final action = executionIntent.action;
    final BlockQuickItemCreationResult executionUnitResult =
        executionIntent.resultWrapper._setResult(
      BlockQuickItemCreationResult(),
      objectCaller: this,
      methodName: '_unitQuickCreateItem',
    );
    //
    // (No Precheck Again)
    //
    FILTER_CRITERIA blockCurrentFilterCriteria = filterCriteria!;
    //
    ApiResult<ITEM_DETAIL> result;
    final String methodName = "performQuickCreateItem";
    try {
      executionTrace.addControllableCall(
        codeId: "#09100",
        caller: action,
        methodName: methodName,
        suffixShortDesc: "",
      );
      //
      result = await action.performQuickCreateItem(
        parentBlockItem: parent?.currentItem,
      );
    } catch (e, stackTrace) {
      // Test Cases: [90b].
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.$methodName',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument:
            TipDocument.blockQuickItemCreationActionPerformQuickCreateItem,
      );
      //
      executionUnitResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      executionTrace.addInfo(
        codeId: "#09200",
        shortDesc:
            "The ${debugObjHtml(action)}.$methodName() method was called with an error!",
        errorInfo: errorInfo,
      );
      return;
    }
    //
    try {
      executionTrace.addNonControllableCall(
        codeId: "#09220",
        caller: this,
        methodName: "_processSaveActionRestResult",
        suffixShortDesc: "",
      );
      // In: _unitQuickCreateItem
      await _processSaveActionRestResult(
        executionTrace: executionTrace,
        thisXBlock: thisXBlock,
        isNew: true,
        callingClassName: getClassNameWithoutGenerics(action),
        calledMethodName: methodName,
        item: null,
        result: result,
      );
      return;
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "${getClassName(action)}.$methodName",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument:
            TipDocument.blockQuickItemCreationActionPerformQuickCreateItem,
      );
      //
      executionUnitResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      executionTrace.addInfo(
        codeId: "#09260",
        shortDesc:
            "The ${debugObjHtml(this)}._processSaveActionRestResult() method was called with an error!",
        errorInfo: errorInfo,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_BlockQuickItemUpdateActionAnnotation()
  Future<void> _unitQuickUpdateItem({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockQuickItemUpdateIntent<ID, ITEM, ITEM_DETAIL> executionIntent,
  }) async {
    __assertThisXBlock(thisXBlock);
    thisXBlock._createAndSetBlockExecutionIntentDone(
      lastIntentInfo: "Quick Item Update Action",
    );
    //
    executionTrace.addInfo(
      codeId: "#14000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()}",
    );
    final action = executionIntent.action;
    final BlockQuickItemUpdateResult executionUnitResult =
        executionIntent.resultWrapper._setResult(
      BlockQuickItemUpdateResult(),
      objectCaller: this,
      methodName: '_unitQuickUpdateItem',
    );
    //
    // No Need Precheck Again.
    //
    FILTER_CRITERIA blockCurrentFilterCriteria = filterCriteria!;
    //
    ApiResult<ITEM_DETAIL> result;
    final String methodName = "performQuickUpdateItem";
    try {
      executionTrace.addControllableCall(
        codeId: "#14020",
        caller: action,
        methodName: "performQuickUpdateItem",
        suffixShortDesc: "",
        parameters: {
          "parentBlockItem": parent?.currentItem,
          "filterCriteria": blockCurrentFilterCriteria,
        },
      );
      //
      result = await action.performQuickUpdateItem(
        parentBlockItem: parent?.currentItem,
      );
    } catch (e, stackTrace) {
      // Test Cases: [90b].
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.$methodName',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument:
            TipDocument.blockQuickItemUpdateActionPerformQuickUpdateItem,
      );
      //
      executionUnitResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      executionTrace.addInfo(
        codeId: "#14060",
        shortDesc:
            "The ${debugObjHtml(action)}.performQuickUpdateItem() method was called with an error.",
        errorInfo: errorInfo,
      );
      return;
    }
    //
    try {
      executionTrace.addNonControllableCall(
        codeId: "#14100",
        caller: this,
        methodName: "_processSaveActionRestResult",
        suffixShortDesc: "",
      );
      // In: _unitQuickUpdateItem
      await _processSaveActionRestResult(
        executionTrace: executionTrace,
        thisXBlock: thisXBlock,
        isNew: false,
        callingClassName: getClassNameWithoutGenerics(action),
        calledMethodName: methodName,
        result: result,
        item: action.item,
      );
      return;
    } catch (e, stackTrace) {
      final errorInfo = _handleError(
        shelf: shelf,
        methodName: "${getClassName(action)}.$methodName",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument:
            TipDocument.blockQuickItemUpdateActionPerformQuickUpdateItem,
      );
      //
      executionUnitResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      executionTrace.addInfo(
        codeId: "#14100",
        shortDesc:
            "The ${debugObjHtml(this)}._processSaveActionRestResult() method was called with an error.",
        errorInfo: errorInfo,
      );
      return;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_BlockBackendActionAnnotation()
  Future<void> _unitBackendAction({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockBackendActionIntent<ID, ITEM, ITEM_DETAIL> executionIntent,
  }) async {
    __assertThisXBlock(thisXBlock);
    thisXBlock._createAndSetBlockExecutionIntentDone(
        lastIntentInfo: "Block Backend Action");
    //
    executionTrace.addInfo(
      codeId: "#45000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${executionUnitType.asDebugExecutionUnit()}.",
    );
    final action = executionIntent.action;
    final executionUnitResult = executionIntent.resultWrapper._setResult(
      BlockBackendActionResult(),
      objectCaller: this,
      methodName: '_unitBackendAction',
    );
    //
    final FILTER_CRITERIA blockCurrentFilterCriteria = filterCriteria!;
    //
    ApiResult<ListData<ID>?> actionResult;
    try {
      executionTrace.addControllableCall(
        codeId: "#45100",
        caller: action,
        methodName: "performBackendOperation",
        suffixShortDesc: "",
        parameters: {
          "parentBlockItem": parent?.currentItem,
          "filterCriteria": blockCurrentFilterCriteria,
        },
      );
      //
      actionResult = await action.performBackendOperation(
        parentBlockItem: parent?.currentItem,
      );
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.performBackendOperation',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.blockBackendActionPerformAction,
      );
      //
      executionUnitResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      executionTrace.addInfo(
        codeId: "#45200",
        shortDesc:
            "The ${debugObjHtml(action)}.performBackendOperation() method was called with an error!",
        errorInfo: errorInfo,
      );
      return;
    }
    // Error.
    if (actionResult.error != null) {
      _handleRestError(
        shelf: shelf,
        methodName: "${getClassName(action)}.performBackendOperation",
        message: actionResult.error!.errorMessage,
        errorDetails: actionResult.error!.errorDetails,
        showSnackBar: true,
        tipDocument: null,
      );
      return;
    }
    // No Error.
    executionTrace.addNonControllableCall(
      codeId: "#45400",
      caller: this,
      methodName: "_updateBlockSyncSessionState",
      suffixShortDesc: "",
      parameters: {
        "syncStrategyOnFullQueryMode":
            action.config.syncStrategyOnFullQueryMode,
        "syncStrategyOnPageableQueryMode":
            action.config.syncStrategyOnPageableQueryMode,
      },
    );
    //
    final List<ID> effectedItemIds = actionResult.data?.items ?? [];
    // Add Event.
    _updateBlockSyncSessionState(
      executionTrace: executionTrace,
      // BackendAction.
      eventSourceType: EventSourceType.special,
      requiresMaxSyncStrategy: false,
      //
      syncStrategyOnFullQueryMode: action.config.syncStrategyOnFullQueryMode,
      syncStrategyOnPageableQueryMode:
          action.config.syncStrategyOnPageableQueryMode,
      mainDataTypes: getDeclaredMainDataTypes().toList(),
      // TODO Review.
      extraDataTypes: [],
      effectedItemIds: effectedItemIds,
    );
    //
    // *new*
    //
    executionTrace.addBroadcastEvent(
      codeId: "#45500",
      shortDesc:
          "${debugObjHtml(this)} > Fire event after execute backend action.",
    );
    //
    __broadcastEventFromBlockToOtherShelves(
      executionTrace: executionTrace,
      eventType: EventType.mix,
      effectedItemIds: effectedItemIds,
    );
    //
    executionTrace.addNonControllableCall(
      codeId: "#45600",
      caller: this,
      methodName: "processBroadcastInternal",
      suffixShortDesc: "",
      parameters: {
        "effectiveItemIds": effectedItemIds,
      },
    );
    //
    // IN: _unitBackendAction()
    // Process Internal Reaction:
    //
    await processBroadcastInternal(
      executionTrace: executionTrace,
      thisEventXBlock: thisXBlock,
      effectiveItemIds: effectedItemIds,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __stopQueryWithFilterErrorCascade({
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockErrorInfo? blockErrorInfo,
  }) {
    __assertThisXBlock(thisXBlock);
    thisXBlock.queryResult._setFilterError();

    final blockErrorOrigin = BlockErrorOrigin.filterModel;

    final fallbackDilemmaStrategy = FallbackDilemmaStrategy.preserveStableCache;

    final BlockDataState newBlockDataState =
        BlockQueryStateCalculator.calculateDataStateOnError(
      currentDataState: dataState,
      blockErrorOrigin: blockErrorOrigin,
      blockErrorInfo: blockErrorInfo,
      dilemmaStrategy: fallbackDilemmaStrategy,
    );

    _blockData._lastQueryResultState = ActionResultState.fail;
    _blockData._blockDataState = newBlockDataState;

    final List<XBlock> descendantXBlocks =
        thisXBlock.getDescendantXBlocks(sameFilterOnly: true);

    __stopDescendantQueryWithError(
      descendantXBlocks: descendantXBlocks,
      blockErrorOrigin: blockErrorOrigin.toCascadedOrigin(),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __stopDescendantQueryWithError({
    required List<XBlock> descendantXBlocks,
    required BlockErrorOrigin blockErrorOrigin,
  }) {
    final fallbackDilemmaStrategy = FallbackDilemmaStrategy.preserveStableCache;

    for (final descendantXBlock in descendantXBlocks) {
      final descendantBlock = descendantXBlock.block;

      final descendantState =
          BlockQueryStateCalculator.calculateDataStateOnError(
        currentDataState: descendantBlock.dataState,
        blockErrorOrigin: blockErrorOrigin,
        blockErrorInfo: null,
        dilemmaStrategy: fallbackDilemmaStrategy,
      );
      descendantXBlock._queried = true;
      descendantBlock._blockData._lastQueryResultState = ActionResultState.fail;
      descendantBlock._blockData._setBlockDataState(
        newBlockDataState: descendantState,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _processSaveActionRestResult({
    required ExecutionTrace executionTrace,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required bool isNew,
    required String callingClassName,
    required String calledMethodName,
    required ITEM? item,
    required ApiResult<ITEM_DETAIL> result,
  }) async {
    if (result.error != null) {
      ErrorInfo errorInfo = _handleRestError(
        shelf: shelf,
        methodName: calledMethodName,
        message: result.error!.errorMessage,
        errorDetails: result.error!.errorDetails,
        showSnackBar: true,
        tipDocument: null,
      );
      executionTrace.addInfo(
        codeId: "#16000",
        shortDesc:
            "The <b>$callingClassName.$calledMethodName()</b> method was called with an error.",
        errorInfo: errorInfo,
      );
      return;
    }
    //
    showSavedSnackBar();
    //
    FILTER_CRITERIA? blockCurrentFilterCriteria = filterCriteria;
    if (blockCurrentFilterCriteria == null) {
      executionTrace.addInfo(
        codeId: "#16040",
        shortDesc: "Dev Error: TODO: @blockCurrentFilterCriteria is null!!",
      );
      // TODO-Review.
      return;
    }
    bool broadcastExternalShelfEvent = false;
    final ITEM_DETAIL? savedItemDetail = result.data;
    //
    executionTrace.addInfo(
      codeId: "#16100",
      shortDesc: "Got @savedItemDetail: ${debugObjHtml(savedItemDetail)}.",
    );
    //
    final bool keepInList;
    if (savedItemDetail == null) {
      keepInList = false;
      if (isNew) {
        broadcastExternalShelfEvent = true;
      } else {
        broadcastExternalShelfEvent = true;
      }
    } else {
      broadcastExternalShelfEvent = true;
      //
      executionTrace.addControllableCall(
        codeId: "#16140",
        caller: this,
        methodName: "needToKeepItemInList",
        suffixShortDesc:
            "To decide whether to keep item ${debugObjHtml(savedItemDetail)} in the list or not..",
        parameters: {
          "parentBlockCurrentItem": parentBlockCurrentItemId,
          "filterCriteria": filterCriteria,
          "itemDetail": savedItemDetail,
        },
      );
      keepInList = needToKeepItemInList(
        parentBlockCurrentItemId: parentBlockCurrentItemId,
        filterCriteria: blockCurrentFilterCriteria,
        itemDetail: savedItemDetail,
      );
    }
    //
    final ID? effectedItemId;
    if (item != null) {
      effectedItemId = item.id;
    } else {
      effectedItemId = savedItemDetail?.id;
    }
    final List<ID> effectiveItemIds =
        effectedItemId == null ? [] : [effectedItemId];
    //
    if (broadcastExternalShelfEvent) {
      executionTrace.addSeparator();
      //
      executionTrace.addBroadcastEvent(
        codeId: "#16200",
        shortDesc:
            "${debugObjHtml(this)} > Save successful --> An event occurred --> checking if it should be broadcasted.",
      );
      __broadcastEventFromBlockToOtherShelves(
        executionTrace: executionTrace,
        eventType: isNew ? EventType.creation : EventType.update,
        effectedItemIds: effectiveItemIds,
      );
      //
      executionTrace.addSeparator();
    } else {}
    ITEM? siblingItem;
    //
    if (savedItemDetail != null && keepInList) {
      executionTrace.addInfo(
        codeId: "#16220",
        shortDesc: "Debug:",
        parameters: {
          "savedItemDetail": savedItemDetail,
          "keepInList": keepInList,
        },
      );
      executionTrace.addControllableCall(
        codeId: "#16240",
        caller: this,
        methodName: "convertItemDetailToItem",
        suffixShortDesc:
            "To convert ${debugObjHtml(savedItemDetail)} to ${_debugItemTypeHtml()}.",
      );
      ITEM refreshedItem = __convertItemDetailToItem(
        itemDetail: savedItemDetail,
      );
      executionTrace.addInfo(
        codeId: "#16280",
        shortDesc:
            "Insert or replace ${debugObjHtml(refreshedItem)} into the list.",
      );
      _blockData._insertOrReplaceItem(
        item: refreshedItem,
      );
      //
      Actionable<BlockItemEditPrecheck> actionable =
          canEditItemOnForm(item: refreshedItem);
      //
      final ID itemId = __getItemIdShowErr(refreshedItem, showErr: true);
      thisXBlock._addRecentLoadedItem(
        itemId: itemId,
        item: refreshedItem,
        itemDetail: savedItemDetail,
      );
      //
      executionTrace.addInfo(
        codeId: "#16320",
        shortDesc: "Set ${debugObjHtml(refreshedItem)} as current.",
      );
      __setCurrentItemOnlyAndItemState(
        id: itemId,
        itemDetail: savedItemDetail,
        item: refreshedItem,
      );
      //
      // Test Case [01c]. New Code:
      // Test Case [02b] - __test_form_cat_product02b_newCat.
      if (isNew) {
        executionTrace.addInfo(
          codeId: "#16360",
          shortDesc:
              "Just created an item -> clear data of all child blocks and set them to <b>pending</b>."
              "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        );
        __clearAllChildrenBlocksToPending(
          thisXBlock: thisXBlock,
        );
      }
      //
      final newForceType = FormLoadHint.force;
      //
      if (thisXBlock.xBlockFormModel != null) {
        // Test Case [02a].
        formModel!._formModelStructure._setFormMode(FormMode.edit);
        // IMPORTANT:
        thisXBlock.xBlockFormModel!.setForceType(newForceType);

        executionTrace.addExecutionIntent(
          codeId: "#16400",
          owner: thisXBlock.xBlockFormModel!.formModel,
          executionIntentType: FormModelDataLoadIntent,
          suffixShortDesc: "After Saving Form.",
        );
        thisXBlock.xBlockFormModel!._createAndSetFormModelExecutionIntentLoad();
      }
    }
    // savedItemDetail = null or !keepInList
    else {
      executionTrace.addInfo(
        codeId: "#16500",
        shortDesc: "Debug:",
        parameters: {
          "savedItemDetail": savedItemDetail,
          "keepInList": keepInList,
        },
      );
      ITEM? savedItem;
      if (savedItemDetail != null) {
        executionTrace.addControllableCall(
          codeId: "#16520",
          caller: this,
          methodName: "convertItemDetailToItem",
          suffixShortDesc:
              "To convert ${debugObjHtml(savedItemDetail)} to ${_debugItemTypeHtml()}.",
        );
        savedItem = __convertItemDetailToItem(
          itemDetail: savedItemDetail,
        );
      } else {
        savedItem = null;
      }
      final ITEM? removeItem = savedItem ?? currentItem;
      if (removeItem != null) {
        //
        // removeItem != null
        //
        bool isCurrent = isCurrentItem(removeItem);
        if (!isCurrent) {
          executionTrace.addInfo(
            codeId: "#16560",
            shortDesc:
                "${debugObjHtml(this)} --> remove the ${debugObjHtml(removeItem)} from the list. "
                "(*) This item is not current item.",
          );
          await __removeItemFromList(
            executionTrace: executionTrace,
            removeItem: removeItem,
          );
          return;
        }
        //
        executionTrace.addControllableCall(
          codeId: "#16580",
          caller: this,
          methodName: "findSiblingItem",
          suffixShortDesc: "",
          parameters: {"item": removeItem},
        );
        //
        // Deleted current item ==> find sibling.
        //
        siblingItem = findSiblingItem(item: removeItem);
        //
        executionTrace.addInfo(
          codeId: "#16600",
          shortDesc:
              "${debugObjHtml(this)} --> remove the current item ${debugObjHtml(removeItem)}.",
        );
        // Remove Item (Current Item)
        await __removeItemFromList(
          executionTrace: executionTrace,
          removeItem: removeItem,
        );
        //
        executionTrace.addInfo(
          codeId: "#16620",
          shortDesc: "${debugObjHtml(this)} --> set current item to null.",
        );
        __setCurrentItemOnlyAndItemState(
          id: null,
          item: null,
          itemDetail: null,
        );
        //
        if (formModel != null) {
          executionTrace.addInfo(
            codeId: "#16660",
            shortDesc:
                "${debugObjHtml(formModel)} clear form data and set to <b>none</b>.",
          );
          // Clear Form:
          formModel!._clearDataWithDataState(
            formDataState: FormDataStateNone(),
          );
        }
        //
        executionTrace.addInfo(
          codeId: "#16700",
          shortDesc:
              "Clear data of all child blocks and set them to <b>none</b>."
              "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        );
        // TODO: Test cases.
        __clearAllChildrenBlocksToNone(
          thisXBlock: thisXBlock,
        );
      }
    }
    //
    // Process Internal Reaction (If Need).
    // IN: _processSaveActionRestResult()
    //
    await processBroadcastInternal(
      executionTrace: executionTrace,
      thisEventXBlock: thisXBlock,
      effectiveItemIds: effectiveItemIds,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Opens the diagnostic error viewer dialog reflecting either Block or Filter error payloads.
  @_RootMethodAnnotation()
  Future<void> showBlockErrorViewerDialog(BuildContext context) async {
    if (!hasError) return;

    final BlockErrorInfo? activeBlockErrorInfo = blockErrorInfo;

    if (activeBlockErrorInfo != null) {
      await BlockErrorViewerDialog.show(
        context: context,
        blockErrorInfo: activeBlockErrorInfo,
      );
      return;
    }
    final ErrorInfo? errorInfo = filterErrorInfo;
    if (errorInfo != null) {
      await ErrorViewerDialog.show(
        context: context,
        errorInfo: errorInfo,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_BlockClearCurrentItemAnnotation()
  Future<void> clearCurrentItem() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "clearCurrentItem",
      parameters: null,
      isLibMethod: true,
    );
    if (currentItem == null) {
      executionTrace.addInfo(
        codeId: "#63000",
        shortDesc: "No current item -> do nothing.",
      );
      return;
    }
    //
    executionTrace.addInfo(
      codeId: "#63100",
      shortDesc: "Creating <b>$_XShelfBlockClearCurrentItem</b>..",
    );
    final XShelf xShelf = _XShelfBlockClearCurrentItem(block: this);
    //
    final thisXBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;
    thisXBlock._createAndSetBlockExecutionIntentClearCurrentItem();
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<BlockItemDeletionResult<ID, ITEM, ITEM_DETAIL>> __deleteItem({
    required ExecutionTrace executionTrace,
    required String methodName,
    required ITEM? item,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
    bool errorIfItemNotInTheBlock = true,
  }) async {
    final bool checkBusyTrue = true;
    final bool checkAllowTrue = true;
    //
    executionTrace.addInfo(
      codeId: "#76000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canDeleteItem() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
        "checkAllow": checkAllowTrue,
        "item": item,
        "errCodeIfItemIsNull": errCodeIfItemIsNull,
        "errorIfItemNotInTheBlock": errorIfItemNotInTheBlock,
      },
    );
    // @Same-Code-Precheck-01
    Actionable<BlockItemDeletionPrecheck> actionable = __canDeleteItem(
      checkBusy: checkBusyTrue,
      checkAllow: checkAllowTrue,
      item: item,
      errCodeIfItemIsNull: errCodeIfItemIsNull,
      errorIfItemNotInTheBlock: errorIfItemNotInTheBlock,
    );
    if (!actionable.yes) {
      executionTrace.addInfo(
        codeId: "#76040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
      );
      //
      debug._deletionErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockItemDeletionResult<ID, ITEM, ITEM_DETAIL>(
        candidateItem: item,
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    BuildContext context = FlutterArtistCore.context;
    bool confirm = await showConfirmDeleteDialog(
      context: context,
      details: getClassName(item),
    );
    if (!confirm) {
      return BlockItemDeletionResult<ID, ITEM, ITEM_DETAIL>(
        candidateItem: item,
        precheck: BlockItemDeletionPrecheck.cancelled,
      );
    }
    //
    final XShelf xShelf = _XShelfBlockItemDeletion(block: this);
    //
    final thisXBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;
    //
    executionTrace.addExecutionIntent(
      codeId: "#76340",
      owner: this,
      executionIntentType: BlockDeleteItemIntent,
      suffixShortDesc: "",
    );
    final BlockDeleteItemIntent<ID, ITEM, ITEM_DETAIL> executionIntent =
        thisXBlock._createAndSetBlockExecutionIntentDeleteItem(item: item!);

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<BlockItemsDeletionResult<ID, ITEM, ITEM_DETAIL>> __deleteItems({
    required ExecutionTrace executionTrace,
    required String methodName,
    required List<ITEM> items,
    required bool stopIfError,
    bool errorIfItemNotInTheBlock = true,
  }) async {
    final List<ITEM> candidateDeleteItems =
        _blockData.moveCurrentItemToEndOfList(
      itemList: items,
    );
    executionTrace.addInfo(
      codeId: "#65000",
      shortDesc: "Check before deletion..",
    );
    // @Same-Code-Precheck-01
    Actionable<BlockItemsDeletionPrecheck> actionable = __canDeleteItems(
      checkBusy: true,
      checkAllow: true,
      errorIfItemNotInTheBlock: errorIfItemNotInTheBlock,
      items: candidateDeleteItems,
    );
    if (!actionable.yes) {
      debug._deletionErrorCount++;
      final ErrorInfo? errorInfo = _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      executionTrace.addInfo(
        codeId: "#65100",
        shortDesc: "@actionable = ${debugObjHtml(actionable)}.",
        errorInfo: errorInfo,
      );
      return BlockItemsDeletionResult<ID, ITEM, ITEM_DETAIL>(
        candidateItems: candidateDeleteItems,
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    BuildContext context = FlutterArtistCore.context;
    bool confirm = await showConfirmDeleteDialog(
      context: context,
      details: "Delete Multi Items",
    );
    if (!confirm) {
      executionTrace.addInfo(
        codeId: "#65200",
        shortDesc: "@confirm = <b>false</b> --> Cancelled!",
      );
      return BlockItemsDeletionResult<ID, ITEM, ITEM_DETAIL>(
        candidateItems: candidateDeleteItems,
        precheck: BlockItemsDeletionPrecheck.cancelled,
      );
    }
    //
    executionTrace.addInfo(
      codeId: "#65300",
      shortDesc: "Creating <b>$_XShelfBlockMultiItemDeletion</b>..",
    );
    final XShelf xShelf = _XShelfBlockMultiItemDeletion(block: this);
    //
    final thisXBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;
    //
    final BlockDeleteItemsIntent<ID, ITEM, ITEM_DETAIL> executionIntent =
        thisXBlock._createAndSetBlockExecutionIntentDeleteItems(
      items: candidateDeleteItems,
      stopIfError: stopIfError,
    );
    //
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    //
    return executionIntent.result;
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
    required bool forceLoadForm,
  }) async {
    final setCurrentItemDirective = forceLoadForm
        ? BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm
        : BlockSetCurrentItemDirective.setAnItemAsCurrent;
    //
    executionTrace.addInfo(
      codeId: "#69000",
      shortDesc:
          "Calculated > @setCurrentItemDirective: ${debugObjHtml(setCurrentItemDirective)}",
    );
    executionTrace.addNonControllableCall(
      codeId: "#69100",
      caller: this,
      methodName: "__canSetItemAsCurrent",
      suffixShortDesc: "",
      parameters: {
        "item": item,
        "errCodeIfItemIsNull": errCodeIfItemIsNull,
        "checkBusy": true,
      },
    );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<BlockSetCurrentItemPrecheck> actionable =
        __canSetItemAsCurrent(
      item: item,
      errCodeIfItemIsNull: errCodeIfItemIsNull,
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      // _refreshErrorCount++
      final ErrorInfo? errorInfo = _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      executionTrace.addInfo(
        codeId: "#69200",
        shortDesc: "Has error:",
        errorInfo: errorInfo,
      );
      //
      return BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>(
        precheck: actionable.errCode,
        setCurrentItemDirective: setCurrentItemDirective,
        candidateItem: item,
        oldCurrentItem: currentItem,
        currentItem: currentItem,
      );
    }
    //
    executionTrace.addInfo(
      codeId: "#69300",
      shortDesc: "Creating <b>_XShelfBlockSetItemAsCurrent</b>...",
    );
    final XShelf xShelf = _XShelfBlockSetItemAsCurrent(block: this);
    //
    final thisXBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;
    final executionIntent =
        thisXBlock._createAndSetBlockExecutionIntentSetCurrentItem(
      setCurrentItemDirective: setCurrentItemDirective,
      newQueriedList: [],
      inputCandidateCurrItem: item,
      forceReloadItem: forceLoadItem,
      formLoadHint: forceLoadForm //
          ? FormLoadHint.force
          : FormLoadHint.auto,
    );
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    // Future<BlockSetCurrentItemResult<ID,ITEM,ITEM_DETAIL>>
    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockSetItemAsCurrentAnnotation()
  Future<BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>>
      refreshItemAndSetAsCurrent({
    required ITEM item,
    bool forceLoadForm = false,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "refreshItemAndSetAsCurrent",
      parameters: {
        "item": item,
        "forceLoadForm": forceLoadForm,
      },
      isLibMethod: true,
    );
    return await __refreshItemAndSetAsCurrent(
      executionTrace: executionTrace,
      methodName: "refreshItemAndSetAsCurrent",
      item: item,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
      forceLoadItem: true,
      forceLoadForm: forceLoadForm,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Clear and set block to "Pending State".
  ///
  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockClearItemsAnnotation()
  Future<BlockClearItemsResult> clearItems() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "clear",
      parameters: {},
      isLibMethod: true,
    );
    executionTrace.addInfo(
      codeId: "#62000",
      shortDesc: "Check before clear the ${debugObjHtml(this)}...",
    );
    // @Same-Code-Precheck-01
    Actionable<BlockClearItemsPrecheck> actionable = __canClearItems(
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      // _createItemErrorCount++;
      final ErrorInfo? errorInfo = _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      executionTrace.addInfo(
        codeId: "#62100",
        shortDesc: "@actionable --> ${debugObjHtml(actionable)}.",
        errorInfo: errorInfo,
      );
      return BlockClearItemsResult(
        precheck: actionable.errCode,
      );
    }
    //
    executionTrace.addInfo(
      codeId: "#62200",
      shortDesc: "Creating <b>$_XShelfBlockClearItems</b>.",
    );
    final XShelf xShelf = _XShelfBlockClearItems(block: this);
    final thisXBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;
    final BlockClearItemsIntent<ID, ITEM, ITEM_DETAIL> executionIntent =
        thisXBlock._createAndSetBlockExecutionIntentClearItems();
    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Query the next page and replace the current items in the list.
  ///
  @_RootMethodAnnotation()
  @_BlockQueryNextPageAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<BlockQueryResult> queryNextPage({
    BlockAfterQueryDirective afterQueryDirective =
        BlockAfterQueryDirective.setAnItemAsCurrentIfNeed,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return BlockQueryResult._queryBlockedTemporarily();
    }
    //
    var qryMethod = BlockQryMethodName.queryNextPage;
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryNextPage",
      parameters: {
        "afterQueryDirective": afterQueryDirective,
      },
      isLibMethod: true,
    );
    //
    return await __queryBlock(
      executionTrace: executionTrace,
      qryMethod: qryMethod,
      suggestedListUpdateStrategy: ListUpdateStrategy.replace,
      filterInput: null,
      afterQueryDirective: afterQueryDirective,
      suggestedSelection: null,
      specifiedPageable: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Query the previous page and replace the current items in the list.
  ///
  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockQueryPreviousPageAnnotation()
  Future<BlockQueryResult> queryPreviousPage({
    BlockAfterQueryDirective afterQueryDirective =
        BlockAfterQueryDirective.setAnItemAsCurrentIfNeed,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return BlockQueryResult._queryBlockedTemporarily();
    }
    //
    final qryMethod = BlockQryMethodName.queryPreviousPage;
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryPreviousPage",
      parameters: {
        "afterQueryDirective": afterQueryDirective,
      },
      isLibMethod: true,
    );
    //
    return await __queryBlock(
      executionTrace: executionTrace,
      qryMethod: qryMethod,
      suggestedListUpdateStrategy: ListUpdateStrategy.replace,
      filterInput: null,
      afterQueryDirective: afterQueryDirective,
      suggestedSelection: null,
      specifiedPageable: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Query the next page and append to the current list of items.
  ///
  @_RootMethodAnnotation()
  @_BlockQueryMorePageAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<BlockQueryResult> queryMore({
    BlockAfterQueryDirective afterQueryDirective =
        BlockAfterQueryDirective.setAnItemAsCurrentIfNeed,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return BlockQueryResult._queryBlockedTemporarily();
    }
    //
    final qryMethod = BlockQryMethodName.queryMore;
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryMore",
      parameters: {
        "afterQueryDirective": afterQueryDirective,
      },
      isLibMethod: true,
    );
    //
    return await __queryBlock(
      executionTrace: executionTrace,
      qryMethod: qryMethod,
      suggestedListUpdateStrategy: ListUpdateStrategy.merge,
      afterQueryDirective: afterQueryDirective,
      filterInput: null,
      suggestedSelection: null,
      specifiedPageable: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<bool> queryEmptyAndPrepareToCreate({
    FILTER_INPUT? filterInput,
    FilterSyncDirective filterSyncDirective = FilterSyncDirective.useCommitted,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return false;
    }
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryEmptyAndPrepareToCreate",
      parameters: {
        "filterInput": filterInput,
        "filterSyncDirective": filterSyncDirective,
      },
      isLibMethod: true,
    );
    //
    if (filterModel != null) {
      filterModel!._applyFilterSyncDirective(
        filterSyncDirective: filterSyncDirective,
        filterInput: filterInput,
      );
    }
    //
    return await __queryEmpty(
      executionTrace: executionTrace,
      filterInput: filterInput,
      prepareFormToCreateItem: true,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Clears all items in the block while setting the block state to Fresh.
  ///
  /// This simulates a successful query that yields zero items without hitting
  /// the remote server or backend data source.
  ///
  /// If [syncFilterDraft] is set to `true`, the associated [FilterModel] will
  /// commit its draft workspace snapshot to the committed realm prior to
  /// clearing the items.
  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<bool> queryEmpty({
    FILTER_INPUT? filterInput,
    bool prepareFormToCreateItem = false,
    FilterSyncDirective filterSyncDirective = FilterSyncDirective.useCommitted,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return false;
    }
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryEmpty",
      parameters: {
        "filterInput": filterInput,
        "prepareFormToCreateItem": prepareFormToCreateItem,
      },
      isLibMethod: true,
    );
    // Synchronize draft snapshot into committed realm if explicitly requested
    if (filterModel != null) {
      filterModel!._applyFilterSyncDirective(
        filterSyncDirective: filterSyncDirective,
        filterInput: filterInput,
      );
    }
    //
    return await __queryEmpty(
      executionTrace: executionTrace,
      filterInput: filterInput,
      prepareFormToCreateItem: prepareFormToCreateItem,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  /// Docs: [14739], [14811*].
  ///
  @nonVirtual
  @_RootMethodAnnotation()
  @_BlockQueryAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<BlockQueryResult> query({
    BlockAfterQueryDirective afterQueryDirective =
        BlockAfterQueryDirective.setAnItemAsCurrentIfNeed,
    FILTER_INPUT? filterInput,
    SuggestedSelection? suggestedSelection,
    Pageable? pageable,
    FilterSyncDirective filterSyncDirective = FilterSyncDirective.useCommitted,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return BlockQueryResult._queryBlockedTemporarily();
    }
    //
    final suggestedListUpdateStrategy = ListUpdateStrategy.replace;

    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "query",
      parameters: {
        "afterQueryDirective": afterQueryDirective,
        "suggestedListUpdateStrategy": suggestedListUpdateStrategy,
        "filterInput": filterInput,
        "suggestedSelection": suggestedSelection,
        "pageable": pageable,
      },
      isLibMethod: true,
    );
    if (filterModel != null) {
      filterModel!._applyFilterSyncDirective(
        filterSyncDirective: filterSyncDirective,
        filterInput: filterInput,
      );
    }
    //
    final qryMethod = BlockQryMethodName.query;
    //
    return await __queryBlock(
      executionTrace: executionTrace,
      qryMethod: qryMethod,
      suggestedListUpdateStrategy: suggestedListUpdateStrategy,
      afterQueryDirective: afterQueryDirective,
      filterInput: filterInput,
      suggestedSelection: suggestedSelection,
      specifiedPageable: pageable,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  ///
  @nonVirtual
  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockQueryAndPrepareToEditAnnotation()
  Future<BlockQueryResult> queryAndPrepareToEdit({
    FILTER_INPUT? filterInput,
    ListUpdateStrategy suggestedListUpdateStrategy = ListUpdateStrategy.replace,
    SuggestedSelection<ID>? suggestedSelection,
    Pageable? pageable,
    FilterSyncDirective filterSyncDirective = FilterSyncDirective.useCommitted,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return BlockQueryResult._();
    }
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryAndPrepareToEdit",
      parameters: {
        "filterInput": filterInput,
        "suggestedListUpdateStrategy": suggestedListUpdateStrategy,
        "suggestedSelection": suggestedSelection,
        "pageable": pageable,
        "filterSyncDirective": filterSyncDirective,
      },
      isLibMethod: true,
    );
    //
    if (filterModel != null) {
      filterModel!._applyFilterSyncDirective(
        filterSyncDirective: filterSyncDirective,
        filterInput: filterInput,
      );
    }
    //
    final XShelf xShelf = _XShelfBlockQueryThenPrepareToEdit(
      block: this,
      filterInput: filterInput,
      pageable: null,
      suggestedListUpdateStrategy: suggestedListUpdateStrategy,
      afterQueryDirective:
          BlockAfterQueryDirective.setAnItemAsCurrentThenLoadForm,
      suggestedSelection: suggestedSelection,
    );
    //
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    //
    final thisXBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;
    BlockQueryResult queryResult = thisXBlock.queryResult;
    return queryResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Clear and prepare Form to create new record.
  /// If this block has a FormModel its data state set to "Ready", else its data state set to "Pending".
  ///
  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockQueryAndPrepareToCreateAnnotation()
  Future<BlockQueryResult> queryAndPrepareToCreate({
    FILTER_INPUT? filterInput,
    FilterSyncDirective filterSyncDirective = FilterSyncDirective.useCommitted,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return BlockQueryResult._();
    }
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryAndPrepareToCreate",
      parameters: {
        "filterInput": filterInput,
        "filterSyncDirective": filterSyncDirective,
      },
      isLibMethod: true,
    );
    //
    if (filterModel != null) {
      filterModel!._applyFilterSyncDirective(
        filterSyncDirective: filterSyncDirective,
        filterInput: filterInput,
      );
    }
    //
    executionTrace.addInfo(
      codeId: "#56000",
      shortDesc: "Creating <b>$_XShelfBlockQueryThenPrepareToCreate</b>..",
    );
    //
    final XShelf xShelf = _XShelfBlockQueryThenPrepareToCreate(
      block: this,
      filterInput: filterInput,
      pageable: null,
      listUpdateStrategy: ListUpdateStrategy.replace,
      afterQueryDirective: BlockAfterQueryDirective.createNewItem,
      suggestedSelection: null,
    );
    //
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    //
    final thisXBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;
    BlockQueryResult queryResult = thisXBlock.queryResult;
    return queryResult;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  ID __getItemIdShowErr(ITEM item, {required bool showErr}) {
    try {
      ID id = _getItemIdInternal(item);
      return id;
    } catch (e, stackTrace) {
      if (showErr) {
        _handleError(
          shelf: shelf,
          methodName: "performLoadItemDetailById",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: null,
        );
      }
      rethrow;
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  ID _getItemIdInternal(ITEM item) {
    return item.id;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<void>> performDeleteItemById({
    required ID itemId,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> performLoadItemDetailById({
    required ID itemId,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  ITEM convertItemDetailToItem({required ITEM_DETAIL itemDetail});

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called before calling a Form to create.
  ///
  @_AbstractMethodAnnotation()
  FORM_INPUT buildInputForCreationForm({
    required Object? parentBlockCurrentItem,
    required FILTER_CRITERIA filterCriteria,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ADDITIONAL_FORM_RELATED_DATA> performLoadAdditionalFormRelatedData({
    required Object? parentBlockCurrentItem,
    required ITEM_DETAIL? currentItemDetail,
    required FILTER_CRITERIA filterCriteria,
  });

  // ***************************************************************************
  // ***************************************************************************

  FORM_INPUT __buildInputForCreationForm(ExecutionTrace executionTrace) {
    final Object? parentBlockCurrentItem = parent?.currentItem;
    final FILTER_CRITERIA? currentFilterCriteria = filterCriteria;

    if (currentFilterCriteria == null) {
      // Test Case: [01c]
      // Make sure never get this error.
      throw AppError(errorMessage: "FilterCriteria is null");
    }
    executionTrace.addControllableCall(
      codeId: "#05100",
      caller: this,
      methodName: "buildInputForCreationForm",
      suffixShortDesc: "",
      parameters: {
        "parentBlockCurrentItem": parentBlockCurrentItem,
        "filterCriteria": currentFilterCriteria,
      },
    );
    return buildInputForCreationForm(
      parentBlockCurrentItem: parentBlockCurrentItem,
      filterCriteria: currentFilterCriteria,
    );
  }

  Future<ADDITIONAL_FORM_RELATED_DATA?> _performLoadAdditionalFormRelatedData(
    ExecutionTrace executionTrace,
  ) async {
    try {
      final Object? parentBlockCurrentItem = parent?.currentItem;
      final FILTER_CRITERIA? currentFilterCriteria = filterCriteria;

      if (currentFilterCriteria == null) {
        // TODO: Test Cases.
        // Make sure never get this error.
        throw AppError(errorMessage: "FilterCriteria is null");
      }
      executionTrace.addControllableCall(
        codeId: "#05000",
        caller: this,
        methodName: "performLoadAdditionalFormRelatedData",
        suffixShortDesc: "",
        parameters: {
          "parentBlockCurrentItem": parentBlockCurrentItem,
          "currentItemDetail": currentItemDetail,
          "filterCriteria": filterCriteria,
        },
      );
      return await performLoadAdditionalFormRelatedData(
        parentBlockCurrentItem: parentBlockCurrentItem,
        currentItemDetail: currentItemDetail,
        filterCriteria: currentFilterCriteria,
      );
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "performLoadAdditionalFormRelatedData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.blockInitFormRelatedData,
      );
      executionTrace.addInfo(
        codeId: "#05020",
        shortDesc:
            "The ${debugObjHtml(this)}.performLoadAdditionalFormRelatedData() method was called with an error!",
        errorInfo: errorInfo,
      );
      return null;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Rename to shouldRetainItem.
  @_AbstractMethodAnnotation()
  bool needToKeepItemInList({
    required Object? parentBlockCurrentItemId,
    required FILTER_CRITERIA filterCriteria,
    required ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called for each ITEM in the list you just queried
  /// to ensure that it actually matches the current item of the parent Block.
  /// If it doesn't match, it will be removed from this Block's list.
  ///
  /// If you don't care about this method, you can simply set BlockConfig.enforceParentLinkConstraint = true.
  ///
  @_AbstractMethodAnnotation()
  Object resolveParentBlockItemId({required ITEM item}) {
    throw UnimplementedError(
        'The resolveParentBlockItemId() method must be implemented when config.enforceParentLinkConstraint is true '
        'to determine the parent reference of each item.');
  }

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  int? specifyItemIndexToSetAsCurrent() {
    return null;
  }

  // ***************************************************************************
  // ************* API METHOD **************************************************
  // ***************************************************************************

  /// Executes the native, full-scale database query sequence for this Block.
  ///
  /// This method is responsible for communicating with the remote API to fetch either
  /// a segmented page of data or the entire collection of records depending on the active
  /// query mode.
  ///
  /// ### Parameters:
  /// * [parentBlockCurrentItem] - Represents the parent node context, mapped directly
  ///   from `parentBlock.currentItem`. Used to establish nested relationships (e.g., retrieving
  ///   contributors linked strictly to a specific project ID).
  /// * [filterCriteria] - Mapped from `filterModel.filterCriteria`. Upon a successful
  ///   network response, this state is officially assigned to the Block's internal `filterCriteria`.
  /// * [sortableCriteria] - Evaluated at runtime using the resolution chain:
  ///   `serverSideSortModel?.sortableCriteria ?? SortableCriteria._empty()`.
  /// * [pageable] - Controls the viewport boundaries.
  ///   * **Strict Constraint**: This parameter is **guaranteed to be null** when the system
  ///     is operating in [BlockNativeQueryMode.fullQuery] to instruct the server to skip partitioning.
  ///   * This parameter is **guaranteed to be non-null** when operating in [BlockNativeQueryMode.pageableQuery],
  ///     containing the index and size limits for page segmenting.
  ///
  /// ### Configuration & Runtime Usage:
  /// * Developers can configure the initial query behavior (`BlockNativeQueryMode`)
  ///   directly inside the [BlockConfig].
  /// * **Runtime Resolution**:
  ///   * Retrieve the currently active query mode via the property: `block.nativeQueryMode`.
  ///   * Retrieve the pageable configuration used in the last query execution via the property: `block.pageable`.
  @_AbstractMethodAnnotation()
  Future<ApiResult<PageData<ITEM>?>> performQuery({
    required Object? parentBlockCurrentItem,
    required FILTER_CRITERIA filterCriteria,
    required SortableCriteria sortableCriteria,
    required Pageable? pageable,
  });

  /// Retrieves a specific subset of full entities matching the provided sequence of unique identifiers.
  ///
  /// Unlike [performQuery], which is bound by pagination or global filters, this method is targeted,
  /// serving as the core engine for post-mutation viewport synchronization.
  ///
  /// ### Parameters:
  /// * [parentBlockCurrentItem] - Mapped directly from `parentBlock.currentItem`. Used to
  ///   ensure scope boundaries are maintained even during direct ID lookups.
  /// * [filterCriteria] - Mapped from `filterModel.filterCriteria`. Handed over to guarantee
  ///   the fetched items still align with the currently applied search context.
  /// * [sortableCriteria] - Evaluated at runtime using:
  ///   `serverSideSortModel?.sortableCriteria ?? SortableCriteria._empty()`.
  /// * [itemIds] - A strict collection of [ID]s to pull from the server.
  ///   * This list represents the precise footprint of entities that were created, modified, or
  ///     needs to be reconciled following a backend mutation.
  ///   * *Note*: For a comprehensive understanding of how [itemIds] are gathered, processed, and
  ///     how they dictate the final viewport merge strategies, please refer to the detailed
  ///     specifications in the **[BlockBackendAction]** and **[BlockViewportSyncConfig]** documentation.
  @_AbstractMethodAnnotation()
  Future<ApiResult<ListData<ITEM>?>> performQueryByItemIds({
    required Object? parentBlockCurrentItem,
    required FILTER_CRITERIA filterCriteria,
    required SortableCriteria sortableCriteria,
    required List<ID> itemIds,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_OverridableMethodAnnotation()
  void setChildrenForParent({
    required Object currentItemOfParentBlock,
    required List<ITEM> items,
  }) {
    // Override if need.
  }

  // ***************************************************************************
  // ***************************************************************************

  // void __clearBlockError() {
  //   _blockErrorInfo = null;
  // }
  //
  // void __setBlockErrorInfo(BlockErrorInfo errorInfo) {
  //   _blockErrorInfo = errorInfo;
  // }

  // ***************************************************************************
  // ***************************************************************************

  ITEM __convertItemDetailToItem({required ITEM_DETAIL itemDetail}) {
    return convertItemDetailToItem(itemDetail: itemDetail);
  }

  // ***************************************************************************
  // ***************************************************************************

  // void __setChildrenForParent() {
  //   try {
  //     Object? itemParent = parent?.currentItemDetail;
  //     if (itemParent != null && dataState == DataState.loaded) {
  //       setChildrenForParent(
  //         currentItemOfParentBlock: itemParent,
  //         items: items,
  //       );
  //     }
  //   } catch (e, stackTrace) {
  //     print(stackTrace);
  //   }
  //   for (var childBlock in _childBlocks) {
  //     childBlock.__setChildrenForParent();
  //   }
  // }

  // ***************************************************************************
  // ***************************************************************************

  void __setCurrentItemOnlyAndItemState({
    required ID? id,
    required ITEM? item,
    required ITEM_DETAIL? itemDetail,
  }) {
    _blockData._setCurrentItemOnly(
      id: id,
      refreshedItem: item,
      refreshedItemDetail: itemDetail,
    );
    if (id == null) {
      _blockData._setBlockItemDataState(
        newBlockItemDataState: BlockItemDataStateNone(),
      );
    } else {
      _blockData._setBlockItemDataState(
        newBlockItemDataState: BlockItemDataStateFresh(),
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Remove this item from Interface because it no longer exists on the server
  ///
  Future<void> __removeItemFromList({
    required ExecutionTrace executionTrace,
    required ITEM removeItem,
  }) async {
    _blockData._removeItem(removeItem: removeItem);
    //
    executionTrace.addInfo(
      codeId: "#43000",
      shortDesc: "Update <b>BlockItemsView</b>...",
    );
    ui.refreshItemsViewsOnly();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasCurrentItem() {
    return currentItemDetail != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_BlockBackendActionAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<BlockBackendActionResult> executeBackendAction({
    FILTER_INPUT? filterInput,
    SuggestedSelection? suggestedSelection,
    required ActionConfirmationType actionConfirmationType,
    required BlockBackendAction<ID> action,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeBackendAction",
      parameters: null,
      isLibMethod: true,
    );
    executionTrace.addNonControllableCall(
      codeId: "#71000",
      caller: this,
      methodName: "__canBackendAction",
      suffixShortDesc: "",
      parameters: {
        "checkBusy": true,
      },
      tipDocument: TipDocument.canDoAction,
    );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<BlockBackendActionPrecheck> actionable =
        __canBackendAction(
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      executionTrace.addInfo(
        codeId: "#71040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
      );
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockBackendActionResult(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await _showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    //
    if (!confirm) {
      return BlockBackendActionResult(
        precheck: BlockBackendActionPrecheck.cancelled,
      );
    }
    //
    final viewportSyncStrategy =
        BlockViewportSyncStrategy.resolveViewportSyncStrategy2(
      nativeQueryMode: nativeQueryMode,
      backendIntentInFullQueryMode: action.config.syncStrategyOnFullQueryMode,
      backendIntentInPageableQueryMode:
          action.config.syncStrategyOnPageableQueryMode,
      syncConfig: effectiveConfig.viewportSyncConfig,
    );
    executionTrace.addInfo(
      codeId: "#71346",
      shortDesc: "Resolved viewportSyncStrategy: $viewportSyncStrategy",
    );
    //
    final XShelf xShelf = _XShelfBlockBackendActionExecution(
      block: this,
      filterInput: filterInput,
      viewportSyncStrategy: viewportSyncStrategy,
    );
    //
    final thisXBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;
    //
    executionTrace.addExecutionIntent(
      codeId: "#71340",
      owner: this,
      executionIntentType: BlockBackendActionIntent,
      suffixShortDesc: "",
    );
    final BlockBackendActionIntent<ID, ITEM, ITEM_DETAIL> executionIntent =
        thisXBlock._createAndSetBackendAction(action: action);

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockQuickItemCreationActionAnnotation()
  Future<BlockQuickItemCreationResult> executeQuickItemCreationAction({
    required BlockQuickItemCreationAction<ID, ITEM, ITEM_DETAIL> action,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeQuickItemCreationAction",
      parameters: {
        "action": action,
      },
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    final bool checkAllowTrue = true;
    //
    executionTrace.addInfo(
      codeId: "#73000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canQuickCreateItem() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
        "checkAllow": checkAllowTrue,
      },
    );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<BlockQuickItemCreationPrecheck> actionable =
        __canQuickCreateItem(
      checkBusy: checkBusyTrue,
      checkAllow: checkAllowTrue,
    );
    if (!actionable.yes) {
      executionTrace.addInfo(
        codeId: "#73040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
      );
      // _refreshErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockQuickItemCreationResult(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await _showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    if (!confirm) {
      return BlockQuickItemCreationResult(
        precheck: BlockQuickItemCreationPrecheck.cancelled,
      );
    }
    //
    final XShelf xShelf = _XShelfBlockQuickItemCreation(block: this);
    //
    final thisXBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;
    //
    executionTrace.addExecutionIntent(
      codeId: "#73340",
      owner: this,
      executionIntentType: BlockQuickItemCreationAction,
      suffixShortDesc: "",
    );

    final BlockQuickItemCreationIntent<ID, ITEM, ITEM_DETAIL> executionIntent =
        thisXBlock._createAndSetBlockQuickItemCreation(action: action);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockQuickItemUpdateActionAnnotation()
  Future<BlockQuickItemUpdateResult> executeQuickItemUpdateAction({
    required BlockQuickItemUpdateAction<ID, ITEM, ITEM_DETAIL> action,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeQuickItemUpdateAction",
      parameters: {
        "action": action,
      },
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    final bool checkAllowTrue = true;
    //
    executionTrace.addInfo(
      codeId: "#72000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canQuickUpdateItem() to check before execute the action.",
      parameters: {
        "item": action.item,
        "checkBusy": checkBusyTrue,
        "checkAllow": checkAllowTrue,
        "errorIfItemNotInTheBlock": action.config.errorIfItemNotInTheBlock,
      },
    );
    // @Same-Code-Precheck-01
    final Actionable<BlockQuickItemUpdatePrecheck> actionable =
        __canQuickUpdateItem(
      item: action.item,
      checkBusy: checkBusyTrue,
      checkAllow: checkAllowTrue,
      errorIfItemNotInTheBlock: action.config.errorIfItemNotInTheBlock,
    );
    //
    if (!actionable.yes) {
      executionTrace.addInfo(
        codeId: "#72040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
      );
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockQuickItemUpdateResult(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await _showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    if (!confirm) {
      return BlockQuickItemUpdateResult(
        precheck: BlockQuickItemUpdatePrecheck.cancelled,
      );
    }
    //
    final XShelf xShelf = _XShelfBlockQuickItemUpdate(block: this);
    //
    final thisXBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;
    //
    executionTrace.addExecutionIntent(
      codeId: "#72340",
      owner: this,
      executionIntentType: BlockQuickItemUpdateIntent,
      suffixShortDesc: "",
    );
    final BlockQuickItemUpdateIntent<ID, ITEM, ITEM_DETAIL> executionIntent =
        thisXBlock._createAndSetBlockQuickItemUpdate(action: action);

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockSelectFirstItemAsCurrentAnnotation()
  Future<BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>>
      refreshFirstItemAndSetAsCurrent({
    bool forceLoadForm = false,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "refreshFirstItemAndSetAsCurrent",
      parameters: {
        "forceLoadForm": forceLoadForm,
      },
      isLibMethod: true,
    );
    return __refreshItemAndSetAsCurrent(
      executionTrace: executionTrace,
      methodName: "refreshFirstItemAndSetAsCurrent",
      item: firstItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      forceLoadItem: true,
      forceLoadForm: forceLoadForm,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockSelectNextItemAsCurrentAnnotation()
  Future<BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>>
      refreshNextItemAndSetAsCurrent({
    bool forceLoadForm = false,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "refreshNextItemAndSetAsCurrent",
      parameters: {
        "forceLoadForm": forceLoadForm,
      },
      isLibMethod: true,
    );
    //
    ITEM? nextItem = nextSiblingItem;
    //
    return __refreshItemAndSetAsCurrent(
      executionTrace: executionTrace,
      methodName: "refreshNextItemAndSetAsCurrent",
      item: nextItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      forceLoadItem: true,
      forceLoadForm: forceLoadForm,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockSelectPreviousItemAsCurrentAnnotation()
  Future<BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>>
      refreshPreviousItemAndSetAsCurrent({
    bool forceLoadForm = false,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "refreshPreviousItemAndSetAsCurrent",
      parameters: {
        "forceLoadForm": forceLoadForm,
      },
      isLibMethod: true,
    );
    //
    ITEM? previousItem = previousSiblingItem;
    //
    return __refreshItemAndSetAsCurrent(
      executionTrace: executionTrace,
      methodName: "refreshPreviousItemAndSetAsCurrent",
      item: previousItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      forceLoadItem: true,
      forceLoadForm: forceLoadForm,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Prepare to edit an item in a Form.
  ///
  Future<BlockSetCurrentItemResult> _prepareFormToEditCurrentItem() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "_prepareFormToEditItem",
      parameters: {},
      isLibMethod: true,
    );
    //
    return await refreshCurrentItem(forceLoadForm: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Prepare to create an item in a Form.
  ///
  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockPrepareFormToCreateItemAnnotation()
  Future<PrepareItemCreationResult> prepareFormToCreateItem({
    FORM_INPUT? formInput,
    bool initDirty = false,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "prepareFormToCreateItem",
      parameters: {
        "formInput": formInput,
        "initDirty": initDirty,
      },
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    final bool checkAllowTrue = true;
    final creationTypeForm = ItemCreationType.form;
    //
    executionTrace.addInfo(
      codeId: "#77000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canCreateItem() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
        "checkAllow": checkAllowTrue,
        "creationType": creationTypeForm,
      },
    );
    // @Same-Code-Precheck-01
    Actionable<BlockItemCreationPrecheck> actionable = __canCreateItem(
      checkBusy: checkBusyTrue,
      checkAllow: checkAllowTrue,
      creationType: creationTypeForm,
    );
    if (!actionable.yes) {
      executionTrace.addInfo(
        codeId: "#77040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
      );
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return PrepareItemCreationResult(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    formInput?.formAction = FormAction.create;
    //
    final XShelf xShelf = _XShelfPrepareFormToCreateItem(block: this);
    final thisXBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;
    //
    executionTrace.addExecutionIntent(
      codeId: "#77340",
      owner: this,
      executionIntentType: BlockPrepareFormToCreateItemIntent,
      suffixShortDesc: "",
    );
    final executionIntent =
        thisXBlock._createAndSetBlockExecutionIntentPrepareFormToCreateItem(
      xBlock: thisXBlock,
      initDirty: initDirty,
      formInput: formInput,
    );
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    //
    return await executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockDeleteSelectedItemsAnnotation()
  Future<BlockItemsDeletionResult<ID, ITEM, ITEM_DETAIL>> deleteSelectedItems({
    required CurrentItemInclusion currentItemInclusion,
    required bool stopIfError,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "deleteSelectedItems",
      parameters: {
        "currentItemInclusion": currentItemInclusion,
        "stopIfError": stopIfError,
      },
      isLibMethod: true,
    );
    List<ITEM> selItems = _blockData.getSelectedItems(
      currentItemInclusion: currentItemInclusion,
    );
    executionTrace.addInfo(
      codeId: "#66000",
      shortDesc: "Selected Items: ${debugObjHtml(selItems)}..",
    );
    //
    return await __deleteItems(
      executionTrace: executionTrace,
      methodName: "deleteSelectedItems",
      items: selItems,
      stopIfError: stopIfError,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockDeleteCheckedItemsAnnotation()
  Future<BlockItemsDeletionResult> deleteCheckedItems({
    required CurrentItemInclusion currentItemInclusion,
    required bool stopIfError,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "deleteCheckedItems",
      parameters: {
        "currentItemInclusion": currentItemInclusion,
        "stopIfError": stopIfError,
      },
      isLibMethod: true,
    );
    List<ITEM> chkItems = _blockData.getCheckedItems(
      currentItemInclusion: currentItemInclusion,
    );
    executionTrace.addInfo(
      codeId: "#64000",
      shortDesc: "Checked Items: ${debugObjHtml(chkItems)}..",
    );
    //
    return await __deleteItems(
      executionTrace: executionTrace,
      methodName: "deleteCheckedItems",
      items: chkItems,
      stopIfError: stopIfError,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<BlockItemsDeletionResult<ID, ITEM, ITEM_DETAIL>> deleteItems({
    required List<ITEM> items,
    required bool stopIfError,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "deleteItems",
      parameters: {
        "items": items,
        "stopIfError": stopIfError,
      },
      isLibMethod: true,
    );
    executionTrace.addInfo(
      codeId: "#67000",
      shortDesc: "Items: ${debugObjHtml(items)}..",
    );
    return await __deleteItems(
      executionTrace: executionTrace,
      methodName: "deleteItems",
      items: items,
      stopIfError: stopIfError,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockDeleteCurrentItemAnnotation()
  Future<BlockItemDeletionResult<ID, ITEM, ITEM_DETAIL>>
      deleteCurrentItem() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "deleteCurrentItem",
      parameters: null,
      isLibMethod: true,
    );
    ITEM? currItem = currentItem;
    //
    return __deleteItem(
      executionTrace: executionTrace,
      methodName: "deleteCurrentItem",
      item: currItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      errorIfItemNotInTheBlock: true,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_BlockDeleteItemAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<BlockItemDeletionResult<ID, ITEM, ITEM_DETAIL>> deleteItem({
    required ITEM item,
    bool errorIfItemNotInTheBlock = true,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "deleteItem",
      parameters: {
        "item": item,
        "errorIfItemNotInTheBlock": errorIfItemNotInTheBlock,
      },
      isLibMethod: true,
    );
    return __deleteItem(
      executionTrace: executionTrace,
      methodName: "deleteItem",
      item: item,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
      errorIfItemNotInTheBlock: errorIfItemNotInTheBlock,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  ///
  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_BlockRefreshCurrentItemAnnotation()
  Future<BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>> refreshCurrentItem({
    bool forceLoadForm = false,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "refreshCurrentItem",
      parameters: {
        "forceLoadForm": forceLoadForm,
      },
      isLibMethod: true,
    );
    //
    return await __refreshItemAndSetAsCurrent(
      executionTrace: executionTrace,
      methodName: 'refreshCurrentItem',
      item: currentItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      forceLoadItem: true,
      forceLoadForm: forceLoadForm,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _processNavigationIntent({
    required BuildContext context,
    required ExecutionUnitResult result,
    required NavigationIntent intent,
  }) {
    try {
      final executionTrace = FlutterArtist.codeFlowLogger._addNavigationIntent(
        ownerClassInstance: this,
        intent: intent,
      );
      final bool isActionSuccess = result.successForFirst;

      executionTrace.addInfo(
        codeId: "#81000",
        shortDesc: "Calling ${debugObjHtml(this)}._processNavigationIntent().",
        parameters: {
          "intent": intent,
        },
      );
      final List<RouteKey> stack = context.faRouter.stack;

      executionTrace.addInfo(
        codeId: "#81020",
        shortDesc: "Route Stack:",
        note: "Open Extra-Info Dialog for details",
        extraInfos: stack.map((rk) => rk.toString()).toList(),
      );

      if (!isActionSuccess && !intent.executeOnFailure) {
        return;
      }
      final router = context.faRouter;
      // to()
      if (intent is _NavigationToIntent) {
        executionTrace.addInfo(
          codeId: "#81040",
          shortDesc: "Calling router.to().",
          parameters: {
            "intent": intent,
          },
        );
        router.to(intent.path, builder: intent.builder, extra: intent.extra);
      }
      // off()
      else if (intent is _NavigationOffIntent) {
        executionTrace.addInfo(
          codeId: "#81080",
          shortDesc: "Calling router.off().",
          parameters: {
            "intent": intent,
          },
        );
        router.off(intent.path, builder: intent.builder, extra: intent.extra);
      }
      // offAll()
      else if (intent is _NavigationOffAllIntent) {
        executionTrace.addInfo(
          codeId: "#81120",
          shortDesc: "Calling router.offAll().",
          parameters: {
            "intent": intent,
          },
        );
        router.offAll(intent.path,
            builder: intent.builder, extra: intent.extra);
      }
      // pop()
      else if (intent is _NavigationPopIntent) {
        executionTrace.addInfo(
          codeId: "#81160",
          shortDesc: "Calling router.pop().",
          parameters: {
            "intent": intent,
          },
        );
        router.pop();
      }
      // dialog()
      else if (intent is _NavigationShowDialogIntent) {
        executionTrace.addInfo(
          codeId: "#81200",
          shortDesc: "Calling router.showDialog().",
          parameters: {
            "intent": intent,
          },
        );
        router.showDialog(
          intent.path,
          builder: intent.builder,
          guards: intent.guards,
          extra: intent.extra,
          barrierDismissible: intent.barrierDismissible,
        );
      }
      // closeAllDialogs()
      else if (intent is _NavigationCloseAllDialogsIntent) {
        executionTrace.addInfo(
          codeId: "#81240",
          shortDesc: "Calling router.closeAllDialogs().",
          parameters: {
            "intent": intent,
          },
        );
        router.closeAllDialogs();
      }
      // endDrawer()
      else if (intent is _NavigationOpenEndDrawerIntent) {
        executionTrace.addInfo(
          codeId: "#81280",
          shortDesc: "Calling Scaffold.of(context).openEndDrawer().",
          parameters: {
            "intent": intent,
          },
        );
        Scaffold.of(context).openEndDrawer();
      }
      // drawer()
      else if (intent is _NavigationOpenDrawerIntent) {
        executionTrace.addInfo(
          codeId: "#81320",
          shortDesc: "Calling Scaffold.of(context).openDrawer().",
          parameters: {
            "intent": intent,
          },
        );
        Scaffold.of(context).openDrawer();
      }
      // Custom Intent.
      else if (intent is _NavigationCustomIntent) {
        executionTrace.addInfo(
          codeId: "#81360",
          shortDesc: "Calling intent.onExecute().",
          parameters: {
            "intent": intent,
          },
        );
        intent.onExecute(context, result);
      }
      // else.
      else {
        throw UnimplementedError("TODO _processNavigationIntent");
      }
    } catch (e, stackTrace) {
      final errorInfo = _handleError(
        shelf: shelf,
        methodName: "${getClassName(this)}._processNavigationIntent",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __broadcastEventFromBlockToOtherShelves({
    required ExecutionTrace executionTrace,
    required EventType eventType,
    required List<ID> effectedItemIds,
  }) {
    if (!effectiveConfig.eventBroadcastEnabled) {
      return;
    }
    //
    _EventDispatcher.broadcastExternal<ID>(
      eventType: eventType,
      eventBlock: this,
      mainEvents: getDeclaredMainBroadcastDataTypes().toList(),
      effectedItemIds: effectedItemIds,
      extraEvents: effectiveConfig.extraBroadcastEvents,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<BlockQueryResult> __queryBlock({
    required ExecutionTrace executionTrace,
    required BlockQryMethodName qryMethod,
    required ListUpdateStrategy suggestedListUpdateStrategy,
    required BlockAfterQueryDirective afterQueryDirective,
    required FILTER_INPUT? filterInput,
    required SuggestedSelection? suggestedSelection,
    required Pageable? specifiedPageable,
  }) async {
    Pageable? usedPageable;
    final bool isQueryMoreFlow;
    switch (qryMethod) {
      case BlockQryMethodName.query:
        usedPageable = specifiedPageable;
        isQueryMoreFlow = false;
      case BlockQryMethodName.queryNextPage:
        Pageable? currentPageable = _blockData.pageable;
        isQueryMoreFlow = false;
        if (currentPageable == null) {
          return BlockQueryResult._noCurrentPagination();
        }
        usedPageable = currentPageable.next();
      case BlockQryMethodName.queryPreviousPage:
        Pageable? currentPageable = _blockData.pageable;
        isQueryMoreFlow = false;
        if (currentPageable == null) {
          return BlockQueryResult._noCurrentPagination();
        }
        usedPageable = currentPageable.previous();
        if (usedPageable == null) {
          return BlockQueryResult._noPreviousPage();
        }
      case BlockQryMethodName.queryMore:
        usedPageable = nextPageable;
        isQueryMoreFlow = true;
        if (usedPageable == null) {
          return BlockQueryResult._noNextPage();
        }
    }
    //
    final XShelf xShelf = _XShelfBlockQuery(
      block: this,
      filterInput: filterInput,
      pageable: usedPageable,
      listUpdateStrategy: suggestedListUpdateStrategy,
      afterQueryDirective: afterQueryDirective,
      suggestedSelection: suggestedSelection,
    );
    final xBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;

    final BlockQueryIntent<ID, ITEM, ITEM_DETAIL> executionIntent =
        xBlock._createAndSetBlockExecutionIntentQuery(
      isQueryMoreFlow: isQueryMoreFlow,
    );
    //
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> __queryEmpty({
    required ExecutionTrace executionTrace,
    required FILTER_INPUT? filterInput,
    bool prepareFormToCreateItem = false,
  }) async {
    executionTrace.addInfo(
      codeId: "#53000",
      shortDesc: "Creating <b>$_XShelfBlockQueryEmpty</b>..",
    );
    //
    final XShelf xShelf = _XShelfBlockQueryEmpty(
      block: this,
      filterInput: filterInput,
      pageable: pageable,
      listUpdateStrategy: ListUpdateStrategy.replace,
      afterQueryDirective: prepareFormToCreateItem
          ? BlockAfterQueryDirective.createNewItem
          : BlockAfterQueryDirective.setAnItemAsCurrent,
      suggestedSelection: null,
    );
    //
    executionTrace.addNonControllableCall(
      codeId: "#53100",
      caller: this,
      methodName: "_initQueryExecutionUnits",
      suffixShortDesc: "",
    );
    //
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    //
    final thisXBlock =
        xShelf.findXBlockByName(name) as XBlock<ID, ITEM, ITEM_DETAIL>;
    BlockQueryResult queryResult = thisXBlock.queryResult;
    return queryResult.successForAll;
  }

  // ***************************************************************************
  // *********** isAllowXXX() method *******************************************
  // ***************************************************************************

  ///
  /// Allows reset the Form or not according to the application logic.
  ///
  bool isFormResetAllowed() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows querying the block or not according to the application logic.
  ///
  bool isQueryAllowed() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows creating a new Item or not according to the application logic.
  ///
  bool isItemCreationAllowed() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows edit an Item or not according to the application logic.
  ///
  bool isItemUpdateAllowed({required ITEM item}) {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  bool isItemDeletionAllowed({required ITEM item}) {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentItemUpdateAllowed() {
    ITEM? currentItem = this.currentItem;
    if (currentItem == null) {
      return false;
    }
    return isItemUpdateAllowed(item: currentItem);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentItemDeletionAllowed() {
    ITEM? currentItem = this.currentItem;
    if (currentItem == null) {
      return false;
    }
    return isItemDeletionAllowed(item: currentItem);
  }

  // ***************************************************************************
  // *********** __isAllowXXX() method *****************************************
  // ***************************************************************************

  ///
  /// Allows to Query the Block.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isQueryAllowed() {
    try {
      bool allow = isQueryAllowed();
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        errorInfo: ErrorInfo.fromError(error: e, stackTrace: stackTrace),
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows edit current item or not according to the application logic.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isFormResetAllowed() {
    try {
      bool allow = isFormResetAllowed();
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
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

  ///
  /// Allows updating an Item or not according to the application logic.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult _isItemUpdateAllowed({
    required ITEM item,
  }) {
    try {
      bool allow = isItemUpdateAllowed(item: item);
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
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

  ///
  /// Allows creating a new Item or not according to the application logic.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isItemCreationAllowed() {
    try {
      bool allow = isItemCreationAllowed();
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
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

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isItemDeletionAllowed({required ITEM item}) {
    try {
      bool allow = isItemDeletionAllowed(item: item);
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
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
  // *********** __canXXX() method *********************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemDeletionPrecheck> __canDeleteCurrentItem({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    return __canDeleteItem(
      checkBusy: checkBusy,
      item: currentItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      checkAllow: checkAllow,
      errorIfItemNotInTheBlock: true,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockQueryPrecheck> __canQuery({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockQueryPrecheck>.no(
          errCode: BlockQueryPrecheck.busy);
    }
    //
    if (checkAllow) {
      CheckAllowResult result = __isQueryAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockQueryPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockQueryPrecheck>.no(
            errCode: BlockQueryPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockQueryPrecheck>.no(
            errCode: BlockQueryPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockQueryPrecheck>.yes();
  }

  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemDeletionPrecheck> __canDeleteItem({
    required bool checkBusy,
    required bool errorIfItemNotInTheBlock,
    required ITEM? item,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemDeletionPrecheck>.no(
        errCode: BlockItemDeletionPrecheck.busy,
      );
    }
    //
    if (item == null) {
      if (errCodeIfItemIsNull == ErrCodeIfItemIsNull.noTarget) {
        return Actionable<BlockItemDeletionPrecheck>.no(
          errCode: BlockItemDeletionPrecheck.noTarget,
        );
      } else {
        return Actionable<BlockItemDeletionPrecheck>.no(
          errCode: BlockItemDeletionPrecheck.invalidTarget,
        );
      }
    }
    //
    if (errorIfItemNotInTheBlock) {
      ITEM? it = findItemSameIdWith(item: item);
      if (it == null) {
        return Actionable<BlockItemDeletionPrecheck>.no(
          errCode: BlockItemDeletionPrecheck.invalidTarget,
        );
      }
    }
    //
    if (checkAllow) {
      CheckAllowResult result = __isItemDeletionAllowed(item: item);
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockItemDeletionPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockItemDeletionPrecheck>.no(
            errCode: BlockItemDeletionPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockItemDeletionPrecheck>.no(
            errCode: BlockItemDeletionPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo, // [03a]
          );
      }
    }
    //
    return Actionable<BlockItemDeletionPrecheck>.yes();
  }

  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemsDeletionPrecheck> __canDeleteItems({
    required bool checkBusy,
    required bool checkAllow,
    required List<ITEM> items,
    required bool errorIfItemNotInTheBlock,
  }) {
    List<ITEM> rmvItems = FaItemsUtils.removeDuplicatedItems(
      items: items,
      getItemId: _getItemIdInternal,
    );
    //
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemsDeletionPrecheck>.no(
        errCode: BlockItemsDeletionPrecheck.busy,
      );
    }
    //
    if (errorIfItemNotInTheBlock) {
      for (ITEM item in rmvItems) {
        ITEM? it = findItemSameIdWith(item: item);
        if (it == null) {
          return Actionable<BlockItemsDeletionPrecheck>.no(
            errCode: BlockItemsDeletionPrecheck.invalidTarget,
          );
        }
        //
        if (checkAllow) {
          CheckAllowResult result = __isItemDeletionAllowed(item: item);
          switch (result.result) {
            case CheckAllow.allow:
              continue;
            case CheckAllow.notAllow:
              return Actionable<BlockItemsDeletionPrecheck>.no(
                errCode: BlockItemsDeletionPrecheck.notAllow,
              );
            case CheckAllow.error:
              return Actionable<BlockItemsDeletionPrecheck>.no(
                errCode: BlockItemsDeletionPrecheck.checkAllowMethodError,
                errorInfo: result.errorInfo,
              );
          }
        }
      }
    }
    //
    return Actionable<BlockItemsDeletionPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockBackendActionPrecheck> __canBackendAction({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockBackendActionPrecheck>.no(
        errCode: BlockBackendActionPrecheck.busy,
      );
    }
    switch (dataState) {
      case BlockDataStateNone():
        return Actionable<BlockBackendActionPrecheck>.no(
          errCode: BlockBackendActionPrecheck.blockInNoneState,
        );
      case BlockDataStatePending():
        return Actionable<BlockBackendActionPrecheck>.no(
          errCode: BlockBackendActionPrecheck.blockInPendingState,
        );
      case BlockDataStateLoadedStale():
        return Actionable<BlockBackendActionPrecheck>.no(
          errCode: BlockBackendActionPrecheck.blockInStaleState,
        );
      case BlockDataStateLoadedFresh():
        return Actionable<BlockBackendActionPrecheck>.yes();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemCreationPrecheck> __canCreateItem({
    required bool checkBusy,
    required ItemCreationType creationType,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemCreationPrecheck>.no(
        errCode: BlockItemCreationPrecheck.busy,
      );
    }
    if (creationType == ItemCreationType.form) {
      if (formModel == null) {
        return Actionable<BlockItemCreationPrecheck>.no(
          errCode: BlockItemCreationPrecheck.noForm,
        );
      }
    }
    // switch (dataState) {
    //   case DataState.pending:
    //     return Actionable<BlockItemCreationPrecheck>.no(
    //       errCode: BlockItemCreationPrecheck.blockInPendingState,
    //     );
    //   case DataState.none:
    //     return Actionable<BlockItemCreationPrecheck>.no(
    //       errCode: BlockItemCreationPrecheck.blockInNoneState,
    //     );
    //   case DataState.loaded:
    //     if (this.isLoadedAndStale) {
    //       return Actionable<BlockItemCreationPrecheck>.no(
    //         errCode: BlockItemCreationPrecheck.blockInStaleState,
    //       );
    //     }
    //     break;
    // }
    switch (dataState) {
      case BlockDataStateNone():
        return Actionable<BlockItemCreationPrecheck>.no(
          errCode: BlockItemCreationPrecheck.blockInNoneState,
        );
      case BlockDataStatePending():
        return Actionable<BlockItemCreationPrecheck>.no(
          errCode: BlockItemCreationPrecheck.blockInPendingState,
        );
      case BlockDataStateLoadedStale():
        return Actionable<BlockItemCreationPrecheck>.no(
          errCode: BlockItemCreationPrecheck.blockInStaleState,
        );
      case BlockDataStateLoadedFresh():
        break;
    }
    //
    if (checkAllow) {
      CheckAllowResult result = __isItemCreationAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockItemCreationPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockItemCreationPrecheck>.no(
            errCode: BlockItemCreationPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockItemCreationPrecheck>.no(
            errCode: BlockItemCreationPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockItemCreationPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockClearItemsPrecheck> __canClearItems({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockClearItemsPrecheck>.no(
        errCode: BlockClearItemsPrecheck.busy,
      );
    }
    bool hasBlockRep = ui.hasBlockContext(
      includeDescendants: true,
    );
    if (hasBlockRep) {
      return Actionable<BlockClearItemsPrecheck>.no(
        errCode: BlockClearItemsPrecheck.hasActiveUI,
      );
    }
    return Actionable<BlockClearItemsPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemEditPrecheck> __canUpdateItem({
    required ITEM item,
    required bool checkBusy,
    required ItemUpdateType updateType,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.busy,
      );
    }
    // switch (dataState) {
    //   case DataState.pending:
    //     return Actionable<BlockItemEditPrecheck>.no(
    //       errCode: BlockItemEditPrecheck.inPendingState,
    //     );
    //   case DataState.none:
    //     return Actionable<BlockItemEditPrecheck>.no(
    //       errCode: BlockItemEditPrecheck.blockInNoneState,
    //     );
    //   case DataState.loaded:
    //     if (isLoadedAndStale) {
    //       return Actionable<BlockItemEditPrecheck>.no(
    //         errCode: BlockItemEditPrecheck.blockInStaleState,
    //       );
    //     }
    //     break;
    // }
    switch (dataState) {
      case BlockDataStateNone():
        return Actionable<BlockItemEditPrecheck>.no(
          errCode: BlockItemEditPrecheck.blockInNoneState,
        );
      case BlockDataStatePending():
        return Actionable<BlockItemEditPrecheck>.no(
          errCode: BlockItemEditPrecheck.inPendingState,
        );
      case BlockDataStateLoadedStale():
        return Actionable<BlockItemEditPrecheck>.no(
          errCode: BlockItemEditPrecheck.blockInStaleState,
        );
      case BlockDataStateLoadedFresh():
        break;
    }
    //
    if (checkAllow) {
      CheckAllowResult result = _isItemUpdateAllowed(item: item);
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockItemEditPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockItemEditPrecheck>.no(
            errCode: BlockItemEditPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockItemEditPrecheck>.no(
            errCode: BlockItemEditPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockItemEditPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockQuickItemUpdatePrecheck> __canQuickUpdateItem({
    required ITEM item,
    required bool checkBusy,
    required bool checkAllow,
    required bool errorIfItemNotInTheBlock,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockQuickItemUpdatePrecheck>.no(
        errCode: BlockQuickItemUpdatePrecheck.busy,
      );
    }
    // switch (dataState) {
    //   case DataState.pending:
    //     return Actionable<BlockQuickItemUpdatePrecheck>.no(
    //       errCode: BlockQuickItemUpdatePrecheck.blockInPendingState,
    //     );
    //   case DataState.none:
    //     return Actionable<BlockQuickItemUpdatePrecheck>.no(
    //       errCode: BlockQuickItemUpdatePrecheck.blockInNoneState,
    //     );
    //   case DataState.loaded:
    //     if (isLoadedAndStale) {
    //       return Actionable<BlockQuickItemUpdatePrecheck>.no(
    //         errCode: BlockQuickItemUpdatePrecheck.blockInStaleState,
    //       );
    //     }
    //     break;
    // }
    switch (dataState) {
      case BlockDataStateNone():
        return Actionable<BlockQuickItemUpdatePrecheck>.no(
          errCode: BlockQuickItemUpdatePrecheck.blockInNoneState,
        );
      case BlockDataStatePending():
        return Actionable<BlockQuickItemUpdatePrecheck>.no(
          errCode: BlockQuickItemUpdatePrecheck.blockInPendingState,
        );
      case BlockDataStateLoadedStale():
        return Actionable<BlockQuickItemUpdatePrecheck>.no(
          errCode: BlockQuickItemUpdatePrecheck.blockInStaleState,
        );
      case BlockDataStateLoadedFresh():
        break;
    }
    //
    ITEM? internalItem = findItemSameIdWith(item: item);
    // Test Cases: [90b].
    if (errorIfItemNotInTheBlock && internalItem == null) {
      return Actionable<BlockQuickItemUpdatePrecheck>.no(
        errCode: BlockQuickItemUpdatePrecheck.invalidTarget,
      );
    }
    //
    if (checkAllow) {
      CheckAllowResult result = _isItemUpdateAllowed(item: item);
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockQuickItemUpdatePrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockQuickItemUpdatePrecheck>.no(
            errCode: BlockQuickItemUpdatePrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockQuickItemUpdatePrecheck>.no(
            errCode: BlockQuickItemUpdatePrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockQuickItemUpdatePrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockQuickItemCreationPrecheck> __canQuickCreateItem({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockQuickItemCreationPrecheck>.no(
        errCode: BlockQuickItemCreationPrecheck.busy,
      );
    }
    //
    switch (dataState) {
      case BlockDataStateNone():
        return Actionable<BlockQuickItemCreationPrecheck>.no(
          errCode: BlockQuickItemCreationPrecheck.blockInNoneState,
        );
      case BlockDataStatePending():
        return Actionable<BlockQuickItemCreationPrecheck>.no(
          errCode: BlockQuickItemCreationPrecheck.blockInPendingState,
        );
      case BlockDataStateLoadedStale():
        return Actionable<BlockQuickItemCreationPrecheck>.no(
          errCode: BlockQuickItemCreationPrecheck.blockInStaleState,
        );
      case BlockDataStateLoadedFresh():
        break;
    }
    //
    if (checkAllow) {
      CheckAllowResult result = __isItemCreationAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockQuickItemCreationPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockQuickItemCreationPrecheck>.no(
            errCode: BlockQuickItemCreationPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockQuickItemCreationPrecheck>.no(
            errCode: BlockQuickItemCreationPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockQuickItemCreationPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockFormResetPrecheck> __canResetForm({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    if (formModel == null) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.noForm,
      );
    }
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.busy,
      );
    }
    if (!formModel!.isDirty()) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.formIsNotDirty,
      );
    }
    if (!formModel!.formInitialDataReady) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.formInitialDataNotReady,
      );
    }
    switch (formModel!.formMode) {
      case FormMode.none:
        return Actionable<BlockFormResetPrecheck>.no(
          errCode: BlockFormResetPrecheck.formInNoneMode,
        );
      case FormMode.creation:
        break; // Do nothing.
      case FormMode.edit:
        break; // Do nothing.
    }
    if (checkAllow) {
      CheckAllowResult result = __isFormResetAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockFormResetPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockFormResetPrecheck>.no(
            errCode: BlockFormResetPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockFormResetPrecheck>.no(
            errCode: BlockFormResetPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockFormResetPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockFormSavePrecheck> __canSaveForm({
    required bool checkBusy,
    required bool checkAllow,
    required bool checkValidate,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.busy,
      );
    }
    if (formModel == null) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.noForm,
      );
    }
    if (!formModel!.formInitialDataReady) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.formInitialDataNotReady,
      );
    }
    //
    if (!formModel!.isDirty()) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.formIsNotDirty,
      );
    }
    //
    if (checkValidate) {
      final activeForms = formModel!.ui._visibleFormBuilderStates;
      bool allFormsAreValid = true;

      if (activeForms.isEmpty) {
        allFormsAreValid = true;
      } else {
        for (FormBuilderState formState in activeForms) {
          bool isValid = formState.validate(focusOnInvalid: false);
          allFormsAreValid = allFormsAreValid && isValid;
        }
      }

      if (!allFormsAreValid) {
        return Actionable<BlockFormSavePrecheck>.no(
          errCode: BlockFormSavePrecheck.formInvalidated,
        );
      }
    }
    return Actionable<BlockFormSavePrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemEditPrecheck> __canEditItemOnForm({
    required bool checkBusy,
    required ITEM item,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.busy,
      );
    }
    if (formModel == null) {
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.noForm,
      );
    }
    if (formModel!.dataState.isFatalError) {
      // Test Case: TODO
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.formInErrorState,
      );
    }
    //
    switch (formModel!.formMode) {
      case FormMode.none:
        return Actionable<BlockItemEditPrecheck>.no(
          errCode: BlockItemEditPrecheck.formModeInNone,
        );
      case FormMode.creation:
        break; // Do nothing.
      case FormMode.edit:
        break; // Do nothing.
    }
    //
    if (checkAllow) {
      CheckAllowResult result = _isItemUpdateAllowed(item: item);
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockItemEditPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockItemEditPrecheck>.no(
            errCode: BlockItemEditPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockItemEditPrecheck>.no(
            errCode: BlockItemEditPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockItemEditPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemEditPrecheck> __canEditCurrentItemOnForm({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.busy,
      );
    }
    ITEM? curItem = currentItem;
    if (curItem == null) {
      return Actionable.no(errCode: BlockItemEditPrecheck.noTarget);
    }
    return __canEditItemOnForm(
      checkBusy: checkBusy,
      item: curItem,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  // @seeAlso: __canRefreshCurrentItem()
  Actionable<BlockSetCurrentItemPrecheck> __canSetItemAsCurrent({
    required ITEM? item,
    required bool checkBusy,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockSetCurrentItemPrecheck>.no(
        errCode: BlockSetCurrentItemPrecheck.busy,
      );
    }
    ITEM? internalItem = item;
    if (item != null) {
      internalItem = findItemSameIdWith(item: item);
    }
    // Test Cases: [03b].
    if (internalItem == null) {
      if (errCodeIfItemIsNull == ErrCodeIfItemIsNull.noTarget) {
        return Actionable<BlockSetCurrentItemPrecheck>.no(
          errCode: BlockSetCurrentItemPrecheck.noTarget,
        );
      } else {
        return Actionable<BlockSetCurrentItemPrecheck>.no(
          errCode: BlockSetCurrentItemPrecheck.invalidTarget,
        );
      }
    }
    //
    return Actionable<BlockSetCurrentItemPrecheck>.yes();
  }

  // ***************************************************************************

  @_PrecheckPrivateMethod()
  // @seeAlso: __canSetItemAsCurrent()
  Actionable<BlockSetCurrentItemPrecheck> __canRefreshCurrentItem({
    required bool checkBusy,
  }) {
    if (currentItem == null) {
      return Actionable<BlockSetCurrentItemPrecheck>.no(
        errCode: BlockSetCurrentItemPrecheck.noTarget,
      );
    }
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockSetCurrentItemPrecheck>.no(
        errCode: BlockSetCurrentItemPrecheck.busy,
      );
    }
    //
    return Actionable<BlockSetCurrentItemPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Edit on edit-mode
  /// Edit on creation-mode
  ///
  @_PrecheckPrivateMethod()
  Actionable<BlockFormEnablementPrecheck> __isEnableFormToModify({
    required bool checkAllow,
  }) {
    if (formModel == null) {
      return Actionable<BlockFormEnablementPrecheck>.no(
        errCode: BlockFormEnablementPrecheck.noForm,
      );
    }
    //
    switch (formModel!.formMode) {
      case FormMode.none:
        return Actionable<BlockFormEnablementPrecheck>.no(
          errCode: BlockFormEnablementPrecheck.formInNoneMode,
        );
      case FormMode.creation:
        if (formModel!.dataState.isFatalError) {
          // Test Cases: [16a].
          if (!formModel!.formInitialDataReady) {
            return Actionable<BlockFormEnablementPrecheck>.no(
              errCode: BlockFormEnablementPrecheck.formInitialDataNotReady,
            );
          }
        }
        return Actionable<BlockFormEnablementPrecheck>.yes();
      case FormMode.edit:
        if (formModel!.dataState.isFatalError) {
          // Test Cases: [16b].
          if (!formModel!.formInitialDataReady) {
            return Actionable<BlockFormEnablementPrecheck>.no(
              errCode: BlockFormEnablementPrecheck.formInitialDataNotReady,
            );
          }
        }
        if (checkAllow) {
          CheckAllowResult result = _isItemUpdateAllowed(item: currentItem!);
          switch (result.result) {
            case CheckAllow.allow:
              return Actionable<BlockFormEnablementPrecheck>.yes();
            case CheckAllow.notAllow:
              return Actionable<BlockFormEnablementPrecheck>.no(
                errCode: BlockFormEnablementPrecheck.notAllow,
              );
            case CheckAllow.error:
              return Actionable<BlockFormEnablementPrecheck>.no(
                errCode: BlockFormEnablementPrecheck.checkAllowMethodError,
                errorInfo: result.errorInfo,
              );
          }
        }
        return Actionable<BlockFormEnablementPrecheck>.yes();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockItemDeletionPrecheck> canDeleteCurrentItem({
    bool checkAllow = true,
  }) {
    return __canDeleteCurrentItem(
      checkBusy: true,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockQueryPrecheck> canQuery({
    bool checkAllow = true,
  }) {
    return __canQuery(checkBusy: true, checkAllow: checkAllow);
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockItemDeletionPrecheck> canDeleteItem({
    required ITEM item,
    bool errorIfItemNotInTheBlock = true,
    bool checkAllow = true,
  }) {
    return __canDeleteItem(
      checkBusy: true,
      checkAllow: checkAllow,
      item: item,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
      errorIfItemNotInTheBlock: errorIfItemNotInTheBlock,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockBackendActionPrecheck> canQuickAction() {
    return __canBackendAction(
      checkBusy: true,
    );
  }

  // ***************************************************************************

  // @_PrecheckMethod()
  // Actionable<BlockItemCreationPrecheck> canCreateItem({
  //   required ItemCreationType creationType,
  //   bool checkAllow = true,
  // }) {
  //   return __canCreateItem(
  //     checkBusy: true,
  //     creationType: creationType,
  //     checkAllow: checkAllow,
  //   );
  // }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockItemCreationPrecheck> canCreateItemWithForm() {
    return __canCreateItem(
      checkBusy: true,
      checkAllow: true,
      creationType: ItemCreationType.form,
    );
  }

  @_PrecheckMethod()
  Actionable<BlockSetCurrentItemPrecheck> canEditCurrentItemWithForm() {
    return __canRefreshCurrentItem(
      checkBusy: true,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockQuickItemCreationPrecheck> canQuickCreateItem({
    bool checkAllow = true,
  }) {
    return __canQuickCreateItem(
      checkBusy: true,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockClearItemsPrecheck> canClearBlock() {
    return __canClearItems(
      checkBusy: true,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockItemEditPrecheck> canUpdateItem({
    required ITEM item,
    required ItemUpdateType updateType,
    bool checkAllow = true,
  }) {
    return __canUpdateItem(
      checkBusy: true,
      item: item,
      updateType: updateType,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockQuickItemUpdatePrecheck> canQuickUpdateItem({
    required ITEM item,
    bool checkAllow = true,
    bool errorIfItemNotInTheBlock = true,
  }) {
    return __canQuickUpdateItem(
      checkBusy: true,
      item: item,
      checkAllow: checkAllow,
      errorIfItemNotInTheBlock: errorIfItemNotInTheBlock,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockFormResetPrecheck> canResetForm({
    bool checkAllow = true,
  }) {
    return __canResetForm(
      checkBusy: true,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockFormSavePrecheck> canSaveForm({
    bool checkAllow = true,
    bool checkValidate = false,
  }) {
    return __canSaveForm(
      checkBusy: true,
      checkAllow: checkAllow,
      checkValidate: checkValidate,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockItemEditPrecheck> canEditItemOnForm({
    required ITEM item,
    bool checkAllow = true,
  }) {
    return __canEditItemOnForm(
      checkBusy: true,
      item: item,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockItemEditPrecheck> canEditCurrentItemOnForm() {
    return __canEditCurrentItemOnForm(
      checkBusy: true,
      checkAllow: true,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  // @seeAlso: canRefreshCurrentItem()
  Actionable<BlockSetCurrentItemPrecheck> canSetItemAsCurrent({
    required ITEM item,
  }) {
    return __canSetItemAsCurrent(
      checkBusy: true,
      item: item,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
    );
  }

  // ***************************************************************************

  ///
  /// Checks whether the current item can be refreshed.
  ///
  @_PrecheckMethod()
  // @seeAlso: canSetItemAsCurrent()
  Actionable<BlockSetCurrentItemPrecheck> canRefreshCurrentItem() {
    return __canRefreshCurrentItem(
      checkBusy: true,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<ShowFormInfoPrecheck> canShowFormInfo() {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    if (formModel == null) {
      return Actionable<ShowFormInfoPrecheck>.no(
        errCode: ShowFormInfoPrecheck.noForm,
      );
    }
    if (loggedInUser == null) {
      return Actionable<ShowFormInfoPrecheck>.no(
        errCode: ShowFormInfoPrecheck.noLoggedInUser,
      );
    }
    if (!loggedInUser.isSystemUser) {
      return Actionable<ShowFormInfoPrecheck>.no(
        errCode: ShowFormInfoPrecheck.userIsNotSystemUser,
      );
    }
    return Actionable<ShowFormInfoPrecheck>.yes();
  }

  // ***************************************************************************

  ///
  /// Edit on edit-mode
  /// Edit on creation-mode
  ///
  @_PrecheckMethod()
  Actionable<BlockFormEnablementPrecheck> isEnableFormToModify({
    bool checkAllow = true,
  }) {
    return __isEnableFormToModify(
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable<BlockFormEnablementPrecheck> _isEnableFormToModify() {
    return __isEnableFormToModify(checkAllow: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasCurrentItemAndCanEditOnForm() {
    Actionable<BlockItemEditPrecheck> actionable = __canEditCurrentItemOnForm(
      checkBusy: true,
      checkAllow: true,
    );
    return actionable.yes;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasCurrentItemAndCanDelete() {
    if (currentItem == null) {
      return false;
    }
    Actionable<BlockItemDeletionPrecheck> actionable = __canDeleteCurrentItem(
      checkBusy: true,
      checkAllow: true,
    );
    return actionable.yes;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool canShowFilterCriteria() {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    return filterModel != null &&
        loggedInUser != null &&
        loggedInUser.isSystemUser;
  }

  // ***************************************************************************
  // ************* ITEM SELECTION/CHECK METHOD *********************************
  // ***************************************************************************

  void __refreshAllViewsAfterCheckedOrSelected() {
    ui.refreshAllViews(
      withoutFilters: false,
      force: true,
    );
  }

  void clientSideSort({required bool refresh}) {
    _blockData._clientSideSortItems();
    if (refresh) {
      shelf.ui.refreshAllViews();
    }
  }

  // ***************************************************************************
  // ***** BLOCK DATA **********************************************************
  // ***************************************************************************

  Comparable? get parentBlockCurrentItemId {
    return parent?.currentItemId;
  }

  ID? get currentItemId {
    return _blockData.current._id;
  }

  ITEM? get currentItem => _blockData.current._item;

  ITEM_DETAIL? get currentItemDetail => _blockData.current._itemDetail;

  int get currentItemIndex {
    ITEM? ci = currentItem;
    if (ci == null) {
      return -1;
    }
    return items.indexWhere((it) => identical(it, ci));
  }

  // ***************************************************************************
  // ***************************************************************************

  bool get isEmpty => _blockData._items.isEmpty;

  bool get isNotEmpty => _blockData._items.isNotEmpty;

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// return a copied list of checked items.
  ///
  List<ITEM> get checkedItems {
    return List.unmodifiable(_blockData._checkedItems);
  }

  ///
  /// return a copied list of selected items.
  ///
  List<ITEM> get selectedItems {
    return List.unmodifiable(_blockData._selectedItems);
  }

  List<ID> get selectedItemIds {
    return selectedItems.map((item) => item.id).toList();
  }

  List<ID> get checkedItemIds {
    return checkedItems.map((item) => item.id).toList();
  }

  List<int> get selectedItemIndexes {
    final allItems = items;
    final List<ITEM> sItems = selectedItems;
    final List<int> indexes = [];
    for (var item in sItems) {
      int idx = allItems.indexWhere((it) => identical(it, item));
      indexes.add(idx);
    }
    return indexes;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentItem(ITEM item) {
    final ID? currItemId = currentItemId;
    return _getItemIdInternal(item) == currItemId;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentIndex(int index) {
    ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isCurrentItem(item);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isSelectedIndex(int index) {
    ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isSelectedItem(item);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isSelectedItem(ITEM item) {
    return FaItemsUtils.isListContainItem(
      targetList: _blockData._selectedItems,
      item: item,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentAndSelectedItem(ITEM item) {
    bool c = isCurrentItem(item);
    if (c) {
      return isSelectedItem(item);
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentAndCheckedItem(ITEM item) {
    bool c = isCurrentItem(item);
    if (c) {
      return isCheckedItem(item);
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool get isCurrentItemSelected {
    ITEM? c = currentItem;
    if (c == null) {
      return false;
    }
    return isSelectedItem(c);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool get isCurrentItemChecked {
    ITEM? c = currentItem;
    if (c == null) {
      return false;
    }
    return isCheckedItem(c);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setSelectedItem(ITEM item, {required bool selected}) {
    if (selected) {
      FaItemsUtils.insertOrReplaceItemInList(
        item: item,
        targetList: _blockData._selectedItems,
        getItemId: _getItemIdInternal,
      );
    } else {
      FaItemsUtils.removeItemFromList(
        removeItem: item,
        targetList: _blockData._selectedItems,
        getItemId: _getItemIdInternal,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __toggleSelectItem(ITEM item) {
    bool selected = isSelectedItem(item);
    __setSelectedItem(item, selected: !selected);
  }

  // ***************************************************************************
  // ***************************************************************************

  void setSelectedItem(ITEM item, {required bool selected}) {
    __setSelectedItem(item, selected: selected);
    __refreshAllViewsAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void toggleSelectItem(ITEM item) {
    __toggleSelectItem(item);
    __refreshAllViewsAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setSelectedItems({required List<ITEM> items}) {
    FaItemsUtils.insertOrReplaceItemsInList(
      items: items,
      targetList: _blockData._selectedItems,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findItemByIndex(int index) {
    if (index < 0 || index >= _blockData._items.length) {
      return null;
    }
    return _blockData._items[index];
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isSame({
    required ITEM? item1,
    required ITEM? item2,
  }) {
    if (item1 == null && item2 == null) {
      return true;
    }
    if (item1 != null && item2 != null) {
      final ID? id1 = _getItemIdInternal(item1);
      final ID? id2 = _getItemIdInternal(item2);
      return id1 == id2;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? get firstItem {
    return _blockData._items.firstOrNull;
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? get lastItem {
    return _blockData._items.lastOrNull;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Check if the first item is current item.
  ///
  bool get isCurrentItemAtStart {
    ITEM? first = firstItem;
    ITEM? current = currentItem;
    if (first == null || current == null) {
      return false;
    }
    return _getItemIdInternal(first) == _getItemIdInternal(current);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Check if the last item is current item.
  ///
  bool get isCurrentItemAtEnd {
    ITEM? last = lastItem;
    ITEM? current = currentItem;
    if (last == null || current == null) {
      return false;
    }
    return _getItemIdInternal(last) == _getItemIdInternal(current);
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findNextSiblingItem({
    required ITEM item,
  }) {
    return FaItemsUtils.findNextSiblingItemInList(
      item: item,
      targetList: _blockData._items,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findPreviousSiblingItem({
    required ITEM item,
  }) {
    return FaItemsUtils.findPreviousSiblingItemInList(
      item: item,
      targetList: _blockData._items,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findSiblingItem({
    required ITEM item,
  }) {
    return FaItemsUtils.findSiblingItemInList(
      item: item,
      targetList: _blockData._items,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findItemSameIdWith({
    required ITEM item,
  }) {
    ID id = _getItemIdInternal(item);
    return findItemById(id);
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findItemById(ID itemId) {
    return FaItemsUtils.findItemInListById(
      id: itemId,
      targetList: _blockData._items,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// The next item of the current item.
  /// Return null if no current item or the current item is the last item.
  ///
  ITEM? get nextSiblingItem {
    if (currentItem == null) {
      return null;
    }
    return findNextSiblingItem(item: currentItem!);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// The previous item of the current item.
  /// Return null if no current item or the current item is the first item.
  ///
  ITEM? get previousSiblingItem {
    if (currentItem == null) {
      return null;
    }
    return findPreviousSiblingItem(item: currentItem!);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool containsItem(ITEM item) {
    return FaItemsUtils.isListContainItem(
      targetList: _blockData._items,
      item: item,
      getItemId: _getItemIdInternal,
    );
  }

  bool isCheckedItem(ITEM item) {
    return FaItemsUtils.isListContainItem(
      targetList: _blockData._checkedItems,
      item: item,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCheckedIndex(int index) {
    ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isCheckedItem(item);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setCheckedItem(ITEM item, {required bool checked}) {
    if (checked) {
      FaItemsUtils.insertOrReplaceItemInList(
        item: item,
        targetList: _blockData._checkedItems,
        getItemId: _getItemIdInternal,
      );
    } else {
      FaItemsUtils.removeItemFromList(
        removeItem: item,
        targetList: _blockData._checkedItems,
        getItemId: _getItemIdInternal,
      );
    }
  }

  void __toggleCheckItem(ITEM item) {
    bool checked = isCheckedItem(item);
    __setCheckedItem(item, checked: !checked);
  }

  void toggleCheckItem(ITEM item) {
    __toggleCheckItem(item);
    __refreshAllViewsAfterCheckedOrSelected();
  }

  void setCheckedItem(ITEM item, {required bool checked}) {
    __setCheckedItem(item, checked: checked);
    __refreshAllViewsAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setCheckedItems(List<ITEM> items) {
    FaItemsUtils.insertOrReplaceItemsInList(
      items: items,
      targetList: _blockData._checkedItems,
      getItemId: _getItemIdInternal,
    );
  }

  void setCheckedItems(List<ITEM> items) {
    __setCheckedItems(items);
    __refreshAllViewsAfterCheckedOrSelected();
  }

  void checkAllItems() {
    __setCheckedItems(_blockData._items);
    __refreshAllViewsAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void setSelectedItems(List<ITEM> items) {
    __setSelectedItems(items: items);
    __refreshAllViewsAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void uncheckAllItems() {
    _blockData._checkedItems.clear();
    __refreshAllViewsAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __selectAllItems() {
    __setSelectedItems(items: _blockData._items);
  }

  void selectAllItems() {
    __selectAllItems();
    __refreshAllViewsAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void deselectAllItems() {
    _blockData._selectedItems.clear();
    __refreshAllViewsAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool get hasPreviousItem => previousSiblingItem != null;

  // ***************************************************************************
  // ***************************************************************************

  bool get hasNextItem => nextSiblingItem != null;

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  bool __checkBeforeChangeTheItemPositionManually() {
    if (effectiveConfig.clientSideSortStrategy != SortStrategy.manual) {
      showErrorSnackBar(
        message: "Can not change the position",
        errorDetails: [
          "You need to set block.config.clientSideSortStrategy to ${SortStrategy.manual}"
        ],
      );
      return false;
    }
    return true;
  }

  // bool swapItemsByIndexes({required int index1, required int index2}) {
  //   if (!__checkBeforeChangeTheItemPositionManually()) {
  //     return false;
  //   }
  //   if (index1 >= 0 &&
  //       index1 < itemCount &&
  //       index2 >= 0 &&
  //       index2 < itemCount) {
  //     ITEM it1 = __blockData._items[index1];
  //     ITEM it2 = __blockData._items[index2];
  //     //
  //     __blockData._items[index1] = it2;
  //     __blockData._items[index2] = it1;
  //     return true;
  //   }
  //   return false;
  // }

  // ***************************************************************************
  // ***************************************************************************

  bool swapPositions({required ITEM item1, required ITEM item2}) {
    if (!__checkBeforeChangeTheItemPositionManually()) {
      return false;
    }
    bool success = FaItemsUtils.swapPositionsByIds(
      itemId1: _getItemIdInternal(item1),
      itemId2: _getItemIdInternal(item2),
      targetList: _blockData._items,
      getItemId: _getItemIdInternal,
    );
    if (success) {
      ui.refreshAllViews(withoutFilters: true);
    }
    return success;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool moveItemToNewIndexPosition({
    required ITEM item,
    required int newIndexPosition,
  }) {
    if (!__checkBeforeChangeTheItemPositionManually()) {
      return false;
    }
    bool success = FaItemsUtils.moveItemToNewIndexPosition(
      item: item,
      newIndexPosition: newIndexPosition,
      targetList: _blockData._items,
      getItemId: _getItemIdInternal,
    );
    if (success) {
      ui.refreshAllViews(withoutFilters: true);
    }
    return success;
  }

  // ***************************************************************************
  // ***************************************************************************

  _ProcessedQueryResult<ID, ITEM, FILTER_CRITERIA> __processQueryResult({
    required FilterCriteriaSnapshot<FILTER_CRITERIA>?
        usedFilterCriteriaSnapshot,
    required Pageable? usedPageable,
    //
    required List<ITEM>? queriedItemList,
    required PaginationInfo? queriedPaginationInfo,
    required BlockDataState newBlockDataState,
    required ActionResultState queryResultState,
  }) {
    final List<ITEM> queriedItems = queriedItemList ?? [];
    //
    final List<ITEM> validItems = [];
    final List<ITEM> invalidItems = [];
    final List<ITEM> errorItems = [];
    ErrorInfo? errorInfo;
    //
    final Object? parentBlkCurrItemId = parentBlockCurrentItemId;
    if (parentBlkCurrItemId == null) {
      validItems.addAll(queriedItems);
    } else {
      if (effectiveConfig.enforceParentLinkConstraint) {
        for (var item in queriedItems) {
          try {
            Object parentBlkItemId = resolveParentBlockItemId(item: item);
            if (parentBlkItemId == parentBlkCurrItemId) {
              validItems.add(item);
            } else {
              invalidItems.add(item);
            }
          } catch (e, stackTrace) {
            errorInfo ??= _handleError(
              shelf: shelf,
              methodName: "resolveParentBlockItemId",
              error: e,
              stackTrace: stackTrace,
              showSnackBar: true,
              tipDocument: TipDocument.blockResolveParentBlockItemId,
            );
            errorItems.add(item);
          }
        }
      } else {
        validItems.addAll(queriedItems);
      }
    }
    //
    if (errorInfo == null) {
      if (invalidItems.isNotEmpty) {
        _handleWarning(
          shelf: shelf,
          methodName: "resolveParentBlockItemId",
          warningMessage:
              '${queriedItems.length} items were just queried (${getClassNameWithoutGenerics(this)}). '
              '${errorItems.length} items failed during the validation process, '
              'and ${invalidItems.length} items did not match the current item of the parent block.',
          stackTrace: null,
          showSnackBar: true,
          tipDocument: TipDocument.blockResolveParentBlockItemId,
        );
      }
    }
    //
    return _ProcessedQueryResult(
      parentBlockCurrentItemId: parentBlockCurrentItemId,
      usedXFilterCriteria: usedFilterCriteriaSnapshot,
      usedPageable: usedPageable,
      //
      queriedItemList: queriedItemList,
      queriedPaginationInfo: queriedPaginationInfo,
      queryResultState: queryResultState,
      newBlockDataState: newBlockDataState,
      //
      validItems: validItems,
      invalidItems: invalidItems,
      errorItems: errorItems,
      errorInfo: errorInfo,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      ui.refreshControlBars(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshDeletingState({required bool isDeleting}) {
    try {
      __isDeleting = isDeleting;
      ui.refreshControlBars(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void _refreshSavingState({required bool isSaving}) {
    try {
      __isSaving = isSaving;
      ui.refreshControlBars(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshRefreshingCurrentItemState({
    required bool isRefreshingCurrentItem,
  }) {
    try {
      __isRefreshingCurrentItem = isRefreshingCurrentItem;
      ui.refreshControlBars(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshPreparingFormCreationState({
    required bool isPreparingFormCreation,
  }) {
    try {
      __isPreparingFormCreation = isPreparingFormCreation;
      ui.refreshControlBars(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  bool moveItemByIndexPosition({
    required int oldIndexPosition,
    required int newIndexPosition,
  }) {
    if (!__checkBeforeChangeTheItemPositionManually()) {
      return false;
    }
    bool success = FaItemsUtils.moveItemByIndexPosition(
      oldIndexPosition: oldIndexPosition,
      newIndexPosition: newIndexPosition,
      targetList: _blockData._items,
      getItemId: _getItemIdInternal,
    );
    if (success) {
      ui.refreshAllViews(withoutFilters: true);
    }
    return success;
  }

  // ***************************************************************************
  // ***************************************************************************

  BlockItemDeletionResult<ID, ITEM, ITEM_DETAIL>
      _createEmptyItemDeletionResult() {
    return BlockItemDeletionResult<ID, ITEM, ITEM_DETAIL>(candidateItem: null);
  }

  BlockItemsDeletionResult<ID, ITEM, ITEM_DETAIL>
      _createEmptyItemsDeletionResult({
    required List<ITEM> candidateItems,
  }) {
    return BlockItemsDeletionResult<ID, ITEM, ITEM_DETAIL>(
        candidateItems: candidateItems);
  }

  PrepareItemCreationResult _createEmptyItemCreationResult() {
    return PrepareItemCreationResult();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugFilterCriteriaViewerDialog() async {
    BuildContext context = FlutterArtistCore.context;
    //
    await DebugViewerDialog.openDebugFilterCriteriaInspector(
      context: context,
      locationInfo: '',
      filterModel: registeredOrDefaultFilterModel,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  String _debugItemTypeHtml() {
    return "<b>${getItemType()}</b>";
  }

  String _debugItemDetailTypeHtml() {
    return "<b>${getItemDetailType()}</b>";
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugSyncSessionState({
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final bool provideBlockContext = ui.hasBlockContext(
          includeDescendants: true,
        );
        return DebugBlockSyncSessionStateDialog<ID>(
          snapshot: BlockSyncDiagnosticSnapshot<ID>(
            syncSessionState: _blockSyncSessionState,
            blockDataState: dataState,
            effectiveConfig: effectiveConfig,
            itemIds: itemIds,
            parentBlockCurrentItemId: parentBlockCurrentItemId,
            filterCriteria: filterCriteria,
            queryHint: QueryHint.none,
            provideBlockContext: provideBlockContext,
          ),
        );
      },
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugItemSyncSessionState({
    required BuildContext context,
    String title = "Block Item Sync Session State Inspector",
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugBlockItemSyncSessionStateDialog<ID>(
          title: title,
          itemSyncSessionState: _blockItemSyncSessionState,
          block: this,
        );
      },
    );
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXBlock(XBlock thisXBlock) {
    if (thisXBlock.block != this || thisXBlock.name != name) {
      String message = "Error Assert block: ${thisXBlock.block} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
