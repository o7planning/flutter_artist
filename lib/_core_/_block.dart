part of '../flutter_artist.dart';

///
/// Block example:
/// ```dart
/// class EmployeeBlock
///       extends Block<int,EmployeeInfo,EmployeeData,
///                      EmptyFilterSnapshot,SuggestedFormData> {
///
/// }
/// ```
/// [ID] is Id Type of Item. For Example: [int].
///
/// [I] is item. For example:
/// ```dart
/// class EmployeeInfo {
///     int id;
///     String name;
///     ...
/// }
/// ```
/// [D]: Item Detail. For example:
/// ```dart
///  class EmployeeData  {
///     int id;
///     String name;
///     String email;
///     String phoneNumber;
/// }
/// ```
/// You need to implement [convertItemDetailToItem] method to convert Item-Detail to Item.
/// ```dart
/// EmployeeInfo convertItemDetailToItem({EmployeeData itemDetail}) {
///    return EmployeeInfo(itemDetail.id, itemDetail.name);
/// }
/// ```
///
abstract class Block<
    ID extends Object,
    I extends Object,
    D extends Object,
    S extends FilterSnapshot,
    SF extends SuggestedFormData> extends DataContainer {
  @Deprecated("Xoa di, khong su dung")
  QueryMode _queryMode = QueryMode.lazy;

  @Deprecated("Xoa di, khong su dung")
  late QueryMode _tempQueryMode = _queryMode;

  QueryMode get queryMode => _queryMode;

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

  final String name;

  String get _shortPathName {
    return "${shelf.name} > $name";
  }

  String get _classDefinition {
    return "${getClassName(this)}$_classParametersDefinition";
  }

  String get _classParametersDefinition {
    return "<${getItemIdTypeAsString()}, ${getItemTypeAsString()}, ${getItemDetailTypeAsString()}, "
        "${getFilterSnapshotTypeAsString()}, ${getSuggestedFormDataTypeAsString()}>";
  }

  final String? description;

  final BlockHiddenBehavior hiddenBehavior;

  ///
  /// DataFilter Name registered in [Shelf.registerStructure()] method.
  ///
  final String? registerDataFilterName;

  ///
  /// This field is not null.
  /// If this block does not declare a DataFilter, it will have the default DataFilter.
  ///
  late final DataFilter<S> _registeredOrDefaultDataFilter;

  ///
  /// Returns a DataFilter declared in the [Shelf.registerStructure()] method.
  /// The return value may be null.
  ///
  DataFilter<S>? get dataFilter {
    if (_registeredOrDefaultDataFilter is _DefaultDataFilter) {
      return null;
    } else {
      return _registeredOrDefaultDataFilter;
    }
  }

  late final Block? parent;

  String? get parentBlockName => parent?.name;

  final BlockForm<ID, I, D, S, SF>? blockForm;

  final List<Block> _childBlocks;

  List<Block> get childBlocks => [..._childBlocks];

  final int? __pageSize;

  final bool fireEvent;

  final List<Type> __listenItemTypes;

  List<Type> get listenItemTypes => [...__listenItemTypes];

  PageableData? get __pageable => __pageSize == null
      ? null
      : PageableData(
          page: 1,
          pageSize: __pageSize,
        );

  late final BlockData<ID, I, D, S, SF> data =
      _InternalBlockData<ID, I, D, S, SF>.empty(
    this,
    __pageable,
  );

  FormMode get formMode => blockForm?.data._formMode ?? FormMode.none;

  DataState get dataState => data._dataState;

  final Map<_WidgetState, bool> _blockFragmentWidgetStateListeners = {};
  final Map<_WidgetState, bool> _controlBarWidgetStateListeners = {};
  final Map<_WidgetState, bool> _paginationWidgetStateListeners = {};

  Block({
    required this.name,
    required this.description,
    int pageSize = 20,
    this.hiddenBehavior = BlockHiddenBehavior.none,
    required String? dataFilterName,
    required this.blockForm,
    required this.fireEvent,
    required List<Type> listenItemTypes,
    required List<Block>? childBlocks,
  })  : registerDataFilterName = dataFilterName,
        __pageSize = pageSize,
        __listenItemTypes = listenItemTypes,
        _childBlocks = childBlocks ?? [] {
    for (Block childBlock in _childBlocks) {
      childBlock.parent = this;
    }
    if (blockForm != null) {
      blockForm!.block = this;
    }
  }

  Type getItemType() {
    return I;
  }

  Type itemDetailType() {
    return D;
  }

  Type getFilterSnapshotType() {
    return S;
  }

  String getItemIdTypeAsString() {
    return ID.toString();
  }

  String getItemTypeAsString() {
    return I.toString();
  }

  String getItemDetailTypeAsString() {
    return D.toString();
  }

  String getFilterSnapshotTypeAsString() {
    return S.toString();
  }

  String getSuggestedFormDataTypeAsString() {
    return SF.toString();
  }

  List<Block> get descendantBlocks {
    List<Block> ret = [];
    for (Block childBlock in _childBlocks) {
      ret.add(childBlock);
      ret.addAll(childBlock.descendantBlocks);
    }
    return ret;
  }

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      this.updateControlBarWidgets();
    } catch (e) {}
  }

  void __refreshDeletingState({required bool isDeleting}) {
    try {
      __isDeleting = isDeleting;
      this.updateControlBarWidgets();
    } catch (e) {}
  }

  void _refreshSavingState({required bool isSaving}) {
    try {
      __isSaving = isSaving;
      this.updateControlBarWidgets();
    } catch (e) {}
  }

  void __refreshRefreshingCurrentItemState({
    required bool isRefreshingCurrentItem,
  }) {
    try {
      __isRefreshingCurrentItem = isRefreshingCurrentItem;
      this.updateControlBarWidgets();
    } catch (e) {}
  }

  void __refreshPreparingFormCreationState({
    required bool isPreparingFormCreation,
  }) {
    try {
      __isPreparingFormCreation = isPreparingFormCreation;
      this.updateControlBarWidgets();
    } catch (e) {}
  }

  // ***************************************************************************
  // ****** UPDATE UI COMPONENTS ***********************************************
  // ***************************************************************************

  void updateAllUIComponents() {
    _registeredOrDefaultDataFilter.updateAllUIComponents();
    //
    updateFragmentWidgets();
    updatePaginationWidgets();
    updateControlBarWidgets();
    //
    blockForm?.updateAllUIComponents();
  }

  void updateFragmentWidgets() {
    Map<_WidgetState, bool> widgetStates = _findMountedWidgetStates(
      activeOnly: false,
      withBlockFragment: true,
      withFilter: false,
      withForm: false,
      withControlBar: false,
      withPagination: false,
    );

    for (_WidgetState state in widgetStates.keys) {
      if (state.mounted) {
        state.refreshState();
      }
    }
  }

  void updateBlockFragmentWidgets() {
    List<_WidgetState> list = _getMountedBlockFragmentWidgetStates();
    for (_WidgetState widgetState in list) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  void updateControlBarWidgets() {
    List<_WidgetState> list = _getMountedControlBarWidgetStates();
    for (_WidgetState widgetState in list) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  void updatePaginationWidgets() {
    List<_WidgetState> list = _getMountedPaginationWidgetStates();
    for (_WidgetState widgetState in list) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  List<_WidgetState> _getMountedBlockFragmentWidgetStates() {
    _removeUnmountedWidgetStates(_blockFragmentWidgetStateListeners);
    List<_WidgetState> ret = [];
    for (_WidgetState widgetState in [
      ..._blockFragmentWidgetStateListeners.keys
    ]) {
      if (widgetState.mounted) {
        ret.add(widgetState);
      }
    }
    return ret;
  }

  List<_WidgetState> _getMountedPaginationWidgetStates() {
    _removeUnmountedWidgetStates(_paginationWidgetStateListeners);
    List<_WidgetState> ret = [];
    for (_WidgetState widgetState in [
      ..._paginationWidgetStateListeners.keys
    ]) {
      if (widgetState.mounted) {
        ret.add(widgetState);
      }
    }
    return ret;
  }

  List<_WidgetState> _getMountedControlBarWidgetStates() {
    _removeUnmountedWidgetStates(_controlBarWidgetStateListeners);
    List<_WidgetState> ret = [];
    for (_WidgetState widgetState in [
      ..._controlBarWidgetStateListeners.keys
    ]) {
      if (widgetState.mounted) {
        ret.add(widgetState);
      }
    }
    return ret;
  }

  void _addPaginationWidgetStateListener({
    required _WidgetState formWidgetState,
    required bool isShowing,
  }) {
    _paginationWidgetStateListeners[formWidgetState] = isShowing;
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
  }

  void _removePaginationWidgetStateListener({
    required _WidgetState formWidgetState,
  }) {
    _paginationWidgetStateListeners.remove(formWidgetState);
    FlutterArtist.storage._checkToRemoveShelf(shelf);
  }

  void _addControlBarWidgetStateListener({
    required _WidgetState formWidgetState,
    required bool isShowing,
  }) {
    _controlBarWidgetStateListeners[formWidgetState] = isShowing;
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
  }

  void _removeControlBarWidgetStateListener({
    required _WidgetState formWidgetState,
  }) {
    _controlBarWidgetStateListeners.remove(formWidgetState);
    FlutterArtist.storage._checkToRemoveShelf(shelf);
  }

  void _addWidgetStateListener({
    required _WidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUiComponent();
    _blockFragmentWidgetStateListeners[widgetState] = isShowing;
    bool activeCURRENT = hasActiveUiComponent();
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      shelf._startNewLazyQueryTransactionIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      _fireBlockHidden();
    }
  }

  void _removeWidgetStateListener({required State widgetState}) {
    bool activeOLD = hasActiveUiComponent();
    _blockFragmentWidgetStateListeners.remove(widgetState);
    bool activeCURRENT = hasActiveUiComponent();
    //
    if (activeOLD && !activeCURRENT) {
      FlutterArtist.storage._checkToRemoveShelf(shelf);
      _fireBlockHidden();
    }
  }

  void _fireBlockHidden() {
    FlutterArtist.codeFlowLogger._addEvent(
      ownerClassInstance: this,
      event: "Block '${getClassName(this)}' just hides all UI Components!",
      isLibCode: true,
    );
    if (hiddenBehavior == BlockHiddenBehavior.clear) {
      Future.delayed(
        const Duration(seconds: 0),
        () {
          this.emptyQuery();
        },
      );
    }
  }

  Map<_WidgetState, bool> _findMountedWidgetStates({
    required bool withPagination,
    required bool withBlockFragment,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool activeOnly,
  }) {
    _removeUnmountedWidgetStates(_blockFragmentWidgetStateListeners);

    Map<_WidgetState, bool> ret = {};
    //
    if (withBlockFragment) {
      Map<_WidgetState, bool> m = {..._blockFragmentWidgetStateListeners};
      for (_WidgetState key in m.keys) {
        if (key.mounted) {
          if (!activeOnly || m[key]!) {
            ret[key] = m[key]!;
          }
        }
      }
    }
    //
    if (withPagination) {
      Map<_WidgetState, bool> m = {..._paginationWidgetStateListeners};
      for (_WidgetState key in m.keys) {
        if (key.mounted) {
          if (!activeOnly || m[key]!) {
            ret[key] = m[key]!;
          }
        }
      }
    }
    //
    if (withFilter) {
      ret.addAll(
        _registeredOrDefaultDataFilter._findMountedWidgetStates(
          activeOnly: activeOnly,
        ),
      );
    }
    //
    if ((withForm || withControlBar) && blockForm != null) {
      ret.addAll(
        blockForm!._findMountedWidgetStates(
          activeOnly: activeOnly,
          withForm: withForm,
          withControlBar: withControlBar,
        ),
      );
    }
    return ret;
  }

  bool hasActiveUiComponent() {
    bool active = hasActiveBlockFragmentWidget(alsoCheckChildren: false);
    if (active) {
      return true;
    }
    active = hasActiveControlBarWidget();
    if (active) {
      return true;
    }
    active = blockForm != null && blockForm!.hasActiveFormWidget();
    return active;
  }

  bool hasActiveBlockFragmentWidget({required bool alsoCheckChildren}) {
    _removeUnmountedWidgetStates(_blockFragmentWidgetStateListeners);

    var map = {..._blockFragmentWidgetStateListeners};
    for (State widgetState in map.keys) {
      if (widgetState.mounted) {
        bool isShowing = map[widgetState] ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    if (alsoCheckChildren) {
      for (Block childBlock in _childBlocks) {
        bool active =
            childBlock.hasActiveBlockFragmentWidget(alsoCheckChildren: true);
        if (active) {
          return true;
        }
      }
    }
    return false;
  }

  bool hasActiveControlBarWidget() {
    _removeUnmountedWidgetStates(_controlBarWidgetStateListeners);

    for (_WidgetState controlBarState in _controlBarWidgetStateListeners.keys) {
      bool visibility =
          _controlBarWidgetStateListeners[controlBarState] ?? false;
      if (visibility && controlBarState.mounted) {
        return true;
      }
    }
    return false;
  }

  bool hasActivePaginationWidget() {
    _removeUnmountedWidgetStates(_paginationWidgetStateListeners);

    for (_WidgetState paginationState in _paginationWidgetStateListeners.keys) {
      bool visibility =
          _paginationWidgetStateListeners[paginationState] ?? false;
      if (visibility && paginationState.mounted) {
        return true;
      }
    }
    return false;
  }

  void _executeRoute({Function()? route}) {
    try {
      if (route != null) {
        print("  ~~~~~~~~~~~~~~~~~~> Go to Route");
        route();
      }
    } catch (e, stackTrace) {
      print(stackTrace);
    }
  }

  /// Empty Query and set block to "Pending State".
  Future<bool> emptyQuery({Function()? route}) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: route,
      ownerClassInstance: this,
      methodName: "emptyQuery",
      parameters: {},
    );
    //
    bool success = await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [
        _BlockOpt(
          queryType: QueryType.emptyQuery,
          block: this,
          pageable: null,
          listBehavior: ListBehavior.replace,
          suggestedSelection: null,
          postQueryBehavior: PostQueryBehavior.selectAvailableItem,
        ),
      ],
      forceQueryBlockFormOpts: [],
    );
    //
    if (success) {
      _executeRoute(route: route);
    }
    return success;
  }

  ///
  ///
  ///
  @nonVirtual
  Future<bool> query({
    ListBehavior listBehavior = ListBehavior.replace,
    S? suggestedFilterSnapshot,
    SuggestedSelection? suggestedSelection,
    PageableData? pageable,
    Function()? route,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: route,
      ownerClassInstance: this,
      methodName: "query",
      parameters: {
        "suggestedFilterSnapshot": suggestedFilterSnapshot,
        "suggestedSelection": suggestedSelection,
        "pageable": pageable,
      },
    );
    //
    bool success = await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: _registeredOrDefaultDataFilter,
        suggestedFilterSnapshot: suggestedFilterSnapshot,
      ),
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [
        _BlockOpt(
          queryType: null,
          block: this,
          pageable: pageable,
          listBehavior: listBehavior,
          suggestedSelection: suggestedSelection,
          postQueryBehavior: PostQueryBehavior.selectAvailableItem,
        ),
      ],
      forceQueryBlockFormOpts: [],
    );
    //
    if (success) {
      _executeRoute(route: route);
    }
    return success;
  }

  ///
  ///
  ///
  @nonVirtual
  Future<bool> queryAndPrepareToEdit({
    S? suggestedFilterSnapshot,
    ListBehavior listBehavior = ListBehavior.replace,
    SuggestedSelection<ID>? suggestedSelection,
    PageableData? pageable,
    Function()? route,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: route,
      ownerClassInstance: this,
      methodName: "queryAndPrepareToEdit",
      parameters: {
        "suggestedFilterSnapshot": suggestedFilterSnapshot,
        "suggestedSelection": suggestedSelection,
        "pageable": pageable,
      },
    );

    print("\n\n${getClassName(this)} ~~~~~~~~~~~~> queryAndPrepareToEdit()");
    //
    bool success = await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: _registeredOrDefaultDataFilter,
        suggestedFilterSnapshot: suggestedFilterSnapshot,
      ),
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [
        _BlockOpt(
          queryType: QueryType.forceQuery,
          block: this,
          pageable: pageable,
          listBehavior: listBehavior,
          suggestedSelection: suggestedSelection,
          postQueryBehavior: PostQueryBehavior.selectAvailableItemToEdit,
        ),
      ],
      forceQueryBlockFormOpts: [],
    );
    //
    print("Success: $success");
    if (success) {
      _executeRoute(route: route);
    }
    return success;
  }

  /// Empty Query and create new record and set block to "Ready State".
  Future<bool> emptyQueryAndCreate({Function()? route}) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: route,
      ownerClassInstance: this,
      methodName: "emptyQueryAndCreate",
      parameters: {},
    );
    //
    bool success = await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [
        _BlockOpt(
          queryType: QueryType.emptyQuery,
          block: this,
          pageable: null,
          listBehavior: ListBehavior.replace,
          suggestedSelection: null,
          postQueryBehavior: PostQueryBehavior.createNewItem,
        ),
      ],
      forceQueryBlockFormOpts: [],
    );
    //
    if (success) {
      _executeRoute(route: route);
    }
    return success;
  }

  // Cascade query:
  // Private method (Only for use in this class)
  Future<bool> __queryThisAndChildren({
    required _XBlock thisXBlock,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    if (!thisXBlock.needQuery) {
      // Query child blocks:
      for (_XBlock childXBlock in thisXBlock.childXBlocks) {
        bool success = await childXBlock.block.__queryThisAndChildren(
          thisXBlock: childXBlock,
        );
        if (!success) {
          return false;
        }
      }
      return true;
    }
    // Force Query this Block:
    final _XDataFilter xDataFilter = thisXBlock.xDataFilter;
    final DataFilter dataFilter = xDataFilter.dataFilter;
    //
    final S filterSnapshot;
    //
    print("\n${getClassName(this)} ~~~~~~~~~~~~> dataFilter: ${xDataFilter}");
    if (!xDataFilter.queried) {
      print(
          "${getClassName(this)} ~~~~~~~~~~~~> execute dataFilter: ${getClassName(xDataFilter.dataFilter)}");

      S? suggestedFilterSnapshot = xDataFilter.suggestedFilterSnapshot as S?;
      print(
          "${getClassName(this)} ~~~~~~~~~~~~> suggestedFilterSnapshot: ${suggestedFilterSnapshot}");
      //
      // May throw _TransactionError:
      //
      _FilterSnapshotWrapper result = await dataFilter.__prepareData(
        suggestedFilterSnapshot: suggestedFilterSnapshot,
      );
      filterSnapshot = result.filterSnapshot as S;
      dataFilter._filterSnapshot = filterSnapshot;
      xDataFilter.queried = true;
    } else {
      filterSnapshot = dataFilter._filterSnapshot! as S;
    }
    print(
        "${getClassName(this)} ~~~~~~~~~~~~> filterSnapshot: ${filterSnapshot}");
    //
    final QueryType queryType = thisXBlock.queryType;
    final ListBehavior listBehavior = thisXBlock.listBehavior;
    final PostQueryBehavior postQueryBehavior = thisXBlock.postQueryBehavior;
    final SuggestedSelection? suggestedSelection =
        thisXBlock.suggestedSelection;
    final PageableData? pageable = thisXBlock.pageable;
    //
    print(
        "${getClassName(this)} ~~~~~~~~~~~~> needQuery: ${thisXBlock.needQuery} - queryType: ${queryType}");
    //
    bool needRealQuery = false;
    ListBehavior forceListBehavior = listBehavior;
    switch (queryType) {
      case QueryType.emptyQuery:
        {
          needRealQuery = false;
          forceListBehavior = ListBehavior.replace;
        }
      case QueryType.forceQuery:
        {
          needRealQuery = true;
        }
      case QueryType.queryIfNeed:
        {
          bool guiActive = hasActiveUiComponent();
          if (guiActive) {
            needRealQuery = true;
          } else {
            needRealQuery = false;
          }
        }
    }
    //
    print(
        "${getClassName(this)} ~~~~~~~~~~~~> needRealQuery: ${needRealQuery}");
    //
    PageData<I>? pageData;
    DataState dataState = DataState.pending;
    //
    PageableData callingPageable;
    if (needRealQuery) {
      callingPageable =
          pageable ?? __pageable ?? const PageableData(page: 1, pageSize: null);
      //
      ApiResult<PageData<I>?> result;
      try {
        FlutterArtist.codeFlowLogger._addMethodCall(
          isLibCode: false,
          route: null,
          ownerClassInstance: this,
          methodName: "callApiQuery",
          parameters: {},
        );
        //
        __refreshQueryingState(isQuerying: true);
        //
        print("${getClassName(this)} ~~~~~~~~~~~~> callApiQuery");
        result = await callApiQuery(
          filterSnapshot: filterSnapshot,
          pageable: callingPageable,
        );
        //
        __refreshQueryingState(isQuerying: false);
      } catch (e, stacktrace) {
        __refreshQueryingState(isQuerying: false);
        //
        _handleError(
          className: getClassName(this),
          methodName: "callApiQuery",
          error: e,
          stackTrace: stacktrace,
          showSnackBar: true,
        );
        //
        return false;
      }
      if (result.errorMessage != null) {
        _handleRestError(
          methodName: "callApiQuery",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        return false;
      }
      pageData = result.data;
      dataState = DataState.ready;

      print(
          "${getClassName(this)} ~~~~~~~~~~~~> callApiQuery/itemCount = ${pageData?.items?.length}");
    }
    // needRealQuery = false
    else {
      forceListBehavior = ListBehavior.replace;
      callingPageable = __pageable ??
          const PageableData(
            page: 1,
            pageSize: null,
          );
      pageData = PageData<I>.empty();
      dataState = DataState.pending;
    }
    //
    Object? currentParentItem = parentItemId;
    data._updateFrom(
      forceListBehavior: forceListBehavior,
      currentParentItemId: currentParentItem,
      filterSnapshot: filterSnapshot,
      pageable: callingPageable,
      pageData: pageData,
      dataState: dataState,
    );
    //
    print(
        "${getClassName(this)} ~~~~~~~~~~~~> postQueryBehavior: ${postQueryBehavior}");
    print(
        "${getClassName(this)} ~~~~~~~~~~~~> suggestedSelection: ${suggestedSelection}");
    //
    if (postQueryBehavior == PostQueryBehavior.selectAvailableItem ||
        postQueryBehavior == PostQueryBehavior.selectAvailableItemToEdit) {
      // OLD Current Item
      I? suggestedCurrentItem = data.currentItem;
      if (suggestedSelection != null &&
          suggestedSelection.itemIdToSetAsCurrent != null) {
        suggestedCurrentItem = data.findItemById(
          suggestedSelection.itemIdToSetAsCurrent!,
        );
      }

      I? itemWithSameId = suggestedCurrentItem == null
          ? null
          : data._findItemSameIdWith(item: suggestedCurrentItem);

      //
      print(
          "${getClassName(this)} ~~~~~~~~~~~~> itemWithSameId: ${itemWithSameId}");

      if (itemWithSameId == null) {
        // Find first Item...
        I? firstItem = data.findFirstItem();
        print("${getClassName(this)} ~~~~~~~~~~~~> firstItem: ${firstItem}");
        if (firstItem != null) {
          bool success = await __prepareToShowOrEdit(
            thisXBlock: thisXBlock,
            item: firstItem,
            justQueried: true,
            forceForm : postQueryBehavior == PostQueryBehavior.selectAvailableItemToEdit,
          );
          if (!success) {
            return false;
          }
        } else {
          bool success = await _switchThisAndChildrenToNoneMode(
            thisXBlock: thisXBlock,
            clearListForThis: false,
            dataState: dataState,
          );
          if (!success) {
            return false;
          }
        }
        //
        return true;
      } else {
        print(
            "${getClassName(this)} ~~~~~~~~~~~~> __prepareToShowOrEdit($itemWithSameId)");
        bool success = await __prepareToShowOrEdit(
          thisXBlock: thisXBlock,
          item: itemWithSameId,
          justQueried: true,
          forceForm:
              postQueryBehavior == PostQueryBehavior.selectAvailableItemToEdit,
        );
        if (!success) {
          return false;
        }
        return true;
      }
    } else if (postQueryBehavior == PostQueryBehavior.createNewItem) {
      data._dataState = DataState.ready;
      // Create New Item
      bool success = await __prepareToCreate(
        thisXBlock: thisXBlock,
        suggestedFormData: null,
      );
      if (!success) {
        return false;
      }
      return true;
    } else {
      throw "TODO $postQueryBehavior";
    }
  }

  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------

  ID? getCurrentItemId() {
    if (data.currentItemDetail == null) {
      return null;
    }
    I item = convertItemDetailToItem(itemDetail: data.currentItemDetail!);
    return getItemId(item);
  }

  I convertItemDetailToItem({required D itemDetail});

  I? __convertItemDetailToItem({required D? itemDetail}) {
    return itemDetail == null
        ? null
        : convertItemDetailToItem(itemDetail: itemDetail);
  }

  ID getItemId(I item);

  Object? get parentItemId {
    if (parent == null) {
      return null;
    } else {
      return parent!.getCurrentItemId();
    }
  }

  @nonVirtual
  Block getRootBlock() {
    if (parent == null) {
      return this;
    }
    return parent!.getRootBlock();
  }

  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================

  void _backupAll() {
    Block rootBlock = getRootBlock();
    rootBlock.__backupThisAndChildren();
  }

  void _restoreAll() {
    Block rootBlock = getRootBlock();
    rootBlock.__restoreThisAndChildren();
    // shelf.updateAllUiComponents();
  }

  void _applyNewStateAll() {
    Block rootBlock = getRootBlock();
    rootBlock.__applyNewStateThisAndChildren();
    rootBlock.__setChildrenForParent();
    // shelf.updateAllUiComponents();
  }

  void __setChildrenForParent() {
    try {
      Object? itemParent = parent?.data.currentItemDetail;
      if (itemParent != null && data.dataState == DataState.ready) {
        setChildrenForParent(
          currentItemOfParentBlock: itemParent,
          items: data.items,
        );
      }
    } catch (e, stackTrace) {
      print(stackTrace);
    }
    for (var childBlock in _childBlocks) {
      childBlock.__setChildrenForParent();
    }
  }

  // @canOverride
  void setChildrenForParent({
    required Object currentItemOfParentBlock,
    required List<I> items,
  }) {
    // Override if need.
  }

  void __backupThisAndChildren() {
    // printFormDebug(
    //     " -------------------------> TEMPORARY!  - ${data._dataState.name.toUpperCase()}");
    this.data._backup();
    for (var childBlock in _childBlocks) {
      childBlock.__backupThisAndChildren();
    }
  }

  void __restoreThisAndChildren() {
    // printFormDebug(
    //     " -------------------------> NORMAL! - ${data._dataState.name.toUpperCase()}");
    this.data._restore();
    this._registeredOrDefaultDataFilter._restore();
    for (var childBlock in _childBlocks) {
      childBlock.__restoreThisAndChildren();
      childBlock._registeredOrDefaultDataFilter._restore();
    }
  }

  void __applyNewStateThisAndChildren() {
    // printFormDebug(
    //     " -------------------------> NORMAL! - ${data._dataState.name.toUpperCase()}");

    this.data._applyNewState();
    this._registeredOrDefaultDataFilter._applyNewState();
    for (var childBlock in _childBlocks) {
      childBlock.__applyNewStateThisAndChildren();
      childBlock._registeredOrDefaultDataFilter._applyNewState();
    }
  }

// =============== @@@@@@@@@@@@@@@@@@ ========================================
// =============== @@@@@@@@@@@@@@@@@@ ========================================
// =============== @@@@@@@@@@@@@@@@@@ ========================================

  void __setCurrentItem({
    required I? item,
    required D? itemDetail,
  }) {
    data._setCurrentItem(
      refreshedItemDetail: itemDetail,
      refreshedItem: item,
    );
  }

  ///
  /// Remove this item from Interface because it no longer exists on the server
  ///
  void __removeItemFromList({required I removeItem}) {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "__removeItemFromList",
      parameters: {
        "removeItem": removeItem,
      },
    );
    //
    data._removeItem(
      removeItem: removeItem,
    );
  }

  // Private Method. Only for use in this class.
  Future<bool> __removeNotFoundItemAndRefreshChildren({
    required _XBlock thisXBlock,
    SuggestedSelection? suggestedSelection,
    required I notFoundItem,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "__removeNotFoundItemAndRefreshChildren",
      parameters: {
        "suggestedSelection": suggestedSelection,
        "notFoundItem": notFoundItem,
      },
    );
    //
    final bool isCurrent = data.isCurrentItem(
      item: notFoundItem,
    );
    final I? siblingItem = data._findSiblingItem(
      item: notFoundItem,
    );
    //
    __removeItemFromList(removeItem: notFoundItem);
    //
    if (isCurrent) {
      if (siblingItem != null) {
        FlutterArtist.codeFlowLogger._addInfo(
          isLibCode: true,
          ownerClassInstance: this,
          info: "Selecting sibling item",
        );
        //
        bool success = await __prepareToShowOrEdit(
          thisXBlock: thisXBlock,
          justQueried: false,
          item: siblingItem,
          // suggestedSelection: suggestedSelection,
          forceForm: false,
        );
        if (!success) {
          return false;
        }
      } else {
        FlutterArtist.codeFlowLogger._addInfo(
          isLibCode: true,
          ownerClassInstance: this,
          info: "Switching block to none-mode",
        );
        //
        bool success = await _switchThisAndChildrenToNoneMode(
          thisXBlock: thisXBlock,
          clearListForThis: false,
          dataState: DataState.ready,
        );
        if (!success) {
          return false;
        }
      }
    }
    return true;
  }

  Future<bool> __insertOrReplaceItemInListAndRefreshChildren({
    required _XBlock thisXBlock,
    // required SuggestedSelection? suggestedSelection,
    required D refreshedItemDetail,
    required bool forceForm,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "__insertOrReplaceItemInListAndRefreshChildren",
      parameters: {
        // "suggestedSelection": suggestedSelection,
        "refreshedItemDetail": refreshedItemDetail,
        "forceForm": forceForm,
      },
    );
    //
    I refreshedItem = convertItemDetailToItem(itemDetail: refreshedItemDetail);
    data._insertOrReplaceItem(
      item: refreshedItem,
      itemDetail: refreshedItemDetail,
    );
    //
    bool editable = _isAllowEdit(refreshedItem: refreshedItemDetail);
    //
    FlutterArtist.codeFlowLogger._addInfo(
      ownerClassInstance: this,
      info: 'Allow Edit? $editable',
      isLibCode: true,
    );
    //
    this.__setCurrentItem(
      itemDetail: refreshedItemDetail,
      item: refreshedItem,
    );
    //
    if (blockForm != null) {
      blockForm!.data._setCurrentItem(
        refreshedItemDetail: refreshedItemDetail,
        formMode: FormMode.edit,
        dataState: DataState.pending,
      );
      bool success = await blockForm!._prepareForm(
        suggestedFormData: null,
        refreshedItem: refreshedItemDetail,
        isNew: false,
        forceForm: forceForm,
      );
      if (!success) {
        return false;
      }
    }
    //
    for (_XBlock childXBlock in thisXBlock.childXBlocks) {
      SuggestedSelection? childSelectionDirective = childXBlock
          .suggestedSelection
          ?.findChildDirective(childXBlock.block.name);
      childXBlock.suggestedSelection = childSelectionDirective;
      //
      bool success = await childXBlock.block.__queryThisAndChildren(
        thisXBlock: childXBlock,
      );
      if (!success) {
        return false;
      }
    }
    //
    return true;
  }

  Future<bool> _switchThisAndChildrenToNoneMode({
    required _XBlock thisXBlock,
    required bool clearListForThis,
    required DataState dataState,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "_switchThisAndChildrenToNoneMode",
      parameters: {
        "clearListForThis": clearListForThis,
        "dataState": dataState,
      },
    );
    //

    if (clearListForThis) {
      // TODO: Xem lai.
      S? filterSnapshot = data.filterSnapshot;
      //
      PageData<I> emptyAppPage = PageData.empty();
      Object? currentParentItem = parentItemId;

      data._updateFrom(
        currentParentItemId: currentParentItem,
        filterSnapshot: filterSnapshot,
        forceListBehavior: ListBehavior.replace,
        pageable: __pageable,
        pageData: emptyAppPage,
        dataState: dataState,
      );
    }

    const I? nullItem = null;
    const D? nullItemDetail = null;
    __setCurrentItem(
      itemDetail: nullItemDetail,
      item: nullItem,
    );
    //
    if (blockForm != null) {
      blockForm!.data._setCurrentItem(
        refreshedItemDetail: nullItemDetail,
        formMode: FormMode.none,
        dataState: DataState.ready,
      );
      bool success = await blockForm!._prepareForm(
        suggestedFormData: null,
        refreshedItem: nullItemDetail,
        isNew: false,
        forceForm: false,
      );
      if (!success) {
        return false;
      }
    }
    //
    for (_XBlock childXBlock in thisXBlock.childXBlocks) {
      final Block childBlock = childXBlock.block;
      bool success = await childBlock._switchThisAndChildrenToNoneMode(
        thisXBlock: childXBlock,
        clearListForThis: true,
        dataState: dataState,
      );
      if (!success) {
        return false;
      }
    }
    return true;
  }

  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================

  Future<bool> _executeQuickCreateWithOverlayAndRestorable({
    required QuickActionData data,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await _executeQuickCreateWithRestorable(data: data);
      },
    );
  }

  Future<bool> _executeQuickCreateWithRestorable({
    required QuickActionData data,
  }) async {
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: _childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    try {
      shelf.__backupAll();
      //
      bool success = await __executeQuickCreateAction(
        thisXBlock: thisXBlock,
        data: data,
      );
      if (success) {
        shelf.__applyNewStateAll();
      } else {
        shelf.__restoreAll();
      }

      return success;
    } catch (e, stackTrace) {
      // TODO: Xu ly loi.
      shelf.__restoreAll();
      return false;
    }
  }

  // Private Method. Only for use in this class.
  Future<bool> __executeQuickCreateAction({
    required _XBlock thisXBlock,
    required QuickActionData data,
  }) async {
    ApiResult<D> result;
    try {
      result = await callApiQuickCreate(data: data);
      FlutterArtist.storage.fireSourceChanged(
        eventBlock: this,
        itemIdString: null,
      );
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: 'callApiQuickCreate',
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      return false;
    }
    //
    try {
      return await _processSaveActionRestResult(
        thisXBlock: thisXBlock,
        // suggestedSelection: null,
        calledMethodName: "callApiQuickCreate",
        result: result,
      );
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: "_processSaveActionRestResult",
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }

  Future<bool> _executeQuickUpdateWithOverlayAndRestorable({
    required I item,
    required QuickActionData data,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await __executeQuickUpdateActionWithRestorable(
          item: item,
          data: data,
        );
      },
    );
  }

  Future<bool> __executeQuickUpdateActionWithRestorable({
    required I item,
    required QuickActionData data,
  }) async {
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: _childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    try {
      shelf.__backupAll();
      bool success = await __executeQuickUpdateAction(
        thisXBlock: thisXBlock,
        item: item,
        data: data,
      );
      if (success) {
        shelf.__applyNewStateAll();
      } else {
        shelf.__restoreAll();
      }
      return success;
    } catch (e, stackTrace) {
      // TODO: Xu ly loi
      shelf.__restoreAll();
      //
      return false;
    }
  }

  Future<bool> __executeQuickUpdateAction({
    required _XBlock thisXBlock,
    required I item,
    required QuickActionData data,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    ApiResult<D> result;
    try {
      result = await callApiQuickUpdate(item: item, data: data);
      FlutterArtist.storage.fireSourceChanged(
        eventBlock: this,
        itemIdString: null,
      );
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: 'callApiQuickUpdate',
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      return false;
    }
    //
    try {
      return await _processSaveActionRestResult(
        thisXBlock: thisXBlock,
        // suggestedSelection: null,
        calledMethodName: "callApiQuickUpdate",
        result: result,
      );
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: '_processSaveActionRestResult',
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }

  Future<bool> _executeQuickActionWithOverlayAndRestorable({
    required S? suggestedFilterSnapshot,
    required SuggestedSelection? suggestedSelection,
    required QuickActionData action,
    required AfterQuickAction? afterQuickAction,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        bool success = await __executeQuickActionWithRestorable(
          suggestedFilterSnapshot: suggestedFilterSnapshot,
          suggestedSelection: suggestedSelection,
          data: action,
          afterQuickAction: afterQuickAction,
        );
        if (success) {
          try {
            BuildContext context = FlutterArtist.adapter.getCurrentContext();
            action.executeRoute(context);
          } catch (e, stackTrace) {
            print("Error: $e");
            print(stackTrace);
          }
        }
        return success;
      },
    );
  }

  Future<bool> __executeQuickActionWithRestorable({
    required S? suggestedFilterSnapshot,
    required SuggestedSelection? suggestedSelection,
    required QuickActionData data,
    required AfterQuickAction? afterQuickAction,
  }) async {
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: _registeredOrDefaultDataFilter,
        suggestedFilterSnapshot: suggestedFilterSnapshot,
      ),
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: _childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
      forceQueryBlockFormOpts: [],
    );
    //
    try {
      shelf.__backupAll();
      //
      _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
      //
      bool success = await __executeQuickAction(
        thisXBlock: thisXBlock,
        // suggestedFilterSnapshot: suggestedFilterSnapshot,
        // suggestedSelection: suggestedSelection,
        data: data,
        afterQuickAction: afterQuickAction,
      );
      if (!success) {
        shelf.__restoreAll();
      } else {
        shelf.__applyNewStateAll();
      }
      return success;
    } catch (e, stackTrace) {
      // TODO: Xu ly loi.
      shelf.__restoreAll();
      return false;
    }
  }

  Future<bool> __executeQuickAction({
    required _XBlock thisXBlock,
    // required S? suggestedFilterSnapshot,
    // required SuggestedSelection? suggestedSelection,
    required QuickActionData data,
    required AfterQuickAction? afterQuickAction,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    ApiResult<void> result;
    try {
      result = await callApiQuickAction(data: data);
      if (result.errorMessage != null) {
        _handleRestError(
          methodName: "callApiQuickAction",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        return false;
      } else {
        // Do nothing.
      }
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: 'callApiQuickAction',
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      return false;
    }
    if (afterQuickAction != null) {
      String methodName = "";
      try {
        bool success = false;
        switch (afterQuickAction) {
          case AfterQuickAction.refreshCurrentItem:
            methodName = "refreshCurrentItem";
            if (!canRefresh()) {
              return true;
            }
            success = await __prepareToShowOrEdit(
              thisXBlock: thisXBlock,
              item: this.data.currentItem!,
              justQueried: false,
              // suggestedSelection: suggestedSelection,
              forceForm: false,
            );
          case AfterQuickAction.query:
            methodName = "query";
            thisXBlock.needQuery = true;
            //
            success = await __queryThisAndChildren(
              thisXBlock: thisXBlock,
            );
        }
        return success;
      } catch (e, stacktrace) {
        _handleError(
          className: getClassName(this),
          methodName: methodName,
          error: e,
          stackTrace: stacktrace,
          showSnackBar: true,
        );
        return false;
      }
    }
    return true;
  }

  bool hasCurrentItem() {
    return data.currentItemDetail != null;
  }

  bool hasCurrentItemAndAllowEdit() {
    return data.currentItemDetail != null &&
        _isAllowEdit(
          refreshedItem: data.currentItemDetail!,
        );
  }

  bool hasCurrentItemAndAllowDelete() {
    return data.currentItemDetail != null &&
        _isAllowDelete(
          refreshedItem: data.currentItemDetail!,
        );
  }

  ///
  /// Allows creating a new Item or not according to the application logic.
  ///
  bool isAllowCreate() {
    return true;
  }

  ///
  /// Allows edit an Item or not according to the application logic.
  ///
  bool isAllowEdit({required D refreshedItem}) {
    return true;
  }

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  bool isAllowDelete({required D refreshedItem}) {
    return true;
  }

  ///
  /// Allows edit current item or not according to the application logic.
  ///
  bool _isAllowEditCurrentItem() {
    D? currentItem = data.currentItemDetail;
    if (currentItem == null) {
      return false;
    }
    return _isAllowEdit(refreshedItem: currentItem);
  }

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  bool _isAllowEdit({required D refreshedItem}) {
    try {
      return isAllowEdit(refreshedItem: refreshedItem);
    } catch (e, stackTrace) {
      _handleError(
        className: getClassName(this),
        methodName: "isAllowEdit",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      return false;
    }
  }

  ///
  /// Allows creating a new Item or not according to the application logic.
  ///
  bool _isAllowCreate() {
    try {
      return isAllowCreate();
    } catch (e, stackTrace) {
      _handleError(
        className: getClassName(this),
        methodName: "isAllowCreate",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      return false;
    }
  }

  // TODO: Xem cac phuong thuc nay dc goi o dau.
  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  bool _isAllowDelete({required D refreshedItem}) {
    try {
      return isAllowDelete(refreshedItem: refreshedItem);
    } catch (e, stackTrace) {
      _handleError(
        className: getClassName(this),
        methodName: "isAllowDelete",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      return false;
    }
  }

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  bool _isAllowDeleteItem({required I item}) {
    final bool isCurrent = data.isCurrentItem(item: item);
    if (!isCurrent) {
      return true;
    } else {
      D? currentItem = data.currentItemDetail;
      if (currentItem == null) {
        return false;
      }
      return _isAllowDelete(refreshedItem: currentItem);
    }
  }

  bool needToKeepItemInList({
    required S? filterSnapshot,
    required D savedItem,
  });

  Future<bool> _processSaveActionRestResult({
    required _XBlock thisXBlock,
    // required SuggestedSelection? suggestedSelection,
    required String calledMethodName,
    required ApiResult<D> result,
  }) async {
    if (result.errorMessage != null) {
      _handleRestError(
        methodName: calledMethodName,
        message: result.errorMessage!,
        errorDetails: result.errorDetails,
        showSnackBar: true,
      );
      return false;
    }
    //
    FlutterArtist.storage.fireSourceChanged(
      eventBlock: this,
      itemIdString: null,
    );
    //
    final D? savedItemDetail = result.data;
    final bool keepInList;
    if (savedItemDetail == null) {
      keepInList = false;
    } else {
      keepInList = needToKeepItemInList(
        filterSnapshot: data.filterSnapshot,
        savedItem: savedItemDetail,
      );
    }
    //
    if (savedItemDetail != null && keepInList) {
      bool success = await __insertOrReplaceItemInListAndRefreshChildren(
        thisXBlock: thisXBlock,
        // suggestedSelection: suggestedSelection,
        refreshedItemDetail: savedItemDetail,
        forceForm: false,
      );
      if (!success) {
        return false;
      }
      return true;
    }
    // savedItem = null or !keepInList
    else {
      I? savedItem = __convertItemDetailToItem(itemDetail: savedItemDetail);
      final I? removeItem = savedItem ?? data.currentItem;

      if (removeItem != null) {
        bool success = await __removeNotFoundItemAndRefreshChildren(
          thisXBlock: thisXBlock,
          notFoundItem: removeItem,
        );
        if (!success) {
          return false;
        }
      }
      return true;
    }
  }

  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================

  ///
  /// This method will call [callApiQuickAction],
  /// so you need to override [callApiQuickAction] method.
  ///
  Future<bool> executeQuickAction({
    S? suggestedFilterSnapshot,
    SuggestedSelection? suggestedSelection,
    required ActionConfirmation? actionConfirmation,
    required QuickActionData action,
    required AfterQuickAction? afterQuickAction,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "executeQuickAction",
      parameters: {
        "suggestedFilterSnapshot": suggestedFilterSnapshot,
        "suggestedSelection": suggestedSelection,
        "action": action,
        "afterQuickAction": afterQuickAction,
      },
    );
    if (actionConfirmation != null) {
      bool confirm = false;
      BuildContext context = FlutterArtist.adapter.getCurrentContext();
      //
      switch (actionConfirmation.type) {
        case ActionConfirmationType.delete:
          confirm = await dialogs.showConfirmDeleteDialog(
            context: context,
            details: actionConfirmation.details ?? "",
          );
        case ActionConfirmationType.custom:
          confirm = await dialogs.showConfirmDialog(
            context: context,
            message: actionConfirmation.message,
            details: actionConfirmation.details ?? "",
          );
      }
      //
      if (!confirm) {
        return false;
      }
    }
    try {
      bool success = await _executeQuickActionWithOverlayAndRestorable(
        suggestedFilterSnapshot: suggestedFilterSnapshot,
        suggestedSelection: suggestedSelection,
        action: action,
        afterQuickAction: afterQuickAction,
      );
      return success;
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: "executeQuickAction",
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      return false;
    } finally {
      shelf.updateAllUIComponents();
    }
  }

  Future<bool> executeQuickCreateAction<A extends QuickActionData>({
    required CustomConfirmation<A>? customConfirmation,
    required A action,
  }) async {
    //
    // Confirmation:
    //
    bool confirm = await __showConfirmDialogForAction(
      customConfirmation: customConfirmation,
      action: action,
    );
    if (!confirm) {
      return false;
    }
    //
    try {
      bool success =
          await _executeQuickCreateWithOverlayAndRestorable(data: action);
      shelf.updateAllUIComponents();
      return success;
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: 'executeQuickCreateAction',
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      shelf.updateAllUIComponents();
      return false;
    }
  }

  Future<bool> __showDefaultConfirmDialogForAction(
    QuickActionData action,
  ) async {
    return await showConfirmDialog(
      message: 'Are you sure you want to perform this action?',
      details: action.actionInfo,
    );
  }

  Future<bool> __showConfirmDialogForAction<A extends QuickActionData>({
    required A action,
    required CustomConfirmation<A>? customConfirmation,
  }) async {
    if (!action.needToConfirm) {
      return true;
    }
    final CustomConfirmation<A> _confirmForAction =
        customConfirmation ?? __showDefaultConfirmDialogForAction;
    //
    try {
      return await _confirmForAction(action);
    } catch (e, stackTrace) {
      _handleError(
        className: getClassName(this),
        methodName: "confirmForAction",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
  }

  ///
  /// This method will call [callApiQuickUpdate] method.
  /// So you need to implement [callApiQuickUpdate] method.
  ///
  Future<bool> executeQuickUpdateAction<A extends QuickActionData>({
    required I item,
    required CustomConfirmation<A>? customConfirmation,
    required A action,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "executeQuickUpdateAction",
      parameters: {
        "item": item,
        "data": action,
      },
    );
    //
    // Confirmation:
    //
    bool confirm = await __showConfirmDialogForAction(
      customConfirmation: customConfirmation,
      action: action,
    );
    if (!confirm) {
      return false;
    }
    //
    try {
      bool success = await _executeQuickUpdateWithOverlayAndRestorable(
        item: item,
        data: action,
      );
      shelf.updateAllUIComponents();
      return success;
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: "quickUpdate",
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      shelf.updateAllUIComponents();
      return false;
    }
  }

  Future<bool> prepareToEdit({
    required I item,
    Function()? route,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: route,
      ownerClassInstance: this,
      methodName: "prepareToEdit",
      parameters: {
        "item": item,
      },
    );
    //
    bool success = await _prepareToShowOrEditWithOverlayAndRestorable(
      item: item,
      justQueried: false,
      suggestedSelection: null,
      forceForm: true,
    );
    if (success) {
      _executeRoute(route: route);
      return true;
    }
    return false;
  }

  Future<bool> prepareToShow({
    required I item,
    Function()? route,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: route,
      ownerClassInstance: this,
      methodName: "prepareToShow",
      parameters: {
        "item": item,
      },
    );
    //
    bool success = await _prepareToShowOrEditWithOverlayAndRestorable(
      item: item,
      justQueried: false,
      suggestedSelection: null,
      forceForm: false,
    );
    if (success) {
      _executeRoute(route: route);
      return true;
    }
    return false;
  }

  Future<bool> _prepareToShowOrEditWithOverlayAndRestorable({
    required SuggestedSelection? suggestedSelection,
    required I item,
    required bool forceForm,
    required bool justQueried,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await _prepareToShowOrEditWithRestorable(
          suggestedSelection: suggestedSelection,
          item: item,
          forceForm: forceForm,
          justQueried: justQueried,
        );
      },
    );
  }

  Future<bool> _prepareToShowOrEditWithRestorable({
    required SuggestedSelection? suggestedSelection,
    required I item,
    required bool forceForm,
    required bool justQueried,
  }) async {
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: _childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    thisXBlock.suggestedSelection = suggestedSelection;
    //
    try {
      shelf.__backupAll();
      //
      _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
      bool success = await __prepareToShowOrEdit(
        thisXBlock: thisXBlock,
        item: item,
        justQueried: justQueried,
        // suggestedSelection: suggestedSelection,
        forceForm: forceForm,
      );

      if (!success) {
        shelf.__restoreAll();
        return false;
      } else {
        shelf.__applyNewStateAll();
        //
        return true;
      }
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: "prepareToEdit",
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      shelf.__restoreAll();
      return false;
    }
  }

  ///
  /// Kiểm tra xem phần tử này có thực sự tồn tại không trước khi hiển thị nó trên giao diện.
  /// Trả về false nếu phần tử này không còn tồn tại trên máy chủ hoặc lỗi.
  ///
  // Private method (Only for use in this class)
  Future<bool> __prepareToShowOrEdit({
    required _XBlock thisXBlock,
    // required SuggestedSelection? suggestedSelection,
    required I item,
    required bool forceForm,
    required bool justQueried,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "__prepareToShowOrEdit",
      parameters: {
        // "suggestedSelection": suggestedSelection,
        "item": item,
        "forceForm": forceForm,
        "justQueried": justQueried,
      },
    );
    //
    D refreshedItem;
    if (item is D && justQueried) {
      refreshedItem = item;
    } else {
      ApiResult<D> result;
      try {
        FlutterArtist.codeFlowLogger._addMethodCall(
          isLibCode: false,
          route: null,
          ownerClassInstance: this,
          methodName: "callApiRefreshItem",
          parameters: {
            "item": item,
          },
        );
        //
        __refreshRefreshingCurrentItemState(isRefreshingCurrentItem: true);
        //
        result = await callApiRefreshItem(item: item);
        //
        __refreshRefreshingCurrentItemState(isRefreshingCurrentItem: false);
      } catch (e, stacktrace) {
        __refreshRefreshingCurrentItemState(isRefreshingCurrentItem: false);
        //
        _handleError(
          className: getClassName(this),
          methodName: "callApiRefreshItem",
          error: e,
          stackTrace: stacktrace,
          showSnackBar: true,
        );
        //
        return false;
      }
      if (result.errorMessage != null) {
        _handleRestError(
          methodName: "callApiRefreshItem",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        return false;
      } else {
        if (result.data == null) {
          bool success = await __removeNotFoundItemAndRefreshChildren(
            thisXBlock: thisXBlock,
            notFoundItem: item,
          );
          if (!success) {
            return false;
          }
          return true;
        } else {
          refreshedItem = result.data!;
        }
      }
    }
    //
    print("${getClassName(this)} ~~~~~~~~~~~~> refreshedItem: $refreshedItem");
    //
    bool success = await __insertOrReplaceItemInListAndRefreshChildren(
      thisXBlock: thisXBlock,
      // suggestedSelection: suggestedSelection,
      refreshedItemDetail: refreshedItem,
      forceForm: forceForm,
    );
    print("${getClassName(this)} ~~~~~~~~~~~~> success: $success");
    if (!success) {
      return false;
    }
    return true;
  }

  bool __checkBeforeFormCreation({required bool showErrorMessage}) {
    if (blockForm == null) {
      if (showErrorMessage) {
        String msg = "${getClassName(this)} has no BlockForm";
        showErrorSnackBar(message: msg, errorDetails: null);
      }
      return false;
    }
    return true;
  }

  ///
  /// Prepare to create an item in a Form.
  ///
  Future<bool> prepareToCreate({
    SF? suggestedFormData,
    required Function()? route,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: route,
      ownerClassInstance: this,
      methodName: "prepareToCreate",
      parameters: {"suggestedFormData": suggestedFormData},
    );
    //
    if (!__checkBeforeFormCreation(showErrorMessage: true)) {
      return false;
    }
    //
    suggestedFormData?.formAction = FormAction.create;
    //
    bool success = await _prepareToCreateWithOverlayAndRestorable(
      suggestedFormData: suggestedFormData,
    );
    //
    if (success) {
      _executeRoute(route: route);
    }
    return success;
  }

  Future<bool> _prepareToCreateWithOverlayAndRestorable({
    required SF? suggestedFormData,
  }) async {
    if (!__checkBeforeFormCreation(showErrorMessage: false)) {
      return false;
    }
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await _prepareToCreateWithRestorable(
          suggestedFormData: suggestedFormData,
        );
      },
    );
  }

  Future<bool> _prepareToCreateWithRestorable({
    required SF? suggestedFormData,
  }) async {
    if (!__checkBeforeFormCreation(showErrorMessage: false)) {
      return false;
    }
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: _childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    try {
      _backupAll();
      //
      bool success = await __prepareToCreate(
        thisXBlock: thisXBlock,
        suggestedFormData: suggestedFormData,
      );
      if (!success) {
        _restoreAll();
        return false;
      } else {
        _applyNewStateAll();
        return true;
      }
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: "prepareToCreate",
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      _restoreAll();
      return false;
    }
  }

  // Private method. Only for use in this class.
  Future<bool> __prepareToCreate({
    required _XBlock thisXBlock,
    required SF? suggestedFormData,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "__prepareToCreate",
      parameters: {"suggestedFormData": suggestedFormData},
    );
    //
    if (!__checkBeforeFormCreation(showErrorMessage: false)) {
      return false;
    }
    const I? nullItem = null;
    const D? nullItemDetail = null;
    __setCurrentItem(
      itemDetail: nullItemDetail,
      item: nullItem,
    );
    //
    blockForm!.data._setCurrentItem(
      refreshedItemDetail: nullItemDetail,
      formMode: FormMode.creation,
      dataState: DataState.pending,
    );
    //
    bool success = false;
    try {
      __refreshPreparingFormCreationState(isPreparingFormCreation: true);
      //
      success = await blockForm!._prepareForm(
        suggestedFormData: suggestedFormData,
        refreshedItem: nullItemDetail,
        isNew: true,
        forceForm: true,
      );
    } finally {
      __refreshPreparingFormCreationState(isPreparingFormCreation: false);
    }
    if (!success) {
      return false;
    }
    //
    for (_XBlock childXBlock in thisXBlock.childXBlocks) {
      final Block childBlock = childXBlock.block;
      bool success = await childBlock._switchThisAndChildrenToNoneMode(
        thisXBlock: childXBlock,
        clearListForThis: true,
        dataState: DataState.ready,
      );
      if (!success) {
        return false;
      }
    }
    //
    return true;
  }

  Future<bool> deleteCurrentItem() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "deleteCurrentItem",
      parameters: {},
    );
    //

    I? currentItem = data.currentItem;
    if (currentItem != null) {
      return delete(currentItem);
    }
    return false;
  }

  Future<bool> showConfirmDialog(
      {required String message, String? details}) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    bool confirm = await dialogs.showConfirmDialog(
      context: context,
      message: message,
      details: details ?? "",
    );
    return confirm;
  }

  Future<bool> showConfirmDeleteDialog({String? details}) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    bool confirm = await dialogs.showConfirmDeleteDialog(
      context: context,
      details: details ?? "",
    );
    return confirm;
  }

  Future<void> showMessageDialog({
    required String message,
    String? detals,
  }) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await dialogs.showMessageDialog(
      context: context,
      message: message,
      details: detals ?? "",
    );
  }

  Future<bool> deleteItemById({required ID itemId}) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "deleteItemById",
      parameters: {
        "itemId": itemId,
      },
    );
    //
    I? item = data.findItemById(itemId);
    final bool inList = item != null;
    //
    if (item == null) {
      ApiResult<D> result;
      try {
        result = await FlutterArtist.executeTask(
          asyncFunction: () async {
            return await callApiFindItemById(itemId: itemId);
          },
        );
      } catch (e, stackTrace) {
        _handleError(
          className: getClassName(this),
          methodName: "callApiFindItemById",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        //
        return false;
      }
      //
      if (result.isError()) {
        _handleRestError(
          methodName: "callApiFindItemById",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        return false;
      }
      D? itemDetail = result.data;
      if (itemDetail == null) {
        return true;
      }
      try {
        item = this.convertItemDetailToItem(itemDetail: itemDetail);
      } catch (e, stackTrace) {
        _handleError(
          className: getClassName(this),
          methodName: "convertItemDetailToItem",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        //
        return false;
      }
    }
    //
    if (item == null || !canDelete(item: item)) {
      return false;
    }
    bool confirm = await showConfirmDeleteDialog(details: getClassName(item));
    if (!confirm) {
      return false;
    }
    bool success = await _deleteWithOverlayAndRestorable(item);
    return success;
  }

  Future<bool> delete(I item) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "delete",
      parameters: {
        "item": item,
      },
    );
    //
    if (!canDelete(item: item)) {
      return false;
    }
    bool confirm = await showConfirmDeleteDialog(details: getClassName(item));
    if (!confirm) {
      return false;
    }
    bool success = await _deleteWithOverlayAndRestorable(item);
    return success;
  }

  Future<bool> _deleteWithOverlayAndRestorable(I item) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await _deleteWithRestorable(item);
      },
    );
  }

  Future<bool> _deleteWithRestorable(I item) async {
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: _childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    try {
      shelf.__backupAll();
      bool success = await __delete(
        thisXBlock: thisXBlock,
        item: item,
      );

      if (!success) {
        shelf.__restoreAll();
      } else {
        shelf.__applyNewStateAll();
      }
      return success;
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: "delete",
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      //
      shelf.__restoreAll();
      return false;
    }
  }

  // Private method. Only for use in this class only.
  Future<bool> __delete({
    required _XBlock thisXBlock,
    required I item,
  }) async {
    try {
      final bool isCurrent = data.isCurrentItem(item: item);

      if (isCurrent && blockForm?.data._formMode == FormMode.creation) {
        return false;
      }
      if (blockForm?.data._formMode == FormMode.none) {
        // return false;
      }
      ApiResult<void> result;
      try {
        FlutterArtist.codeFlowLogger._addMethodCall(
          isLibCode: false,
          route: null,
          ownerClassInstance: this,
          methodName: "callApiDelete",
          parameters: {
            "item": item,
          },
        );
        //
        __refreshDeletingState(isDeleting: true);
        //
        result = await callApiDelete(item: item);
        FlutterArtist.storage.fireSourceChanged(
          eventBlock: this,
          itemIdString: null,
        );
        //
        __refreshDeletingState(isDeleting: false);
      } catch (e, stacktrace) {
        __refreshDeletingState(isDeleting: false);
        //
        _handleError(
          className: getClassName(this),
          methodName: "callApiDelete",
          error: e,
          stackTrace: stacktrace,
          showSnackBar: true,
        );
        //
        return false;
      }
      if (result.errorMessage != null) {
        _handleRestError(
          methodName: "callApiDelete",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        return false;
      } else {
        if (!isCurrent) {
          __removeItemFromList(removeItem: item);
        } else {
          // Deleted current item ==> find sibling.
          final I? sibling = data._findSiblingItem(item: item);
          // Remove Item
          __removeItemFromList(removeItem: item);

          //
          if (sibling != null) {
            bool success = await __prepareToShowOrEdit(
              thisXBlock: thisXBlock,
              item: sibling,
              justQueried: false,
              // suggestedSelection: null,
              forceForm: false,
            );
            if (!success) {
              return false;
            }
          } else {
            bool success = await _switchThisAndChildrenToNoneMode(
              thisXBlock: thisXBlock,
              clearListForThis: false,
              dataState: DataState.ready,
            );
            if (!success) {
              return false;
            }
          }
        }
      }
      return true;
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: "__delete",
        error: e,
        stackTrace: stacktrace,
        showSnackBar: true,
      );
      return false;
    }
  }

  ///
  /// Phương thức này được gọi để refresh "currentItem".
  ///
  Future<bool> refreshCurrentItem() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "refreshCurrentItem",
      parameters: {},
    );
    //
    if (!canRefresh()) {
      return false;
    }
    bool success = await _prepareToShowOrEditWithOverlayAndRestorable(
      item: data.currentItem!,
      justQueried: false,
      suggestedSelection: null,
      forceForm: false,
    );
    return success;
  }

  ///
  /// This method is called when you can [executeQuickUpdateAction] method.
  ///
  /// ```dart
  /// Future<ApiResult<D>> callApiQuickUpdate({
  ///     required I item,
  ///     required QuickActionData data,
  /// }) {
  ///     if(data is SomeAction1) {
  ///        // Do stuff
  ///     } else if(data is SomeAction2) {
  ///        // Do stuff
  ///     }
  /// }
  /// ```
  ///
  Future<ApiResult<D>> callApiQuickUpdate({
    required I item,
    required QuickActionData data,
  }) async {
    throw UnimplementedError("Override me!");
  }

  ///
  /// This method is called when you can [executeQuickCreateAction] method.
  /// ```dart
  /// Future<ApiResult<D>> callApiQuickCreate({
  ///     required QuickActionData data,
  /// }) {
  ///     if(data is SomeAction1) {
  ///        // Do stuff
  ///     } else if(data is SomeAction2) {
  ///        // Do stuff
  ///     }
  /// }
  /// ```
  ///
  Future<ApiResult<D>> callApiQuickCreate({
    required QuickActionData data,
  }) async {
    throw UnimplementedError("Override me!");
  }

  Future<ApiResult<void>> callApiQuickAction({
    required QuickActionData data,
  }) async {
    throw UnimplementedError("Override me!");
  }

  Future<ApiResult<PageData<I>?>> callApiQuery({
    required S filterSnapshot,
    required PageableData pageable,
  });

  // Developer do not call this method!
  // Call delete instead of
  Future<ApiResult<void>> callApiDelete({required I item});

  Future<ApiResult<D>> callApiRefreshItem({required I item});

  Future<ApiResult<D>> callApiFindItemById({required ID itemId});

  bool canCreate() {
    if (blockForm == null || this.__isPreparingFormCreation) {
      return false;
    }
    if (parent != null && parent!.blockForm != null) {
      if (parent!.formMode == FormMode.none ||
          parent!.formMode == FormMode.creation) {
        return false;
      }
    }
    return _isAllowCreate();
  }

  bool canSave() {
    if (blockForm == null || this.__isSaving) {
      return false;
    }
    if (parent != null) {
      if (parent!.formMode == FormMode.none ||
          parent!.formMode == FormMode.creation) {
        return false;
      }
    }
    return blockForm!.data._formMode != FormMode.none;
  }

  bool canDeleteCurrentItem() {
    I? currentItem = data.currentItem;
    if (currentItem == null) {
      return false;
    }
    return canDelete(item: currentItem);
  }

  bool canDelete({required I item}) {
    if (__isDeleting) {
      return false;
    }
    if (parent != null) {
      if (parent!.blockForm != null) {
        if (parent!.formMode == FormMode.none ||
            parent!.formMode == FormMode.creation ||
            parent!.data.currentItemDetail == null) {
          return false;
        }
      }
    }
    return _isAllowDeleteItem(item: item);
  }

  bool canEditOnForm() {
    if (blockForm == null || __isSaving) {
      return false;
    }
    if (parent != null) {
      if (parent!.blockForm != null) {
        if (parent!.formMode == FormMode.none ||
            parent!.formMode == FormMode.creation ||
            parent!.data.currentItemDetail == null) {
          return false;
        }
      }
    }
    switch (blockForm!.data._formMode) {
      case FormMode.none:
        return false;
      case FormMode.creation:
        return _isAllowCreate();
      case FormMode.edit:
        return _isAllowEditCurrentItem();
    }
  }

  bool canRefresh() {
    if (__isRefreshingCurrentItem) {
      return false;
    }
    if (data.currentItemDetail == null) {
      return false;
    }
    if (blockForm != null) {
      if (blockForm!.data._formMode == FormMode.creation ||
          blockForm!.data._formMode == FormMode.none) {
        return false;
      }
    }
    return true;
  }

  bool canQuery() {
    if (__isQuerying) {
      return false;
    }
    if (parent == null) {
      return true;
    } else {
      if (parent!.data.currentItemDetail == null) {
        return false;
      } else {
        return true;
      }
    }
  }

  void __assertThisXBlock(_XBlock thisXBlock) {
    if (thisXBlock.block != this || thisXBlock.name != name) {
      String message = "Error Assets block: ${thisXBlock.block} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
