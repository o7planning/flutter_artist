part of '../flutter_artist.dart';

///
/// [V] - Value.
///
/// ```
/// class OrderSummaryScalar
///        extends Scalar<OrderSummaryData, EmptyFilterSnapshot> {
///
/// }
/// ```
///
/// Query and get data:
///
/// ```dart
/// OrderSummaryShelf shelf = FlutterArtist.storage.findShelf();
/// OrderSummaryScalar scalar = shelf.findOrderSummaryShelf();
/// await scalar.query();
///
/// OrderSummaryData value = scalar.data.value;
/// ```
///
abstract class Scalar<V, S extends FilterSnapshot> extends DataContainer {
  final String name;

  String get _shortPathName {
    return "${shelf.name} >> $name";
  }

  String get _classDefinition {
    return "${getClassName(this)}$_classParametersDefinition";
  }

  String get _classParametersDefinition {
    return "<${getDataTypeAsString()}, ${getFilterSnapshotTypeAsString()}>";
  }

  ///
  /// DataFilter Name registered in [Shelf.registerStructure()] method.
  ///
  final String? registerDataFilterName;

  final String? description;

  bool __isQuerying = false;

  bool get isQuerying => __isQuerying;

  final List<Type> __listenItemTypes;

  List<Type> get listenItemTypes => [...__listenItemTypes];

  ///
  /// This field is not null.
  /// If this scalar does not declare a DataFilter, it will have the default DataFilter.
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

  late final ScalarData<V, S> data = ScalarData<V, S>(this);

  DataState get dataState => data._dataState;

  final ScalarHiddenBehavior hiddenBehavior;

  final Map<_WidgetState, bool> _scalarFragmentWidgetStateListeners = {};

  Scalar({
    required this.name,
    required this.description,
    required this.registerDataFilterName,
    required this.hiddenBehavior,
    required List<Type> listenTypes,
  }) : __listenItemTypes = listenTypes;

  String getDataTypeAsString() {
    return V.toString();
  }

  String getFilterSnapshotTypeAsString() {
    return S.toString();
  }

  void _backup() {
    this.data._backup();
  }

  void _restore() {
    this.data._restore();
  }

  void _applyNewStateAll() {
    this.data._applyNewState();
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
  Future<bool> query({
    S? suggestedFilterSnapshot,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      route: null,
      ownerClassInstance: this,
      methodName: "query",
      parameters: {},
    );
    //
    return await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: _registeredOrDefaultDataFilter,
        suggestedFilterSnapshot: suggestedFilterSnapshot,
      ),
      forceQueryScalarOpts: [_ScalarOpt(scalar: this)],
      forceQueryBlockOpts: [],
      forceQueryBlockFormOpts: [],
    );

    //
    //
    //
    //
    bool success =
        await _registeredOrDefaultDataFilter._queryAllWithOverlayAndRestorable(
      // Suggestion for DataFilter
      suggestedFilterSnapshot: suggestedFilterSnapshot,
      forceBlockWithQueryOptions: null,
      forceScalarWithQueryOptions: _ScalarOpt(
        scalar: this,
      ),
    );
    //
    return success;
    //
    // bool success = false;
    // __isQuerying = true;
    // this.updateControlBarWidgets();
    // try {
    //   // TODO: Remove.
    //   // success = await _queryWithOverlayAndRestorable();
    // } finally {
    //   __isQuerying = false;
    //   this.updateControlBarWidgets();
    // }
    // return success;
  }

  Future<ApiResult<V>> callApiQuery({
    required S? filterSnapshot,
  });

  // TODO: Remove.
  // Future<bool> _queryWithOverlayAndRestorable() async {
  //   return await FlutterArtist.executeTask(
  //     asyncFunction: () async {
  //       return __queryWithRestorable();
  //     },
  //   );
  // }

  // Private method (Only for use in this class)
  // @Deprecated("Xoa di, khong su dung nua")
  // Future<bool> __queryWithRestorable({
  //   required S filterSnapshot,
  // }) async {
  //   try {
  //     _backupAll();
  //     bool success = await __queryThis(
  //       filterSnapshot: filterSnapshot,
  //     );
  //     //
  //     if (!success) {
  //       _restoreAll();
  //       return false;
  //     } else {
  //       _applyNewStateAll();
  //       return true;
  //     }
  //   } catch (e, stacktrace) {
  //     _handleError(
  //       className: getClassName(this),
  //       methodName: 'query',
  //       error: e,
  //       stackTrace: stacktrace,
  //       showSnackBar: true,
  //     );
  //     //
  //     _restoreAll();
  //     return false;
  //   }
  // }

  // Private method. Only for use in this class.
  // Future<bool> __prepareFilter({
  //   required S? suggestedFilterSnapshot,
  //   required bool force,
  // }) async {
  //   if (dataFilter == null) {
  //     return true;
  //   }
  //   try {
  //     FlutterArtist.codeFlowLogger._addMethodCall(
  //       isLibCode: false,
  //       ownerClassInstance: dataFilter!,
  //       methodName: "prepareData",
  //       parameters: {
  //         "suggestedFilterSnapshot": suggestedFilterSnapshot,
  //       },
  //       route: null,
  //     );
  //     //
  //     await dataFilter!.prepareData(
  //       suggestedFilterSnapshot: suggestedFilterSnapshot,
  //     );
  //   } catch (e, stacktrace) {
  //     _handleError(
  //       className: getClassName(dataFilter),
  //       methodName: 'prepareData',
  //       error: e,
  //       stackTrace: stacktrace,
  //       showSnackBar: true,
  //     );
  //     return false;
  //   }
  //   try {
  //     FlutterArtist.codeFlowLogger._addMethodCall(
  //       isLibCode: false,
  //       ownerClassInstance: dataFilter!,
  //       methodName: "takeSnapshot",
  //       parameters: {},
  //       route: null,
  //     );
  //     //
  //     S filterSnapshot = dataFilter!.takeSnapshot();
  //     dataFilter!._currentSnapshot = filterSnapshot;
  //     return true;
  //   } catch (e, stacktrace) {
  //     _handleError(
  //       className: getClassName(dataFilter),
  //       methodName: 'prepareData',
  //       error: e,
  //       stackTrace: stacktrace,
  //       showSnackBar: true,
  //     );
  //     return false;
  //   }
  // }

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      this.updateControlBarWidgets();
    } catch (e) {}
  }

  Future<bool> __queryThis({
    required S filterSnapshot,
  }) async {
    ApiResult<V> result;
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
      result = await callApiQuery(
        filterSnapshot: filterSnapshot,
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
