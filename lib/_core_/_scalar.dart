part of '../flutter_artist.dart';

///
/// [VALUE] - Value.
///
/// ```
/// class OrderSummaryScalar
///        extends Scalar<OrderSummaryData, EmptyFilterCriteria> {
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
abstract class Scalar<
VALUE extends Object,
FILTER_INPUT extends FilterInput, // EmptyFilterInput
FILTER_CRITERIA extends FilterCriteria // EmptyFilterCriteria
> extends _XBase {
  late final Shelf shelf;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  ///
  /// Scalar name. It is unique in a Shelf.
  ///
  final String name;

  String get _shortPathName {
    return "${shelf.name} >> $name";
  }

  String get id {
    return "scalar > ${shelf.name} > $name";
  }

  String get _classDefinition {
    return "${getClassName(this)}$_classParametersDefinition";
  }

  String get _classParametersDefinition {
    return "<${getFilterInputTypeAsString()}, ${getValueTypeAsString()}, ${getFilterCriteriaTypeAsString()}>";
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
  late final DataFilter<FILTER_INPUT, FILTER_CRITERIA>
  _registeredOrDefaultDataFilter;

  ///
  /// Returns a DataFilter declared in the [Shelf.registerStructure()] method.
  /// The return value may be null.
  ///
  DataFilter<FILTER_INPUT, FILTER_CRITERIA>? get dataFilter {
    if (_registeredOrDefaultDataFilter is _DefaultDataFilter) {
      return null;
    } else {
      return _registeredOrDefaultDataFilter;
    }
  }

  late final ScalarData<VALUE, FILTER_INPUT, FILTER_CRITERIA> data =
  ScalarData<VALUE, FILTER_INPUT, FILTER_CRITERIA>(this);

  DataState get dataState => data._dataState;

  final ScalarHiddenBehavior hiddenBehavior;

  final Map<_RefreshableWidgetState, bool> _scalarFragmentWidgetStates = {};
  final Map<_RefreshableWidgetState, bool> _scalarControlWidgetStates = {};

  Scalar({
    required this.name,
    required this.description,
    required String? dataFilterName,
    required this.hiddenBehavior,
    required List<Type> listenTypes,
  })
      : registerDataFilterName = dataFilterName,
        __listenItemTypes = listenTypes;

  String getValueTypeAsString() {
    return VALUE.toString();
  }

  String getFilterInputTypeAsString() {
    return FILTER_INPUT.toString();
  }

  String getFilterCriteriaTypeAsString() {
    return FILTER_CRITERIA.toString();
  }

  // ***************************************************************************
  // ****** BACKUP & RESTORE & APPLY *******************************************
  // ***************************************************************************

  void _backup() {
    this.data._backup();
  }

  void _restore() {
    this.data._restore();
  }

  void _applyNewState() {
    this.data._applyNewState();
  }

  // ***************************************************************************
  // ****** UPDATE UI COMPONENTS ***********************************************
  // ***************************************************************************

  void updateAllUIComponents({required bool withoutFilters}) {
    if (!withoutFilters) {
      dataFilter?.updateAllUIComponents();
    }
    updateControlWidgets();
    updateFragmentWidgets();
  }

  void updateControlWidgets() {
    for (_RefreshableWidgetState state in _scalarControlWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState();
      }
    }
  }

  void updateFragmentWidgets() {
    for (_RefreshableWidgetState state in _scalarFragmentWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState();
      }
    }
  }

  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================

  Future<bool> executeQuickAction<DATA extends Object>({
    FILTER_INPUT? filterInput,
    required ActionConfirmationType actionConfirmationType,
    required QuickAction<DATA> action,
    required AfterScalarQuickAction? afterQuickAction,
    required Function(BuildContext context)? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "executeQuickAction",
      parameters: {
        "filterInput": filterInput,
        "action": action,
        "afterQuickAction": afterQuickAction,
      },
    );
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await __showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action._defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    //
    if (!confirm) {
      return false;
    }
    //
    try {
      bool success = await _executeQuickActionWithOverlayAndRestorable(
        filterInput: filterInput,
        action: action,
        afterQuickAction: afterQuickAction,
        navigate: navigate,
      );
      return success;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "executeQuickAction",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      shelf.updateAllUIComponents();
      return false;
    }
  }

  Future<bool>
  _executeQuickActionWithOverlayAndRestorable<DATA extends Object>({
    required FILTER_INPUT? filterInput,
    required QuickAction<DATA> action,
    required AfterScalarQuickAction? afterQuickAction,
    required Function(BuildContext context)? navigate,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        bool success = await __executeQuickActionWithRestorable(
          filterInput: filterInput,
          action: action,
          afterQuickAction: afterQuickAction,
        );
        if (success) {
          try {
            BuildContext context = FlutterArtist.adapter.getCurrentContext();
            if (navigate != null && context.mounted) {
              navigate(context);
            }
          } catch (e, stackTrace) {
            print("Error: $e");
            print(stackTrace);
          }
        }
        return success;
      },
    );
  }

  Future<bool> __executeQuickActionWithRestorable<DATA extends Object>({
    required FILTER_INPUT? filterInput,
    required QuickAction<DATA> action,
    required AfterScalarQuickAction? afterQuickAction,
  }) async {
    List<_ScalarOpt> forceQueryScalarOpts = [];
    switch (afterQuickAction) {
      case null:
        break;
      case AfterScalarQuickAction.none:
        break;
      case AfterScalarQuickAction.query:
        forceQueryScalarOpts = [
          _ScalarOpt(scalar: this),
        ];
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: _registeredOrDefaultDataFilter,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: forceQueryScalarOpts,
      forceQueryBlockOpts: [],
      forceQueryBlockFormOpts: [],
    );
    //
    try {
      shelf._backupAll();
      //
      _XScalar thisXScalar = xShelf.findXScalarByName(name)!;
      //
      bool success = await __executeQuickAction(
        thisXScalar: thisXScalar,
        action: action,
        afterQuickAction: afterQuickAction,
      );
      if (!success) {
        shelf._restoreAll();
      } else {
        shelf._applyNewStateAll();
      }
      return success;
    } catch (e, stackTrace) {
      shelf._restoreAll();
      //
      _handleError(
        shelf: shelf,
        methodName: "__executeQuickAction",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
  }

  Future<bool> __executeQuickAction<DATA extends Object>({
    required _XScalar thisXScalar,
    required QuickAction<DATA> action,
    required AfterScalarQuickAction? afterQuickAction,
  }) async {
    __assertThisXScalar(thisXScalar);
    //
    ApiResult<DATA>? result;
    bool success = false;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        ownerClassInstance: action,
        methodName: "callApi",
        parameters: null,
        navigate: null,
        isLibCode: false,
      );
      //
      result = await action.callApi();
      //
      if (result != null && result.errorMessage != null) {
        _handleRestError(
          shelf: shelf,
          methodName: "${getClassName(action)}.callApi",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        success = false;
      } else {
        success = true;
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApi',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      success = false;
    }
    //
    try {
      DATA? apiData = result?.data;
      await action.doAfterCallApi(success: success, apiData: apiData);
      //
      if (success) {
        FlutterArtist.storage._fireEventToAffectedItemTypes(
          affectedItemTypes: action.affectedItemTypes,
        );
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApi',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      success = false;
    }
    //
    if (afterQuickAction != null) {
      String methodName = "";
      try {
        bool success = false;
        switch (afterQuickAction) {
          case AfterScalarQuickAction.none:
            success = true;
            break;
          case AfterScalarQuickAction.query:
            success = true;
            break;
        }
        return success;
      } catch (e, stackTrace) {
        _handleError(
          shelf: shelf,
          methodName: methodName,
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        return false;
      }
    }
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  Future<ApiResult<VALUE>> callApiQuery({
    required FILTER_CRITERIA? filterCriteria,
  });

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  ///
  @nonVirtual
  Future<bool> query({
    FILTER_INPUT? filterInput,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "query",
      parameters: {"filterInput": filterInput},
    );
    //
    return await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: _registeredOrDefaultDataFilter,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: [_ScalarOpt(scalar: this)],
      forceQueryBlockOpts: [],
      forceQueryBlockFormOpts: [],
    );
  }

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      this.updateControlWidgets();
    } catch (e) {}
  }

  Future<bool> __queryThis({
    required FILTER_CRITERIA filterCriteria,
  }) async {
    ApiResult<VALUE> result;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        navigate: null,
        ownerClassInstance: this,
        methodName: "callApiQuery",
        parameters: {},
      );
      //
      __refreshQueryingState(isQuerying: true);
      //
      result = await callApiQuery(
        filterCriteria: filterCriteria,
      );
      //
      __refreshQueryingState(isQuerying: false);
    } catch (e, stackTrace) {
      __refreshQueryingState(isQuerying: false);
      //
      _handleError(
        shelf: shelf,
        methodName: "callApiQuery",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
    if (result.errorMessage != null) {
      _handleRestError(
        shelf: shelf,
        methodName: "callApiQuery",
        message: result.errorMessage!,
        errorDetails: result.errorDetails,
        showSnackBar: true,
      );
      return false;
    }
    // TODO: Xu ly cac tinh huong loi???
    data._updateFrom(
      filterCriteria: filterCriteria,
      data: result.data,
      dataState: DataState.ready,
    );
    return true;
  }

  bool hasMountedUIComponent() {
    return _scalarFragmentWidgetStates.isNotEmpty ||
        _scalarControlWidgetStates.isNotEmpty;
  }

  bool hasActiveUIComponent() {
    return _hasActiveScalarFragmentWidgetState() ||
        _hasActiveControlWidgetState();
  }

  bool _hasActiveScalarFragmentWidgetState() {
    for (State widgetState in _scalarFragmentWidgetStates.keys) {
      if (widgetState.mounted) {
        bool isShowing = _scalarFragmentWidgetStates[widgetState] ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    return false;
  }

  bool _hasActiveControlWidgetState() {
    for (State widgetState in _scalarControlWidgetStates.keys) {
      if (widgetState.mounted) {
        bool isShowing = _scalarControlWidgetStates[widgetState] ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    return false;
  }

  void _addControlWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _scalarControlWidgetStates[widgetState] = isShowing;
    bool activeCURRENT = hasActiveUIComponent();
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

  void _removeControlWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    _scalarControlWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      _fireScalarHidden();
    }
  }

  void _addScalarFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _scalarFragmentWidgetStates[widgetState] = isShowing;
    bool activeCURRENT = hasActiveUIComponent();
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

  void _removeScalarFragmentWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    _scalarFragmentWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
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

  bool isAllowQuery() {
    return true;
  }

  ///
  /// Do not override
  ///
  bool canQuery() {
    return isAllowQuery();
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXScalar(_XScalar thisXScalar) {
    if (thisXScalar.scalar != this || thisXScalar.name != name) {
      String message = "Error Assets scalar: ${thisXScalar.scalar} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
