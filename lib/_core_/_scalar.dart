part of '../flutter_artist.dart';

abstract class Scalar<D extends Object, S extends FilterSnapshot>
    extends BaseBlk {
  final String name;

  String get _fullName {
    return "${shelf.name} >> $name";
  }

  String get _classDefinition {
    return "${getClassName(this)}$_classParametersDefinition";
  }

  String get _classParametersDefinition {
    return "<${getDataTypeAsString()}, ${getFilterSnapshotTypeAsString()}>";
  }

  final String? filterName;

  final String? description;

  bool __isQuerying = false;

  final List<Type> __listenItemTypes;

  List<Type> get listenItemTypes => [...__listenItemTypes];

  late final DataFilter<S>? dataFilter;

  late final ScalarData<D, S> data = ScalarData<D, S>(this);

  DataState get dataState => data._dataState;

  final ScalarHiddenBehavior hiddenBehavior;

  final Map<_WidgetState, bool> _scalarFragmentWidgetStateListeners = {};

  Scalar({
    required this.name,
    required this.description,
    required this.filterName,
    required this.hiddenBehavior,
    required List<Type> listenTypes,
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
    this.dataFilter?._restore();
  }

  void _applyNewStateAll() {
    this.data._applyNewState();
    this.dataFilter?._applyNewState();
  }

  void updateControlBarWidgets() {
    // TODO: .......
  }

  void updateFragmentWidgets() {
    _removeUnmountedWidgetStates(_scalarFragmentWidgetStateListeners);

    for (_WidgetState state in _scalarFragmentWidgetStateListeners.keys) {
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
    if (dataFilter == null) {
      return true;
    }
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        ownerClassInstance: dataFilter!,
        methodName: "prepareData",
        parameters: {
          "suggestedFilterData": suggestedFilterData,
        },
        route: null,
      );
      //
      await dataFilter!.prepareData(suggestedFilterData: suggestedFilterData);
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(dataFilter),
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
        ownerClassInstance: dataFilter!,
        methodName: "takeSnapshot",
        parameters: {},
        route: null,
      );
      //
      S filterSnapshot = dataFilter!.takeSnapshot();
      dataFilter!._currentSnapshot = filterSnapshot;
      return true;
    } catch (e, stacktrace) {
      _handleError(
        className: getClassName(dataFilter),
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
    final S? filterSnapshot = dataFilter == null
        ? EmptyFilterSnapshot() as S
        : dataFilter!._currentSnapshot;
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

  bool hasActiveScalarFragmentWidget() {
    _removeUnmountedWidgetStates(_scalarFragmentWidgetStateListeners);

    var map = {..._scalarFragmentWidgetStateListeners};
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
    return hasActiveScalarFragmentWidget();
  }

  void _addWidgetStateListener({
    required _WidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUiComponent();
    _scalarFragmentWidgetStateListeners[widgetState] = isShowing;
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
      _fireScalarHidden();
    }
  }

  void _removeWidgetStateListener({required State widgetState}) {
    bool activeOLD = hasActiveUiComponent();
    _scalarFragmentWidgetStateListeners.remove(widgetState);
    bool activeCURRENT = hasActiveUiComponent();
    //
    if (activeOLD && !activeCURRENT) {
      FlutterArtist.storage._checkToRemoveShelf(shelf);
      _fireScalarHidden();
    }
  }

  void _fireScalarHidden() {
    FlutterArtist.codeFlowLogger._addEvent(
      ownerClassInstance: this,
      event: "Scalar '${getClassName(this)}' just hides all UI Components!",
      isLibCode: true,
    );
    if (hiddenBehavior == ScalarHiddenBehavior.clear) {
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
