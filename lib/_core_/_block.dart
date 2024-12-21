part of '../flutter_artist.dart';

///
/// [I] is item. For example:
/// ```dart
/// class EmployeeInfo {
///     int id;
///     String name;
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
///
abstract class Block<I extends Object, D extends Object,
    S extends FilterSnapshot> with DebugMixin {
  QueryMode _queryMode = QueryMode.lazy;
  late QueryMode _tempQueryMode = _queryMode;

  QueryMode get queryMode => _queryMode;

  bool __isDeleting = false;

  bool get isDeleting => __isDeleting;

  bool __isRefreshingCurrentItem = false;

  bool get isRefreshingCurrentItem => __isRefreshingCurrentItem;

  bool __isPreparingFormCreation = false;

  bool get isPreparingFormCreation => __isPreparingFormCreation;

  bool __isQuerying = false;

  bool get isQuerying => __isQuerying;

  final String name;

  final String? description;

  // final ListBehavior listBehavior;

  final BlockHiddenBehavior hiddenBehavior;

  late final Frame frame;

  final String? blockFilterName;

  late final BlockFilter<S>? blockFilter;

  late final Block? parent;

  String? get parentBlockName => parent?.name;

  final BlockForm<I, D>? blockForm;

  final List<Block> _childBlocks;

  List<Block> get childBlocks => [..._childBlocks];

  final int? __pageSize;

  PageableData? get __pageable => __pageSize == null
      ? null
      : PageableData(
          page: 1,
          pageSize: __pageSize,
        );

  late final BlockData<I, D, S> data = _InternalBlockData<I, D, S>.empty(
    this,
    __pageable,
  );

  FormMode get formMode => blockForm?.data._formMode ?? FormMode.none;

  DataState get dataState => data._dataState;

  final Mailbox mailbox = Mailbox();

  final List<SourceOfChange>? _listenForChangesFrom;

  List<SourceOfChange>? get listenForChangesFrom =>
      _listenForChangesFrom == null ? null : [..._listenForChangesFrom];

  final Map<_WidgetState, bool> _blockFragmentWidgetStateListeners = {};
  final Map<_WidgetState, bool> _controlBarWidgetStateListeners = {};
  final Map<_WidgetState, bool> _paginationWidgetStateListeners = {};

  Block({
    required this.name,
    required this.description,
    int pageSize = 20,
    this.hiddenBehavior = BlockHiddenBehavior.none,
    required this.blockFilterName,
    required this.blockForm,
    required List<Block>? childBlocks,
    required List<SourceOfChange>? listenForChangesFrom,
  })  : __pageSize = pageSize,
        _childBlocks = childBlocks ?? [],
        _listenForChangesFrom = listenForChangesFrom {
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

  String getItemTypeAsString() {
    return I.toString();
  }

  String getItemDetailTypeAsString() {
    return D.toString();
  }

  String getFilterSnapshotTypeAsString() {
    return S.toString();
  }

  List<Block> get descendantBlocks {
    List<Block> ret = [];
    for (Block childBlock in _childBlocks) {
      ret.add(childBlock);
      ret.addAll(childBlock.descendantBlocks);
    }
    return ret;
  }

  bool get isChangeListener {
    return _listenForChangesFrom != null && _listenForChangesFrom.isNotEmpty;
  }

  void updateFragmentWidgets() {
    Map<_WidgetState, bool> widgetStates = _findMountedWidgetStates(
      activeOnly: false,
      withBlockFrament: true,
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
      FlutterArtist._addRecentFrame(frame);
    }
  }

  void _removePaginationWidgetStateListener({
    required _WidgetState formWidgetState,
  }) {
    _paginationWidgetStateListeners.remove(formWidgetState);
    FlutterArtist._checkToRemoveFrame(frame);
  }

  void _addControlBarWidgetStateListener({
    required _WidgetState formWidgetState,
    required bool isShowing,
  }) {
    _controlBarWidgetStateListeners[formWidgetState] = isShowing;
    if (isShowing) {
      FlutterArtist._addRecentFrame(frame);
    }
  }

  void _removeControlBarWidgetStateListener({
    required _WidgetState formWidgetState,
  }) {
    _controlBarWidgetStateListeners.remove(formWidgetState);
    FlutterArtist._checkToRemoveFrame(frame);
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
      FlutterArtist._addRecentFrame(frame);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      frame._startNewLazyQueryTransactionIfNeed();
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
      FlutterArtist._checkToRemoveFrame(frame);
      _fireBlockHidden();
    }
  }

  void _fireBlockHidden() {
    FlutterArtist.codeFlowLogger._addEvent(
      object: this,
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
    required bool withBlockFrament,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool activeOnly,
  }) {
    _removeUnmountedWidgetStates(_blockFragmentWidgetStateListeners);

    Map<_WidgetState, bool> ret = {};
    //
    if (withBlockFrament) {
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
    if (withFilter && blockFilter != null) {
      ret.addAll(blockFilter!._findMountedWidgetStates(activeOnly: activeOnly));
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

  void onInit() {
    //
  }

  void showErrorSnackbar({
    required String message,
    required List<String>? errorDetails,
  }) {
    FlutterArtist.adapter.showErrorSnackbar(
      message: message,
      errorDetails: errorDetails,
    );
  }

  Future<bool> _prepareFilterWithOverlay({
    required SuggestedFilterData? suggestedFilterData,
    required bool force,
  }) async {
    if (blockFilter == null) {
      return true;
    }
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await __prepareFilter(
          suggestedFilterData: suggestedFilterData,
          force: force,
        );
      },
    );
  }

  // Private method. Only for use in this class.
  Future<bool> __prepareFilter({
    required SuggestedFilterData? suggestedFilterData,
    required bool force,
  }) async {
    if (blockFilter == null) {
      return true;
    }
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        object: blockFilter!,
        methodName: "prepareData",
        parameters: {
          "suggestedFilterData": suggestedFilterData,
        },
        route: null,
      );
      //
      await blockFilter!.prepareData(suggestedFilterData: suggestedFilterData);
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(blockFilter),
        methodName: 'prepareData',
        error: e,
        stackTrace: stacktrace,
        showSnackbar: true,
      );
      return false;
    }
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        object: blockFilter!,
        methodName: "takeSnapshot",
        parameters: {},
        route: null,
      );
      //
      S filterSnapshot = blockFilter!.takeSnapshot();
      blockFilter!._currentSnapshot = filterSnapshot;
      return true;
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(blockFilter),
        methodName: 'prepareData',
        error: e,
        stackTrace: stacktrace,
        showSnackbar: true,
      );
      return false;
    }
  }

  void _handleError({
    required String className,
    required String methodName,
    required dynamic error,
    required StackTrace stackTrace,
    required bool showSnackbar,
  }) {
    ApiError apiError;
    if (error is ApiError) {
      apiError = error;
    } else {
      apiError = ApiError(
        errorMessage: error.toString(),
        status: null,
        errorDetails: null,
      );
    }
    String msg =
        "Call $className.$methodName() error: ${apiError.errorMessage}";
    //
    FlutterArtist.codeFlowLogger._addError(
      isLibCode: true,
      object: this,
      error: msg,
    );
    //
    FlutterArtist.errorLogger.addError(
      frameName: FlutterArtist._getFrameName(frame.runtimeType),
      message: msg,
      errorDetails: apiError.errorDetails,
      stackTrace: stackTrace,
    );
    //
    print(msg);
    print(stackTrace);
    if (showSnackbar) {
      showErrorSnackbar(
        message: msg,
        errorDetails: apiError.errorDetails,
      );
    }
  }

  void _handleRestError({
    required String methodName,
    required String message,
    required List<String>? errorDetails,
    required bool showSnackbar,
  }) {
    FlutterArtist.errorLogger.addError(
      frameName: FlutterArtist._getFrameName(frame.runtimeType),
      message: message,
      errorDetails: errorDetails,
      stackTrace: null,
    );
    FlutterArtist.codeFlowLogger._addError(
      object: this,
      error: message,
      isLibCode: true,
    );
    String msg = "Call ${getClassName(this)}.$methodName() error: $message";
    print(msg);
    if (showSnackbar) {
      showErrorSnackbar(
        message: msg,
        errorDetails: errorDetails,
      );
    }
  }

  void _executeRoute({Function()? route}) {
    try {
      if (route != null) {
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
      object: this,
      methodName: "emptyQuery",
      parameters: {},
    );
    //

    bool success = await _queryWithOverlayAndRestorable(
      queryType: QueryType.emptyQuery,
      listBehavior: ListBehavior.replace,
      suggestedFilterData: null,
      postQueryBehavior: PostQueryBehavior.selectAvailableItem,
      suggestedSelection: null,
      pageable: null, // Reset to default pageable.
    );

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
      object: this,
      methodName: "emptyQueryAndCreate",
      parameters: {},
    );
    //

    bool success = await _queryWithOverlayAndRestorable(
      queryType: QueryType.emptyQuery,
      listBehavior: ListBehavior.replace,
      suggestedFilterData: null,
      postQueryBehavior: PostQueryBehavior.createNewItem,
      suggestedSelection: null,
      pageable: null, // Reset to default pageable.
    );

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
    SuggestedFilterData? suggestedFilterData,
    SuggestedSelection? suggestedSelection,
    PageableData? pageable,
    Function()? route,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: route,
      object: this,
      methodName: "query",
      parameters: {
        "suggestedFilterData": suggestedFilterData,
        "suggestedSelection": suggestedSelection,
        "pageable": pageable,
      },
    );
    //
    bool success = false;
    __isQuerying = true;
    this.updateControlBarWidgets();
    try {
      success = await _queryWithOverlayAndRestorable(
        queryType: QueryType.forceQuery,
        listBehavior: listBehavior,
        suggestedFilterData: suggestedFilterData,
        postQueryBehavior: PostQueryBehavior.selectAvailableItem,
        suggestedSelection: suggestedSelection,
        pageable: pageable,
      );
    } finally {
      __isQuerying = false;
      this.updateControlBarWidgets();
    }

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
    SuggestedFilterData? suggestedFilterData,
    ListBehavior listBehavior = ListBehavior.replace,
    SuggestedSelection? suggestedSelection,
    PageableData? pageable,
    Function()? route,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: route,
      object: this,
      methodName: "queryAndPrepareToEdit",
      parameters: {
        "suggestedFilterData": suggestedFilterData,
        "suggestedSelection": suggestedSelection,
        "pageable": pageable,
      },
    );
    //
    bool success = await _queryWithOverlayAndRestorable(
      queryType: QueryType.forceQuery,
      listBehavior: listBehavior,
      suggestedFilterData: suggestedFilterData,
      postQueryBehavior: PostQueryBehavior.selectAvailableItemToEdit,
      suggestedSelection: suggestedSelection,
      pageable: pageable,
    );

    if (success) {
      _executeRoute(route: route);
    }
    return success;
  }

  Future<bool> _queryWithOverlayAndRestorable({
    required QueryType queryType,
    required ListBehavior listBehavior,
    required SuggestedFilterData? suggestedFilterData,
    required PostQueryBehavior postQueryBehavior,
    required SuggestedSelection? suggestedSelection,
    required PageableData? pageable,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return __queryWithRestorable(
          queryType: queryType,
          listBehavior: listBehavior,
          suggestedFilterData: suggestedFilterData,
          postQueryBehavior: postQueryBehavior,
          suggestedSelection: suggestedSelection,
          pageable: pageable,
        );
      },
    );
  }

  // Private method (Only for use in this class)
  Future<bool> __queryWithRestorable({
    required QueryType queryType,
    required ListBehavior listBehavior,
    required SuggestedFilterData? suggestedFilterData,
    required PostQueryBehavior postQueryBehavior,
    required SuggestedSelection? suggestedSelection,
    required PageableData? pageable,
  }) async {
    try {
      _backupAll();
      bool success = await __queryThisAndChildren(
        queryType: queryType,
        listBehavior: listBehavior,
        suggestedFilterData: suggestedFilterData,
        postQueryBehavior: postQueryBehavior,
        suggestedSelection: suggestedSelection,
        pageable: pageable,
      );
      //
      if (!success) {
        _restoreAll();
        return false;
      } else {
        _applyNewStateAll(clearNeedToReQuery: true);
        return true;
      }
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: 'query',
        error: e,
        stackTrace: stacktrace,
        showSnackbar: true,
      );
      //
      _restoreAll();
      return false;
    }
  }

  // Cascade query:
  // Private method (Only for use in this class)
  Future<bool> __queryThisAndChildren({
    required QueryType queryType,
    required ListBehavior listBehavior,
    required SuggestedFilterData? suggestedFilterData,
    required PostQueryBehavior postQueryBehavior,
    required SuggestedSelection? suggestedSelection,
    required PageableData? pageable,
  }) async {
    bool success = await __prepareFilter(
      suggestedFilterData: suggestedFilterData,
      force: true,
    );
    if (!success) {
      return false;
    }
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
          if (guiActive || _tempQueryMode == QueryMode.eager) {
            needRealQuery = true;
          } else {
            needRealQuery = false;
          }
        }
    }
    //
    PageData<I>? pageData;
    DataState dataState = DataState.pending;
    //
    final S filterSnapshot = blockFilter == null
        ? EmptyFilterSnapshot() as S
        : blockFilter!._currentSnapshot!;
    //
    PageableData callingPageable;
    if (needRealQuery) {
      callingPageable =
          pageable ?? __pageable ?? const PageableData(page: 1, pageSize: null);
      ApiResult<PageData<I>?> result;
      try {
        FlutterArtist.codeFlowLogger._addMethodCall(
          isLibCode: false,
          route: null,
          object: this,
          methodName: "callApiQuery",
          parameters: {},
        );
        //
        result = await callApiQuery(
          filterSnapshot: filterSnapshot,
          pageable: callingPageable,
        );
      } catch (e, stacktrace) {
        _handleError(
          className: getClassName(this),
          methodName: "callApiQuery",
          error: e,
          stackTrace: stacktrace,
          showSnackbar: true,
        );
        //
        return false;
      }
      if (result.errorMessage != null) {
        _handleRestError(
          methodName: "callApiQuery",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackbar: true,
        );
        return false;
      }
      pageData = result.data;
      dataState = DataState.ready;
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
    String? currentParentItem = parentItemIdString;
    data._updateFrom(
      forceListBehavior: forceListBehavior,
      currentParentItem: currentParentItem,
      filterSnapshot: filterSnapshot,
      pageable: callingPageable,
      pageData: pageData,
      dataState: dataState,
    );

    if (postQueryBehavior == PostQueryBehavior.selectAvailableItem ||
        postQueryBehavior == PostQueryBehavior.selectAvailableItemToEdit) {
      // OLD Current Item
      I? suggestedCurrentItem = data.currentItem;
      if (suggestedSelection != null &&
          suggestedSelection.itemIdStringToSetAsCurrent != null) {
        suggestedCurrentItem = data.findItemByIdString(
          suggestedSelection.itemIdStringToSetAsCurrent!,
        );
      }

      I? itemWithSameId = suggestedCurrentItem == null
          ? null
          : data._findItemSameIdWith(item: suggestedCurrentItem);

      if (itemWithSameId == null) {
        // Find first Item...
        I? firstItem = data.findFirstItem();
        if (firstItem != null) {
          bool success = await __prepareToShowOrEdit(
            item: firstItem,
            justQueried: true,
            suggestedSelection: suggestedSelection,
            forceForm: false,
          );
          if (!success) {
            return false;
          }
        } else {
          bool success = await _switchThisAndChildrenToNoneMode(
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
        bool success = await __prepareToShowOrEdit(
          item: itemWithSameId,
          justQueried: true,
          suggestedSelection: suggestedSelection,
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
      bool success = await __prepareToCreate();
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

  String? getCurrentItemIdString() {
    if (data.currentItemDetail == null) {
      return null;
    }
    I item = convertItemDetailToItem(itemDetail: data.currentItemDetail!);
    return getItemIdAsString(item);
  }

  I convertItemDetailToItem({required D itemDetail});

  I? __convertItemDetailToItem({required D? itemDetail}) {
    return itemDetail == null
        ? null
        : convertItemDetailToItem(itemDetail: itemDetail);
  }

  String getItemIdAsString(I item);

  String? get parentItemIdString {
    if (parent == null) {
      return null;
    } else {
      return parent!.getCurrentItemIdString();
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
    frame.updateAllWidgets();
  }

  void _applyNewStateAll({bool clearNeedToReQuery = false}) {
    Block rootBlock = getRootBlock();
    rootBlock.__applyNewStateThisAndChildren(
      clearNeedToReQuery: clearNeedToReQuery,
    );
    rootBlock.__setChildrenForParent();
    frame.updateAllWidgets();
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
    printFormDebug(
        " -------------------------> TEMPORARY!  - ${data._dataState.name.toUpperCase()}");
    this.data._backup();
    for (var childBlock in _childBlocks) {
      childBlock.__backupThisAndChildren();
    }
  }

  void __restoreThisAndChildren() {
    printFormDebug(
        " -------------------------> NORMAL! - ${data._dataState.name.toUpperCase()}");
    this.data._restore();
    this.blockFilter?._restore();
    for (var childBlock in _childBlocks) {
      childBlock.__restoreThisAndChildren();
      childBlock.blockFilter?._restore();
    }
  }

  void __applyNewStateThisAndChildren({bool clearNeedToReQuery = false}) {
    printFormDebug(
        " -------------------------> NORMAL! - ${data._dataState.name.toUpperCase()}");

    this.data._applyNewState();
    this.blockFilter?._applyNewState();
    for (var childBlock in _childBlocks) {
      childBlock.__applyNewStateThisAndChildren();
      childBlock.blockFilter?._applyNewState();
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
  /// Loại bỏ phần tử này ra khỏi giao diện vì nó đã không còn tồn tại trên máy chủ.
  ///
  void __removeItemFromList({required I removeItem}) {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      object: this,
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

  ///
  /// Loại bỏ notFoundItem ra khỏi danh sách đồng thời tìm kiếm item anh em để lựa chọn.
  ///
  // Private Method. Only for use in this class.
  Future<bool> __removeNotFoundItemAndRefreshChildren({
    SuggestedSelection? suggestedSelection,
    required I notFoundItem,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      object: this,
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
          object: this,
          info: "Selecting sibling item",
        );
        //
        bool success = await __prepareToShowOrEdit(
          justQueried: false,
          item: siblingItem,
          suggestedSelection: suggestedSelection,
          forceForm: false,
        );
        if (!success) {
          return false;
        }
      } else {
        FlutterArtist.codeFlowLogger._addInfo(
          isLibCode: true,
          object: this,
          info: "Switching block to none-mode",
        );
        //
        bool success = await _switchThisAndChildrenToNoneMode(
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
    required SuggestedSelection? suggestedSelection,
    required D refreshedItemDetail,
    required bool forceForm,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      object: this,
      methodName: "__insertOrReplaceItemInListAndRefreshChildren",
      parameters: {
        "suggestedSelection": suggestedSelection,
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
      object: this,
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
        refreshedItem: refreshedItemDetail,
        isNew: false,
        forceForm: forceForm,
      );
      if (!success) {
        return false;
      }
    }
    //
    for (var childBlock in _childBlocks) {
      SuggestedSelection? childQueryDirective =
          suggestedSelection?.findChildDirective(childBlock.name);
      bool success = await childBlock.__queryThisAndChildren(
        queryType: QueryType.queryIfNeed,
        listBehavior: ListBehavior.replace,
        suggestedFilterData: null,
        postQueryBehavior: PostQueryBehavior.selectAvailableItem,
        suggestedSelection: childQueryDirective,
        pageable: null, // TODO: Null or last pageable?
      );
      if (!success) {
        return false;
      }
    }
    //
    return true;
  }

  Future<bool> _switchThisAndChildrenToNoneMode({
    required bool clearListForThis,
    required DataState dataState,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      object: this,
      methodName: "_switchThisAndChildrenToNoneMode",
      parameters: {
        "clearListForThis": clearListForThis,
        "dataState": dataState,
      },
    );
    //

    if (clearListForThis) {
      // TODO: Xem lai.
      S? filterSnapshot = data.currentFilterSnapshot;
      //
      PageData<I> emptyAppPage = PageData.empty();
      String? currentParentItem = parentItemIdString;

      data._updateFrom(
        currentParentItem: currentParentItem,
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
        refreshedItem: nullItemDetail,
        isNew: false,
        forceForm: false,
      );
      if (!success) {
        return false;
      }
    }
    //
    for (var childBlock in _childBlocks) {
      bool success = await childBlock._switchThisAndChildrenToNoneMode(
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

  Future<bool> _executeQuickCreateWithOverlay({
    required QuickActionData data,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await __executeQuickCreateAction(data: data);
      },
    );
  }

  // Private Method. Only for use in this class.
  Future<bool> __executeQuickCreateAction({
    required QuickActionData data,
  }) async {
    ApiResult<D> result;
    try {
      result = await callApiQuickCreate(data: data);
      FlutterArtist.fireSourceChanged(
        sourceBlock: this,
        itemIdString: null,
      );
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: 'callApiQuickCreate',
        error: e,
        stackTrace: stacktrace,
        showSnackbar: true,
      );
      //
      return false;
    }
    //
    try {
      return await _processSaveActionRestResult(
        suggestedSelection: null,
        calledMethodName: "callApiQuickCreate",
        result: result,
      );
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: "_processSaveActionRestResult",
        error: e,
        stackTrace: stacktrace,
        showSnackbar: true,
      );
      //
      return false;
    }
  }

  Future<bool> _executeQuickUpdateWithOverlay({
    required I item,
    required QuickActionData data,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await __executeQuickUpdateAction(item: item, data: data);
      },
    );
  }

  Future<bool> __executeQuickUpdateAction({
    required I item,
    required QuickActionData data,
  }) async {
    ApiResult<D> result;
    try {
      result = await callApiQuickUpdate(item: item, data: data);
      FlutterArtist.fireSourceChanged(
        sourceBlock: this,
        itemIdString: null,
      );
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: 'callApiQuickUpdate',
        error: e,
        stackTrace: stacktrace,
        showSnackbar: true,
      );
      return false;
    }
    //
    try {
      return await _processSaveActionRestResult(
        suggestedSelection: null,
        calledMethodName: "callApiQuickUpdate",
        result: result,
      );
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: '_processSaveActionRestResult',
        error: e,
        stackTrace: stacktrace,
        showSnackbar: true,
      );
      //
      return false;
    }
  }

  Future<bool> _executeQuickActionWithOverlay({
    required SuggestedFilterData? suggestedFilterData,
    required SuggestedSelection? suggestedSelection,
    required QuickActionData action,
    required AfterQuickAction? afterQuickAction,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        bool success = await __executeQuickAction(
          suggestedFilterData: suggestedFilterData,
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

  Future<bool> __executeQuickAction({
    required SuggestedFilterData? suggestedFilterData,
    required SuggestedSelection? suggestedSelection,
    required QuickActionData data,
    required AfterQuickAction? afterQuickAction,
  }) async {
    ApiResult<void> result;
    try {
      result = await callApiQuickAction(data: data);
      if (result.errorMessage != null) {
        _handleRestError(
          methodName: "callApiQuickAction",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackbar: true,
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
        showSnackbar: true,
      );
      return false;
    }
    if (afterQuickAction != null) {
      String methodName = "";
      try {
        _backupAll();
        bool success = false;
        switch (afterQuickAction) {
          case AfterQuickAction.refreshCurrentItem:
            methodName = "refreshCurrentItem";
            if (!canRefresh()) {
              return true;
            }
            success = await __prepareToShowOrEdit(
              item: this.data.currentItem!,
              justQueried: false,
              suggestedSelection: suggestedSelection,
              forceForm: false,
            );
          case AfterQuickAction.query:
            methodName = "query";
            success = await __queryThisAndChildren(
              queryType: QueryType.forceQuery,
              listBehavior: ListBehavior.replace,
              suggestedFilterData: suggestedFilterData,
              postQueryBehavior: PostQueryBehavior.selectAvailableItem,
              suggestedSelection: suggestedSelection,
              pageable: null, // TODO: Xem lai!
            );
        }
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
          methodName: methodName,
          error: e,
          stackTrace: stacktrace,
          showSnackbar: true,
        );
        //
        _restoreAll();
        return false;
      }
    }
    return true;
  }

  ///
  /// Check if this item is allowed to be edited or not.
  /// If true, the user can edit it on the form. Otherwise the form is read-only.
  ///
  bool isAllowEdit({required D refreshedItem}) {
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
  /// Check if this block is allowed to be created or not.
  /// If true, the user can create it on the form.
  ///
  bool isAllowCreate() {
    return true;
  }

  ///
  /// Check if this block is allowed to be deleted or not.
  ///
  bool isAllowDelete({required D refreshedItem}) {
    return true;
  }

  bool _isAllowEditCurrentItem() {
    D? currentItem = data.currentItemDetail;
    if (currentItem == null) {
      return false;
    }
    return _isAllowEdit(refreshedItem: currentItem);
  }

  bool _isAllowEdit({required D refreshedItem}) {
    try {
      return isAllowEdit(refreshedItem: refreshedItem);
    } catch (e, stackTrace) {
      _handleError(
        className: getClassName(this),
        methodName: "isAllowEdit",
        error: e,
        stackTrace: stackTrace,
        showSnackbar: false,
      );
      return false;
    }
  }

  bool _isAllowCreate() {
    try {
      return isAllowCreate();
    } catch (e, stackTrace) {
      _handleError(
        className: getClassName(this),
        methodName: "isAllowCreate",
        error: e,
        stackTrace: stackTrace,
        showSnackbar: false,
      );
      return false;
    }
  }

  bool _isAllowDelete({required D refreshedItem}) {
    try {
      return isAllowDelete(refreshedItem: refreshedItem);
    } catch (e, stackTrace) {
      _handleError(
        className: getClassName(this),
        methodName: "isAllowDelete",
        error: e,
        stackTrace: stackTrace,
        showSnackbar: false,
      );
      return false;
    }
  }

  bool _isAllowDeleteCurrentItem() {
    D? currentItem = data.currentItemDetail;
    if (currentItem == null) {
      return false;
    }
    return _isAllowDelete(refreshedItem: currentItem);
  }

  bool needToKeepItemInList({
    required S? filterSnapshot,
    required D savedItem,
  });

  Future<bool> _processSaveActionRestResult({
    required SuggestedSelection? suggestedSelection,
    required String calledMethodName,
    required ApiResult<D> result,
  }) async {
    if (result.errorMessage != null) {
      _handleRestError(
        methodName: calledMethodName,
        message: result.errorMessage!,
        errorDetails: result.errorDetails,
        showSnackbar: true,
      );
      return false;
    }
    //
    D? savedItemDetail = result.data;
    bool keepInList;
    if (savedItemDetail == null) {
      keepInList = false;
    } else {
      keepInList = needToKeepItemInList(
        filterSnapshot: data.currentFilterSnapshot,
        savedItem: savedItemDetail,
      );
    }
    //
    if (savedItemDetail != null && keepInList) {
      bool success = await __insertOrReplaceItemInListAndRefreshChildren(
        suggestedSelection: suggestedSelection,
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
    SuggestedFilterData? suggestedFilterData,
    SuggestedSelection? suggestedSelection,
    required ActionConfirmation? actionConfirmation,
    required QuickActionData action,
    required AfterQuickAction? afterQuickAction,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      object: this,
      methodName: "executeQuickAction",
      parameters: {
        "suggestedFilterData": suggestedFilterData,
        "suggestedSelection": suggestedSelection,
        "action": action,
        "afterQuickAction": afterQuickAction,
      },
    );
    if (actionConfirmation != null) {
      bool confirm = false;
      BuildContext context = FlutterArtist.adapter.getCurrentContext();
      if (actionConfirmation.type == ActionConfirmationType.delete) {
        confirm = await _showConfirmDeleteDialog(
          context: context,
          details: actionConfirmation.details ?? "",
        );
      } else if (actionConfirmation.type == ActionConfirmationType.custom) {
        confirm = await _showConfirmDialog(
          context: context,
          message: actionConfirmation.message,
          details: actionConfirmation.details ?? "",
        );
      } else {
        throw "TODO-executeQuickAction";
      }
      if (!confirm) {
        return false;
      }
    }
    try {
      bool success = await _executeQuickActionWithOverlay(
        suggestedFilterData: suggestedFilterData,
        suggestedSelection: suggestedSelection,
        action: action,
        afterQuickAction: afterQuickAction,
      );
      frame.updateAllWidgets();
      return success;
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: "executeQuickAction",
        error: e,
        stackTrace: stacktrace,
        showSnackbar: true,
      );
      //
      frame.updateAllWidgets();
      return false;
    }
  }

  Future<bool> executeQuickCreateAction({
    required QuickActionData data,
  }) async {
    try {
      bool success = await _executeQuickCreateWithOverlay(data: data);
      frame.updateAllWidgets();
      return success;
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: 'executeQuickCreateAction',
        error: e,
        stackTrace: stacktrace,
        showSnackbar: true,
      );
      //
      frame.updateAllWidgets();
      return false;
    }
  }

  Future<bool> executeQuickUpdateAction({
    required I item,
    required QuickActionData data,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      object: this,
      methodName: "executeQuickUpdateAction",
      parameters: {
        "item": item,
        "data": data,
      },
    );
    try {
      bool success = await _executeQuickUpdateWithOverlay(
        item: item,
        data: data,
      );
      frame.updateAllWidgets();
      return success;
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: "quickUpdate",
        error: e,
        stackTrace: stacktrace,
        showSnackbar: true,
      );
      //
      frame.updateAllWidgets();
      return false;
    }
  }

  ///
  /// Load Item Detail.
  ///
  Future<bool> loadItemToShowOrEdit({
    required I item,
    required Function()? route,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: route,
      object: this,
      methodName: "loadItemToShowOrEdit",
      parameters: {
        "item": item,
      },
    );
    //
    const bool forceFormTrue = true;

    bool success = await _prepareToShowOrEditWithOverlayAndRestorable(
      item: item,
      justQueried: false,
      suggestedSelection: null,
      forceForm: forceFormTrue,
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
    try {
      _backupAll();
      //
      bool success = await __prepareToShowOrEdit(
        item: item,
        justQueried: justQueried,
        suggestedSelection: suggestedSelection,
        forceForm: forceForm,
      );

      if (!success) {
        _restoreAll();
        return false;
      } else {
        _applyNewStateAll();
        //
        return true;
      }
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: "prepareToEdit",
        error: e,
        stackTrace: stacktrace,
        showSnackbar: true,
      );
      //
      _restoreAll();
      return false;
    }
  }

  ///
  /// Kiểm tra xem phần tử này có thực sự tồn tại không trước khi hiển thị nó trên giao diện.
  /// Trả về false nếu phần tử này không còn tồn tại trên máy chủ hoặc lỗi.
  ///
  // Private method (Only for use in this class)
  Future<bool> __prepareToShowOrEdit({
    required SuggestedSelection? suggestedSelection,
    required I item,
    required bool forceForm,
    required bool justQueried,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      object: this,
      methodName: "__prepareToShowOrEdit",
      parameters: {
        "suggestedSelection": suggestedSelection,
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
          object: this,
          methodName: "callApiRefreshItem",
          parameters: {
            "item": item,
          },
        );
        //
        result = await callApiRefreshItem(item: item);
      } catch (e, stacktrace) {
        _handleError(
          className: getClassName(this),
          methodName: "callApiRefreshItem",
          error: e,
          stackTrace: stacktrace,
          showSnackbar: true,
        );
        //
        return false;
      }
      if (result.errorMessage != null) {
        _handleRestError(
          methodName: "callApiRefreshItem",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackbar: true,
        );
        return false;
      } else {
        if (result.data == null) {
          bool success =
              await __removeNotFoundItemAndRefreshChildren(notFoundItem: item);
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
    bool success = await __insertOrReplaceItemInListAndRefreshChildren(
      suggestedSelection: suggestedSelection,
      refreshedItemDetail: refreshedItem,
      forceForm: forceForm, // ??????
    );
    if (!success) {
      return false;
    }
    return true;
  }

  bool __checkBeforeFormCreation({required bool showErrorMessage}) {
    if (blockForm == null) {
      if (showErrorMessage) {
        String msg = "${getClassName(this)} has no BlockForm";
        showErrorSnackbar(message: msg, errorDetails: null);
      }
      return false;
    }
    return true;
  }

  ///
  /// Nhẩy tới một trang mới có Form tạo một bản ghi mới.
  ///
  Future<bool> prepareToCreate({
    required Function()? route,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: route,
      object: this,
      methodName: "prepareToCreate",
      parameters: {},
    );
    //
    if (!__checkBeforeFormCreation(showErrorMessage: true)) {
      return false;
    }
    //
    bool success = false;
    __isPreparingFormCreation = true;
    this.updateControlBarWidgets();
    try {
      success = await _prepareToCreateWithOverlayAndRestorable();
    } finally {
      __isPreparingFormCreation = false;
    }
    if (success) {
      _executeRoute(route: route);
    }
    return success;
  }

  Future<bool> _prepareToCreateWithOverlayAndRestorable() async {
    if (!__checkBeforeFormCreation(showErrorMessage: false)) {
      return false;
    }
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await _prepareToCreateWithRestorable();
      },
    );
  }

  Future<bool> _prepareToCreateWithRestorable() async {
    if (!__checkBeforeFormCreation(showErrorMessage: false)) {
      return false;
    }
    try {
      _backupAll();
      //
      bool success = await __prepareToCreate();
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
        showSnackbar: true,
      );
      //
      _restoreAll();
      return false;
    }
  }

  // Private method. Only for use in this class.
  Future<bool> __prepareToCreate() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      object: this,
      methodName: "__prepareToCreate",
      parameters: {},
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
    bool success = await blockForm!._prepareForm(
      refreshedItem: nullItemDetail,
      isNew: true,
      forceForm: true,
    );
    if (!success) {
      return false;
    }
    //
    for (var childBlock in _childBlocks) {
      bool success = await childBlock._switchThisAndChildrenToNoneMode(
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

  Future<bool> show({
    required I item,
    Function()? route,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: route,
      object: this,
      methodName: "show",
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

  Future<bool> deleteCurrentItem() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      object: this,
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

  Future<bool> showConfirmDeleteDialog({String? detals}) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    bool confirm = await _showConfirmDeleteDialog(
      context: context,
      details: detals ?? "",
    );
    return confirm;
  }

  Future<void> showMessageDialog({
    required String message,
    String? detals,
  }) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await _showMessageDialog(
      context: context,
      message: message,
      details: detals ?? "",
    );
  }

  Future<bool> delete(I item) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      object: this,
      methodName: "delete",
      parameters: {
        "item": item,
      },
    );
    //
    if (!canDelete()) {
      return false;
    }
    bool confirm = await showConfirmDeleteDialog(detals: getClassName(item));
    if (!confirm) {
      return false;
    }
    bool success = false;
    __isDeleting = true;
    this.updateControlBarWidgets();
    try {
      success = await _deleteWithOverlayAndRestorable(item);
    } finally {
      __isDeleting = false;
    }
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
    try {
      _backupAll();
      bool success = await __delete(item);

      if (!success) {
        _restoreAll();
      } else {
        _applyNewStateAll();
      }
      return success;
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(this),
        methodName: "delete",
        error: e,
        stackTrace: stacktrace,
        showSnackbar: true,
      );
      //
      _restoreAll();
      return false;
    }
  }

  // Private method. Only for use in this class only.
  Future<bool> __delete(I item) async {
    try {
      if (blockForm?.data._formMode == FormMode.creation) {
        return false;
      }
      if (blockForm?.data._formMode == FormMode.none) {
        return false;
      }
      ApiResult<void> result;
      try {
        FlutterArtist.codeFlowLogger._addMethodCall(
          isLibCode: false,
          route: null,
          object: this,
          methodName: "callApiDelete",
          parameters: {
            "item": item,
          },
        );
        //
        result = await callApiDelete(item: item);
        FlutterArtist.fireSourceChanged(
          sourceBlock: this,
          itemIdString: null,
        );
      } catch (e, stacktrace) {
        _handleError(
          className: getClassName(this),
          methodName: "callApiDelete",
          error: e,
          stackTrace: stacktrace,
          showSnackbar: true,
        );
        //
        return false;
      }
      if (result.errorMessage != null) {
        _handleRestError(
          methodName: "callApiDelete",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackbar: true,
        );
        return false;
      } else {
        final I? currentItem = data.currentItem;
        final I? sibling = data._findSiblingItem(item: item);
        // Remove Item
        if (currentItem != null &&
            getItemIdAsString(currentItem) != getItemIdAsString(item)) {
          __removeItemFromList(removeItem: item);
          return true;
        }
        __removeItemFromList(removeItem: item);

        //
        if (sibling != null) {
          bool success = await __prepareToShowOrEdit(
            item: sibling,
            justQueried: false,
            suggestedSelection: null,
            forceForm: false,
          );
          if (!success) {
            return false;
          }
        } else {
          bool success = await _switchThisAndChildrenToNoneMode(
            clearListForThis: false,
            dataState: DataState.ready,
          );
          if (!success) {
            return false;
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
        showSnackbar: true,
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
      object: this,
      methodName: "refreshCurrentItem",
      parameters: {},
    );
    //
    if (!canRefresh()) {
      return false;
    }
    bool success = false;
    try {
      __isRefreshingCurrentItem = true;
      this.updateControlBarWidgets();
      //
      success = await _prepareToShowOrEditWithOverlayAndRestorable(
        item: data.currentItem!,
        justQueried: false,
        suggestedSelection: null,
        forceForm: false,
      );
    } finally {
      __isRefreshingCurrentItem = false;
    }
    return success;
  }

  Future<ApiResult<D>> callApiQuickUpdate({
    required I item,
    required QuickActionData data,
  }) async {
    throw UnimplementedError("Override me!");
  }

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

  // Developer do not call this method!
  // Call query() instead of
  Future<ApiResult<PageData<I>?>> callApiQuery({
    required S filterSnapshot,
    required PageableData pageable,
  });

  // Developer do not call this method!
  // Call delete instead of
  Future<ApiResult<void>> callApiDelete({required I item});

  Future<ApiResult<D>> callApiRefreshItem({required I item});

  bool canCreate() {
    if (blockForm == null || this.__isPreparingFormCreation) {
      return false;
    }
    if (parent != null) {
      if (parent!.formMode == FormMode.none ||
          parent!.formMode == FormMode.creation) {
        return false;
      }
    }
    return _isAllowCreate();
  }

  bool canSave() {
    if (blockForm == null || blockForm!.isSaving) {
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

  bool canDelete() {
    if (__isDeleting) {
      return false;
    }
    if (parent != null) {
      if (parent!.formMode == FormMode.none ||
          parent!.formMode == FormMode.creation ||
          parent!.data.currentItemDetail == null) {
        return false;
      }
    }
    bool can = blockForm!.data._formMode != FormMode.none;
    if (!can) {
      return false;
    }
    return _isAllowDeleteCurrentItem();
  }

  bool canEditOnForm() {
    if (blockForm == null || blockForm!.__isSaving) {
      return false;
    }
    if (parent != null) {
      if (parent!.formMode == FormMode.none ||
          parent!.formMode == FormMode.creation ||
          parent!.data.currentItemDetail == null) {
        return false;
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
}
