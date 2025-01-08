part of '../flutter_artist.dart';

abstract class NonBlock<D extends Object, S extends FilterSnapshot>
    extends BaseBlk {
  final String name;

  final String? filterName;

  bool __isQuerying = false;

  final List<Type> __listenItemTypes;

  List<Type> get listenItemTypes => [...__listenItemTypes];

  late final BlockFilter<S>? blockFilter;

  late final NonBlockData<D, S> data = NonBlockData<D, S>(this);

  final NonBlockHiddenBehavior hiddenBehavior;

  final Map<_WidgetState, bool> _nonBlockFragmentWidgetStateListeners = {};

  NonBlock({
    required this.name,
    required this.filterName,
    required this.hiddenBehavior,
    List<Type> listenTypes = const [],
  }) : __listenItemTypes = listenTypes;

  String getDataTypeAsString() {
    return D.toString();
  }

  String getFilterSnapshotTypeAsString() {
    return S.toString();
  }

  void _backupAll() {
    this.data._backup();
  }

  void _restoreAll() {
    this.data._restore();
    this.blockFilter?._restore();
  }

  void _applyNewStateAll() {
    this.data._applyNewState();
    this.blockFilter?._applyNewState();
  }

  void updateControlBarWidgets() {
    // TODO: .......
  }

  void updateFragmentWidgets() {
    _removeUnmountedWidgetStates(_nonBlockFragmentWidgetStateListeners);

    for (_WidgetState state in _nonBlockFragmentWidgetStateListeners.keys) {
      if (state.mounted) {
        state.refreshState();
      }
    }
  }

  ///
  ///
  ///
  @nonVirtual
  Future<bool> query() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "query",
      parameters: {},
    );
    //
    bool success = false;
    __isQuerying = true;
    this.updateControlBarWidgets();
    try {
      success = await _queryWithOverlayAndRestorable();
    } finally {
      __isQuerying = false;
      this.updateControlBarWidgets();
    }
    return success;
  }

  Future<ApiResult<D>> callApiQuery({
    required S? filterSnapshot,
  });

  Future<bool> _queryWithOverlayAndRestorable() async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return __queryWithRestorable();
      },
    );
  }

  // Private method (Only for use in this class)
  Future<bool> __queryWithRestorable() async {
    try {
      _backupAll();
      bool success = await __queryThisAndChildren();
      //
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
        ownerClassInstance: blockFilter!,
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
        ownerClassInstance: blockFilter!,
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

  Future<bool> __queryThisAndChildren() async {
    bool success = await __prepareFilter(
      suggestedFilterData: null, // suggestedFilterData,
      force: true,
    );
    if (!success) {
      return false;
    }
    //
    final S? filterSnapshot = blockFilter == null
        ? EmptyFilterSnapshot() as S
        : blockFilter!._currentSnapshot;
    //

    ApiResult<D> result;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        route: null,
        ownerClassInstance: this,
        methodName: "callApiQuery",
        parameters: {},
      );
      //
      result = await callApiQuery(
        filterSnapshot: filterSnapshot,
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

    // TODO: Xu ly cac tinh huong loi???
    data._updateFrom(
      filterSnapshot: filterSnapshot,
      data: result.data,
      dataState: DataState.ready,
    );
    return true;
  }

  bool hasActiveNonBlockFragmentWidget() {
    _removeUnmountedWidgetStates(_nonBlockFragmentWidgetStateListeners);

    var map = {..._nonBlockFragmentWidgetStateListeners};
    for (State widgetState in map.keys) {
      if (widgetState.mounted) {
        bool isShowing = map[widgetState] ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    return false;
  }

  bool hasActiveUiComponent() {
    return hasActiveNonBlockFragmentWidget();
  }

  void _addWidgetStateListener({
    required _WidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUiComponent();
    _nonBlockFragmentWidgetStateListeners[widgetState] = isShowing;
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
      _fireNonBlockHidden();
    }
  }

  void _removeWidgetStateListener({required State widgetState}) {
    bool activeOLD = hasActiveUiComponent();
    _nonBlockFragmentWidgetStateListeners.remove(widgetState);
    bool activeCURRENT = hasActiveUiComponent();
    //
    if (activeOLD && !activeCURRENT) {
      FlutterArtist.storage._checkToRemoveShelf(shelf);
      _fireNonBlockHidden();
    }
  }

  void _fireNonBlockHidden() {
    FlutterArtist.codeFlowLogger._addEvent(
      ownerClassInstance: this,
      event: "NonBlock '${getClassName(this)}' just hides all UI Components!",
      isLibCode: true,
    );
    if (hiddenBehavior == NonBlockHiddenBehavior.clear) {
      Future.delayed(
        const Duration(seconds: 0),
        () {
          // TODO: ???????????????
          // this.emptyQuery();
        },
      );
    }
  }
}
