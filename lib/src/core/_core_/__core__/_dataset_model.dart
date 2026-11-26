part of '../core.dart';

/// Common read-only dataset contract implemented by dataset-oriented models
/// such as [Block] and [LovModel].
///
/// Encapsulates shared dataset identity, lifecycle state, ordered item access,
/// pagination metadata, sorting hooks, filter/criteria inspection, and standard
/// paginated query triggers without coupling consumers to [Block]-specific
/// features (such as `ITEM_DETAIL`, child blocks, or [FormModel]).
abstract interface class DatasetModel<ID extends Comparable,
    ITEM extends Identifiable<ID>> {
  // ***************************************************************************
  // *** IDENTITY & OWNERSHIP **************************************************
  // ***************************************************************************

  /// Unique name of this dataset model within its owning [shelf].
  String get name;

  /// Optional human-readable description of this dataset model.
  String? get description;

  /// Owning [Shelf] managing this dataset model's lifecycle.
  Shelf get shelf;

  // ***************************************************************************
  // *** LIFECYCLE & DIAGNOSTIC STATE ******************************************
  // ***************************************************************************

  /// Current data lifecycle state (e.g., [BlockDataState] or [LovDataState]).
  DataState get dataState;

  /// Whether a query operation is currently in progress.
  bool get isQuerying;

  /// Whether this dataset model or its filter currently holds an error.
  bool get hasError;

  /// Result payload of the most recent query execution, if any.
  PageData<ITEM>? get lastQueryResult;

  /// Outcome state of the most recent query execution, if any.
  ActionResultState? get lastQueryResultState;

  // ***************************************************************************
  // *** ITEM ACCESS ***********************************************************
  // ***************************************************************************

  /// Returns a snapshot list of all loaded items in display order.
  List<ITEM> get items;

  /// Returns the ordered list of IDs for all currently loaded items.
  List<ID> get itemIds;

  /// Total number of items currently held in memory.
  int get itemCount;

  /// Whether no items are currently loaded.
  bool get isEmpty;

  /// Whether at least one item is currently loaded.
  bool get isNotEmpty;

  /// First item in the loaded list, or `null` if empty.
  ITEM? get firstItem;

  /// Last item in the loaded list, or `null` if empty.
  ITEM? get lastItem;

  /// Returns the item at [index], or `null` if out of bounds.
  ITEM? findItemByIndex(int index);

  /// Finds an item matching [itemId] in the current dataset, or `null` if absent.
  ITEM? findItemById(ID itemId);

  /// Finds an item with the same ID as [item] in the current dataset, or `null` if absent.
  ITEM? findItemSameIdWith({required ITEM item});

  /// Returns `true` if an item with the same ID as [item] exists in this dataset.
  bool containsItem(ITEM item);

  /// Compares two nullable items for identity equality by ID.
  bool isSame({required ITEM? item1, required ITEM? item2});

  /// Returns the runtime [Type] of `ID`.
  Type getItemIdType();

  /// Returns the runtime [Type] of `ITEM`.
  Type getItemType();

  // ***************************************************************************
  // *** PAGINATION & QUERY MODE ***********************************************
  // ***************************************************************************

  /// Configured native query mode (full dataset vs. paginated).
  BlockNativeQueryMode get nativeQueryMode;

  /// Current active [Pageable] cursor, if paginated.
  Pageable? get pageable;

  /// Computed [Pageable] for the next page, if applicable.
  Pageable? get nextPageable;

  /// Snapshot of current pagination metadata (current page, total pages, total items).
  PaginationInfo? get paginationInfo;

  // ***************************************************************************
  // *** FILTERING & SORTING ***************************************************
  // ***************************************************************************

  /// Associated [FilterModel], or `null` if no custom filter model is configured.
  FilterModel<FilterPatch, FilterCriteria>? get filterModel;

  /// Last applied [FilterCriteria] snapshot, or `null` if none has been applied.
  FilterCriteria? get filterCriteria;

  /// Client-side [SortModel] used for in-memory sorting, if configured.
  SortModel<ITEM>? get clientSideSortModel;

  /// Server-side [SortModel] used to construct [SortableCriteria], if configured.
  SortModel<ITEM>? get serverSideSortModel;

  /// Triggers client-side sorting on loaded items and optionally refreshes bound views.
  void clientSideSort({required bool refresh});

  // ***************************************************************************
  // *** QUERY OPERATIONS & PERMISSIONS ****************************************
  // ***************************************************************************

  /// Business rule hook determining whether querying this dataset is permitted.
  bool isQueryAllowed();

  /// Executes a query using the active filter criteria (optionally overriding [pageable]).
  Future<void> query({
    Pageable? pageable,
  });

  /// Queries the next page and replaces the visible dataset.
  Future<void> queryNextPage();

  /// Queries the previous page and replaces the visible dataset.
  Future<void> queryPreviousPage();

  /// Queries the next page and appends items to the existing dataset.
  Future<void> queryMore();

  // ***************************************************************************
  // *** DEBUG INSPECTORS ******************************************************
  // ***************************************************************************

  /// Opens the debug inspector for the associated [FilterModel].
  Future<Actionable<ShowFilterModelInspectorPrecheck>>
      showDebugFilterModelInspector({
    bool showErrorSnackBar = true,
  });

  /// Opens the debug inspector for the active [FilterCriteria].
  Future<Actionable<ShowFilterCriteriaInspectorPrecheck>>
      showDebugFilterCriteriaInspector({
    bool showErrorSnackBar = true,
  });
}
