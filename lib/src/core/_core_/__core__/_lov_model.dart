part of '../core.dart';

/// Lightweight, read-only List of Values (LOV) model supporting filtering,
/// sorting, pagination, event-driven invalidation, and configurable single
/// or multi-item selection.
///
/// Unlike [Block], a [LovModel]:
/// - Has no `ITEM_DETAIL`, no [FormModel], and no parent/child hierarchy.
/// - Owns its [FilterModel] directly (not shared with other Blocks or Scalars).
/// - Does not perform CRUD mutations or broadcast domain events.
abstract class LovModel<
        ID extends Comparable,
        ITEM extends Identifiable<ID>,
        FILTER_PATCH extends FilterPatch, // EmptyFilterPatch
        FILTER_CRITERIA extends FilterCriteria // EmptyFilterCriteria
        > extends _Core
    implements DatasetModel<ID, ITEM>, MnemonicScope, ClassDefViewable {
  @override
  Map<String, Type> getGenericsInfoMap() {
    return {
      "ID": ID,
      "ITEM": ITEM,
      "FILTER_PATCH": FILTER_PATCH,
      "FILTER_CRITERIA": FILTER_CRITERIA,
    };
  }

  /// Owner Shelf (either a local feature Shelf or the hidden GlobalLovShelf).
  @override
  late final Shelf shelf;

  Shelf get module => shelf;

  /// Unique LOV name within its owning [shelf].
  @override
  final String name;

  @override
  final String? description;

  String get _shortPathName => "${shelf.name} > $name";

  String get pathInfo => "lov > ${shelf.name} > $name";

  final LovModelConfig config;

  // TODO: Introduce LovEffectiveConfig if default normalization is needed.
  LovSelectionMode get selectionMode => config.selectionMode;

  bool __isQuerying = false;

  @override
  bool get isQuerying => __isQuerying;

  // ***************************************************************************
  // *** DIRECT FILTER & SORT MODELS *******************************************
  // ***************************************************************************

  /// Directly owned FilterModel (not shared with Blocks or Scalars).
  /// Falls back to a default no-op FilterModel if none is provided.
  late final FilterModel<FILTER_PATCH, FILTER_CRITERIA>
      _ownedOrDefaultFilterModel;

  FilterModel<FILTER_PATCH, FILTER_CRITERIA> get ownedOrDefaultFilterModel =>
      _ownedOrDefaultFilterModel;

  /// Returns the custom [FilterModel] declared for this LOV, or `null` if none.
  @override
  FilterModel<FILTER_PATCH, FILTER_CRITERIA>? get filterModel {
    if (_ownedOrDefaultFilterModel is _DefaultFilterModel) {
      return null;
    }
    return _ownedOrDefaultFilterModel;
  }

  late final SortModel<ITEM>? _clientSideSortModel;

  late final SortModel<ITEM>? _serverSideSortModel;

  @override
  SortModel<ITEM>? get clientSideSortModel => _clientSideSortModel;

  @override
  SortModel<ITEM>? get serverSideSortModel => _serverSideSortModel;

  // ***************************************************************************
  // *** DATA STATE & STORAGE **************************************************
  // ***************************************************************************

  final List<ITEM> _items = [];
  final List<ITEM> _selectedItems = [];

  LovDataState _dataState = const LovDataStatePending.initial();

  FilterCriteriaSnapshot<FILTER_CRITERIA>? _filterCriteriaSnapshot;

  PageData<ITEM>? _lastQueryResult;

  ActionResultState? _lastQueryResultState;

  QueryType _lastQueryType = QueryType.realQuery;

  late final Pageable? _initialPageable;
  late Pageable? _pageable;
  PaginationInfo? _paginationInfo = PaginationInfo.empty();

  @override
  LovDataState get dataState => _dataState;

  @override
  PageData<ITEM>? get lastQueryResult => _lastQueryResult;

  @override
  ActionResultState? get lastQueryResultState => _lastQueryResultState;

  @override
  FILTER_CRITERIA? get filterCriteria =>
      _filterCriteriaSnapshot?.criteriaOrNull;

  FilterCriteriaSnapshot<FILTER_CRITERIA>? get debugFilterCriteriaSnapshot =>
      _filterCriteriaSnapshot;

  /// Indicates whether the LOV's FilterPanel has uncommitted draft changes.
  bool get hasUnappliedFilter =>
      filterModel != null &&
      filterModel!.committedFilterCriteria != filterCriteria;

  @override
  bool get hasError => lovErrorInfo != null || filterErrorInfo != null;

  LovModelErrorInfo? get lovErrorInfo {
    return switch (dataState) {
      LovDataStatePending(:final errorInfo?) => errorInfo,
      LovDataStateLoadedStale(:final errorInfo?) => errorInfo,
      _ => null,
    };
  }

  ErrorInfo? get filterErrorInfo => filterModel?.errorInfo;

  late final ui = _LovUiComponents(lovModel: this);

  // TODO: Wire dedicated _LovUiComponents and _LovDebugInfo.
  // late final debug = _LovDebugInfo<ID>(lovModel: this);

  // ***************************************************************************
  // *** CONSTRUCTOR ***********************************************************
  // ***************************************************************************

  LovModel({
    required this.name,
    required this.description,
    LovModelConfig config = const LovModelConfig(),
    FilterModel<FILTER_PATCH, FILTER_CRITERIA>? filterModel,
    SortModelBuilder<ITEM>? sortModelBuilder,
  }) : config = config.copy() {
    _initialPageable = this.config.pageable?.copy();
    _pageable = this.config.pageable?.copy();

    // TODO: Assign default filter model if [filterModel] is null and bind shelf reference.
    if (filterModel != null) {
      _ownedOrDefaultFilterModel = filterModel;
    }

    _serverSideSortModel = sortModelBuilder?.createServerSideSortModel();
    _clientSideSortModel =
        this.config.clientSideSortStrategy != SortStrategy.modelBased
            ? null
            : sortModelBuilder?.createClientSideSortModel();
  }

  // ***************************************************************************

  XLovModel<ID, ITEM> _createXLovModel({required XFilterModel xFilterModel}) {
    return XLovModel<ID, ITEM>._(
      lovModel: this,
      xFilterModel: xFilterModel,
    );
  }

  // ***************************************************************************
  // *** TYPES *****************************************************************
  // ***************************************************************************

  @override
  Type getItemIdType() => ID;

  @override
  Type getItemType() => ITEM;

  Type getFilterPatchType() => FILTER_PATCH;

  Type getFilterCriteriaType() => FILTER_CRITERIA;

  ID _getItemIdInternal(ITEM item) => item.id;

  // ***************************************************************************
  // *** ABSTRACT API CONTRACT *************************************************
  // ***************************************************************************

  /// Executes the remote lookup query for this LOV.
  ///
  /// - [filterCriteria]: Committed criteria from this LOV's [FilterModel].
  /// - [sortableCriteria]: Active server-side sort specification.
  /// - [pageable]: Guaranteed `null` in [BlockNativeQueryMode.fullQuery] and
  ///   non-null in [BlockNativeQueryMode.pageableQuery].
  @AbstractMethodAnnotation()
  Future<ApiResult<PageData<ITEM>?>> performQuery({
    required FILTER_CRITERIA filterCriteria,
    required SortableCriteria sortableCriteria,
    required Pageable? pageable,
  });

  // ***************************************************************************
  // *** EVENT REACTION (READ-ONLY INVALIDATION) *******************************
  // ***************************************************************************

  Set<Type> getDeclaredReactionDataTypes() {
    if (!config.eventReactionEnabled) {
      return {};
    }
    return {ITEM, ...config.reactionDataTypes};
  }

  Set<Type> getResolvedReactionDataTypes() {
    final declaredTypes = getDeclaredReactionDataTypes();
    if (declaredTypes.isEmpty) {
      return {};
    }
    return DataTypeEventUtils.getProjectionsDataTypes(declaredTypes);
  }

  /// Marks loaded LOV data as stale when an external domain mutation affects
  /// any resolved reaction data type.
  void _receiveEvent({
    required ExecutionTrace executionTrace,
    required List<Type> eventDataTypes,
  }) {
    if (eventDataTypes.isEmpty) {
      return;
    }
    final reactionTypes = getResolvedReactionDataTypes();
    if (reactionTypes.isEmpty) {
      return;
    }
    if (!DataTypeEventUtils.hasIntersection(
      reactionTypes,
      eventDataTypes.toSet(),
    )) {
      return;
    }

    if (_dataState is LovDataStateLoadedFresh) {
      _dataState = LovDataStateLoadedStale.event();
    } else if (_dataState is LovDataStateLoadedStale) {
      final currentStale = _dataState as LovDataStateLoadedStale;
      _dataState = LovDataStateLoadedStale.event(
        retainedFailureReason: currentStale.underlyingFailureReason,
      );
    }
  }

  // ***************************************************************************
  // *** QUERY & LIFECYCLE OPERATIONS ******************************************
  // ***************************************************************************

  /// Queries the LOV dataset using the active or patched filter criteria.
  @override
  @nonVirtual
  @_RootMethodAnnotation()
  Future<void> query({
    FILTER_PATCH? filterPatch,
    Pageable? pageable,
    FilterSyncDirective filterSyncDirective = FilterSyncDirective.useCommitted,
  }) async {
    // TODO: Wire LovQueryResult, LovQueryPrecheck, and ExecutionUnit queue.
    throw UnimplementedError("TODO: LovModel.query");
  }

  /// Queries the next page and replaces the current visible items.
  @override
  @_RootMethodAnnotation()
  Future<void> queryNextPage() async {
    // TODO: Wire pagination next-page query.
    throw UnimplementedError("TODO: LovModel.queryNextPage");
  }

  /// Queries the previous page and replaces the current visible items.
  @override
  @_RootMethodAnnotation()
  Future<void> queryPreviousPage() async {
    // TODO: Wire pagination previous-page query.
    throw UnimplementedError("TODO: LovModel.queryPreviousPage");
  }

  /// Queries the next page and appends items to the current list.
  @override
  @_RootMethodAnnotation()
  Future<void> queryMore() async {
    // TODO: Wire pagination append query.
    throw UnimplementedError("TODO: LovModel.queryMore");
  }

  /// Clears all items and transitions the LOV to [LovDataStateLoadedFresh]
  /// without calling [performQuery].
  @nonVirtual
  @_RootMethodAnnotation()
  Future<void> queryEmpty({
    FILTER_PATCH? filterPatch,
    FilterSyncDirective filterSyncDirective = FilterSyncDirective.useCommitted,
  }) async {
    // TODO: Wire LovQueryEmptyPrecheck and ExecutionUnit.
    throw UnimplementedError("TODO: LovModel.queryEmpty");
  }

  /// Clears cached items and resets the LOV back to [LovDataStatePending.initial].
  @_RootMethodAnnotation()
  Future<void> clearItems({bool clearSelection = true}) async {
    _items.clear();
    if (clearSelection) {
      _selectedItems.clear();
    }
    _paginationInfo = PaginationInfo.empty();
    _pageable = _initialPageable?.copy();
    _dataState = const LovDataStatePending.initial();
    _refreshViews();
  }

  // ***************************************************************************
  // *** ITEM ACCESS & PAGINATION GETTERS **************************************
  // ***************************************************************************

  /// Returns a copied list of loaded items.
  @override
  List<ITEM> get items => [..._items];

  @override
  List<ID> get itemIds => _items.map((item) => item.id).toList();

  @override
  int get itemCount => _items.length;

  @override
  bool get isEmpty => _items.isEmpty;

  @override
  bool get isNotEmpty => _items.isNotEmpty;

  @override
  ITEM? get firstItem => _items.firstOrNull;

  @override
  ITEM? get lastItem => _items.lastOrNull;

  @override
  BlockNativeQueryMode get nativeQueryMode => config.nativeQueryMode;

  @override
  Pageable? get pageable => _pageable;

  @override
  Pageable? get nextPageable {
    if (_lastQueryType == QueryType.emptyQuery) {
      return _initialPageable;
    }
    return _pageable?.next();
  }

  @override
  PaginationInfo? get paginationInfo => PaginationInfo.copy(_paginationInfo);

  @override
  ITEM? findItemByIndex(int index) {
    if (index < 0 || index >= _items.length) {
      return null;
    }
    return _items[index];
  }

  @override
  ITEM? findItemById(ID itemId) {
    return FaItemsUtils.findItemInListById(
      id: itemId,
      targetList: _items,
      getItemId: _getItemIdInternal,
    );
  }

  @override
  ITEM? findItemSameIdWith({required ITEM item}) {
    return findItemById(_getItemIdInternal(item));
  }

  @override
  bool containsItem(ITEM item) {
    return FaItemsUtils.isListContainItem(
      targetList: _items,
      item: item,
      getItemId: _getItemIdInternal,
    );
  }

  @override
  bool isSame({required ITEM? item1, required ITEM? item2}) {
    if (item1 == null && item2 == null) {
      return true;
    }
    if (item1 != null && item2 != null) {
      return _getItemIdInternal(item1) == _getItemIdInternal(item2);
    }
    return false;
  }

  // ***************************************************************************
  // *** SELECTION API (SINGLE & MULTI-SELECTION) ******************************
  // ***************************************************************************

  /// Returns an unmodifiable view of currently selected items.
  List<ITEM> get selectedItems => List.unmodifiable(_selectedItems);

  /// Returns IDs of currently selected items.
  List<ID> get selectedItemIds =>
      _selectedItems.map((item) => item.id).toList();

  /// Convenience getter for single-selection mode (returns the first selected item).
  ITEM? get selectedItem => _selectedItems.firstOrNull;

  /// Convenience getter for single-selection mode (returns the first selected item ID).
  ID? get selectedItemId => selectedItem?.id;

  bool get hasSelection => _selectedItems.isNotEmpty;

  int get selectedCount => _selectedItems.length;

  bool isSelectedItem(ITEM item) {
    return FaItemsUtils.isListContainItem(
      targetList: _selectedItems,
      item: item,
      getItemId: _getItemIdInternal,
    );
  }

  bool isSelectedIndex(int index) {
    final ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isSelectedItem(item);
  }

  /// Initializes the selection state before opening the LOV dialog
  /// (e.g., pre-selecting values currently held by a Form field).
  void initSelection(Iterable<ITEM> initialItems) {
    _selectedItems.clear();
    if (initialItems.isEmpty) {
      return;
    }
    if (selectionMode == LovSelectionMode.single) {
      _selectedItems.add(initialItems.first);
    } else {
      FaItemsUtils.insertOrReplaceItemsInList(
        items: initialItems.toList(),
        targetList: _selectedItems,
        getItemId: _getItemIdInternal,
      );
    }
    _refreshViews();
  }

  /// Selects or deselects [item] according to [selectionMode].
  void setSelectedItem(ITEM item, {required bool selected}) {
    if (selected) {
      if (selectionMode == LovSelectionMode.single) {
        _selectedItems
          ..clear()
          ..add(item);
      } else {
        FaItemsUtils.insertOrReplaceItemInList(
          item: item,
          targetList: _selectedItems,
          getItemId: _getItemIdInternal,
        );
      }
    } else {
      FaItemsUtils.removeItemFromList(
        removeItem: item,
        targetList: _selectedItems,
        getItemId: _getItemIdInternal,
      );
    }
    _refreshViews();
  }

  /// Toggles selection of [item] according to [selectionMode].
  void toggleSelectItem(ITEM item) {
    final bool currentlySelected = isSelectedItem(item);
    setSelectedItem(item, selected: !currentlySelected);
  }

  /// Replaces the current selection with [items].
  /// In [LovSelectionMode.single], only the first item (if any) is kept.
  void setSelectedItems(List<ITEM> items) {
    _selectedItems.clear();
    if (items.isNotEmpty) {
      if (selectionMode == LovSelectionMode.single) {
        _selectedItems.add(items.first);
      } else {
        FaItemsUtils.insertOrReplaceItemsInList(
          items: items,
          targetList: _selectedItems,
          getItemId: _getItemIdInternal,
        );
      }
    }
    _refreshViews();
  }

  /// Selects all currently loaded items (no-op in [LovSelectionMode.single]).
  void selectAllItems() {
    if (selectionMode != LovSelectionMode.multiple) {
      return;
    }
    FaItemsUtils.insertOrReplaceItemsInList(
      items: _items,
      targetList: _selectedItems,
      getItemId: _getItemIdInternal,
    );
    _refreshViews();
  }

  /// Clears all selected items.
  void clearSelection() {
    if (_selectedItems.isEmpty) {
      return;
    }
    _selectedItems.clear();
    _refreshViews();
  }

  // ***************************************************************************
  // *** SORTING ***************************************************************
  // ***************************************************************************

  @override
  void clientSideSort({required bool refresh}) {
    if (config.clientSideSortStrategy == SortStrategy.modelBased &&
        _clientSideSortModel != null) {
      _items.sort((a, b) => _clientSideSortModel._compare(a, b));
      if (refresh) {
        _refreshViews();
      }
    }
  }

  // ***************************************************************************
  // *** BUSINESS RULES & PRECHECKS ********************************************
  // ***************************************************************************

  /// Override to restrict querying this LOV based on application business rules.
  @override
  bool isQueryAllowed() => true;

  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult _checkQueryAllowed() {
    try {
      final bool allow = isQueryAllowed();
      return allow ? CheckAllowResult.allowed() : CheckAllowResult.notAllowed();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        errorInfo: ErrorInfo.fromError(error: e, stackTrace: stackTrace),
      );
    }
  }

  // ***************************************************************************
  // *** DIAGNOSTICS & DEBUG INSPECTORS ****************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  Future<void> showLovErrorViewerDialog(BuildContext context) async {
    if (!hasError) {
      return;
    }
    // TODO: Show dedicated LovErrorViewerDialog or reuse ErrorViewerDialog.
    final ErrorInfo? errorInfo = filterErrorInfo;
    if (errorInfo != null) {
      await ErrorViewerDialog.show(
        context: context,
        errorInfo: errorInfo,
      );
    }
  }

  @_PrecheckMethod()
  Actionable<ShowFilterModelInspectorPrecheck>
      checkBeforeShowFilterModelInspector() {
    return ownedOrDefaultFilterModel.checkBeforeShowFilterModelInspector();
  }

  @override
  @_RootMethodAnnotation()
  Future<Actionable<ShowFilterModelInspectorPrecheck>>
      showDebugFilterModelInspector({
    bool showErrorSnackBar = true,
  }) async {
    return await ownedOrDefaultFilterModel.showDebugFilterModelInspector(
      locationInfo: getClassNameWithoutGenerics(this),
      showErrorSnackBar: showErrorSnackBar,
    );
  }

  @_PrecheckMethod()
  Actionable<ShowFilterCriteriaInspectorPrecheck>
      checkBeforeShowFilterCriteriaInspector() {
    return ownedOrDefaultFilterModel.checkBeforeShowFilterCriteriaInspector();
  }

  @override
  @_RootMethodAnnotation()
  Future<Actionable<ShowFilterCriteriaInspectorPrecheck>>
      showDebugFilterCriteriaInspector({
    bool showErrorSnackBar = true,
  }) async {
    return await ownedOrDefaultFilterModel.showDebugFilterCriteriaInspector(
      locationInfo: getClassNameWithoutGenerics(this),
      showErrorSnackBar: showErrorSnackBar,
    );
  }

  // ***************************************************************************
  // *** INTERNAL HELPERS ******************************************************
  // ***************************************************************************

  void _refreshViews() {
    // TODO: Delegate to ui.refreshAllViews() once _LovUiComponents is implemented.
  }
}
