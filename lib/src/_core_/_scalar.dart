part of '../../flutter_artist.dart';

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

  String get pathInfo {
    return "scalar > ${shelf.name} > $name";
  }

  String get _classDefinition {
    return "${getClassName(this)}$_classParametersDefinition";
  }

  String get _classParametersDefinition {
    return "<${getFilterInputType()}, ${getValueType()}, ${getFilterCriteriaType()}>";
  }

  ///
  /// FilterModel Name registered in [Shelf.registerStructure()] method.
  ///
  final String? registerFilterModelName;

  final String? description;

  bool __isQuerying = false;

  bool get isQuerying => __isQuerying;

  final ScalarOutsideEventReaction? outsideEventReaction;

  ///
  /// This field is not null.
  /// If this scalar does not declare a FilterModel, it will have the default FilterModel.
  ///
  late final FilterModel<FILTER_INPUT, FILTER_CRITERIA>
  _registeredOrDefaultFilterModel;

  ///
  /// Returns a FilterModel declared in the [Shelf.registerStructure()] method.
  /// The return value may be null.
  ///
  FilterModel<FILTER_INPUT, FILTER_CRITERIA>? get filterModel {
    if (_registeredOrDefaultFilterModel is _DefaultFilterModel) {
      return null;
    } else {
      return _registeredOrDefaultFilterModel;
    }
  }

  late final __scalarData =
  _ScalarData<VALUE, FILTER_INPUT, FILTER_CRITERIA>(this);

  final ScalarHiddenBehavior hiddenBehavior;

  final Map<_RefreshableWidgetState, bool> _scalarFragmentWidgetStates = {};
  final Map<_RefreshableWidgetState, bool> _scalarControlWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  DataState get queryDataState => __scalarData._queryDataState;

  FILTER_CRITERIA? get filterCriteria => __scalarData._filterCriteria;

  VALUE? get value => __scalarData._value;

  void setToPending() {
    __scalarData._setToPending();
  }

  // ***************************************************************************
  // ***************************************************************************

  Scalar({
    required this.name,
    required this.description,
    required String? filterModelName,
    required this.hiddenBehavior,
    this.outsideEventReaction,
  }) : registerFilterModelName = filterModelName;

  // ***************************************************************************
  // ***************************************************************************

  List<Type> _getOutsideDataTypesToListen() {
    if (outsideEventReaction == null) {
      return [];
    }
    List<Type> itemTypes = [];
    for (Event event in outsideEventReaction!._events ?? []) {
      itemTypes.add(event.dataType);
    }
    return itemTypes;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_ScalarQueryAnnotation()
  Future<ScalarQueryResult> _unitQuery({required _XScalar thisXScalar}) async {
    __assertThisXScalar(thisXScalar);
    //
    bool hasActiveUI = this.hasActiveUIComponent();
    bool forceQuery = thisXScalar.needQuery;
    if (!forceQuery) {
      if (this.queryDataState != DataState.ready && hasActiveUI) {
        forceQuery = true;
      }
    }
    //
    print(
        ">> ${getClassName(
            this)}._unitQuery - queryState: $queryDataState, forceQuery: ${thisXScalar
            .needQuery}");
    //
    if (!forceQuery) {
      return thisXScalar.queryResult;
    }
    //
    // this.queryDataState != DataState.ready || thisXScalar.forceQuery
    //
    DataState newQueryDataState = this.queryDataState;
    //
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: false,
      navigate: null,
      ownerClassInstance: this,
      methodName: "callApiQuery",
      parameters: {},
    );
    //
    FILTER_CRITERIA? filterCriteriaOfFilterModel;
    try {
      final _XFilterModel xFilterModel = thisXScalar.xFilterModel;
      final FilterModel filterModel = xFilterModel.filterModel;
      //
      if (!xFilterModel.queried) {
        FILTER_INPUT? filterInput = xFilterModel.filterInput as FILTER_INPUT?;
        //
        filterCriteriaOfFilterModel = await filterModel._startNewFilterActivity(
          activityType: _FilterActivityType.newFilt,
          filterInput: filterInput,
        ) as FILTER_CRITERIA?;
        //
        xFilterModel.queried = true;
      } else {
        filterCriteriaOfFilterModel =
        filterModel._filterCriteria! as FILTER_CRITERIA;
      }
    } catch (e, stackTrace) {
      /* Never Error */
    }
    //
    // Has Error in FilterModel.
    //
    if (filterCriteriaOfFilterModel == null) {
      // Set Block to error cascade.
      __clearWithDataState(
        thisXScalar: thisXScalar,
        queryDataState: DataState.error,
      );
      thisXScalar.queryResult._filterError = true;
      return thisXScalar.queryResult;
    }
    //
    // Ready FilterCriteria:
    //
    bool xCriteriaChanged = this.__scalarData._isXCriteriaChanged(
      newFilterCriteria: filterCriteriaOfFilterModel,
    );
    //
    bool isQueryError = false;
    VALUE? value;
    try {
      __refreshQueryingState(isQuerying: true);
      //
      ApiResult<VALUE> result = await callApiQuery(
        filterCriteria: filterCriteriaOfFilterModel,
      );
      //
      if (result.apiError != null) {
        _handleRestError(
          shelf: shelf,
          methodName: "callApiQuery",
          message: result.apiError!.errorMessage,
          errorDetails: result.apiError!.errorDetails,
          showSnackBar: true,
        );
        isQueryError = true;
      } else {
        value = result.data;
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: 'callApiQuery',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      isQueryError = true;
    } finally {
      __refreshQueryingState(isQuerying: false);
    }
    //
    if (isQueryError) {
      thisXScalar.queryResult._apiError = true;
      newQueryDataState = DataState.error;
    } else {
      newQueryDataState = DataState.ready;
    }
    //
    __setQueryDataWithState(
      thisXScalar: thisXScalar,
      filterCriteria: filterCriteriaOfFilterModel,
      dataState: newQueryDataState,
      value: value,
    );
    //
    return thisXScalar.queryResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_ScalarExecuteQuickActionAnnotation()
  Future<bool> _unitQuickAction<DATA extends Object>({
    required _XScalar thisXScalar,
    required QuickAction<DATA> action,
    required AfterScalarQuickAction afterQuickAction,
  }) async {
    __assertThisXScalar(thisXScalar);
    //
    ApiResult<DATA>? result;
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
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApi',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
    //
    bool success = true;
    if (result != null && result.apiError != null) {
      success = false;
      //
      _handleRestError(
        shelf: shelf,
        methodName: "${getClassName(action)}.callApi",
        message: result.apiError!.errorMessage,
        errorDetails: result.apiError!.errorDetails,
        showSnackBar: true,
      );
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
      return false;
    }
    //
    switch (afterQuickAction) {
      case AfterScalarQuickAction.none:
        break;
      case AfterScalarQuickAction.query:
        var taskUnit = _ScalarQueryTaskUnit(
          xScalar: thisXScalar,
        );
        FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    }
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setQueryDataWithState({
    required _XScalar thisXScalar,
    required FILTER_CRITERIA? filterCriteria,
    required DataState dataState,
    required VALUE? value,
  }) {
    __assertThisXScalar(thisXScalar);
    //
    this.__scalarData._updateFrom(
      filterCriteria: filterCriteria,
      dataState: dataState,
      value: value,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearWithDataState({
    required _XScalar thisXScalar,
    required DataState queryDataState,
  }) {
    __assertThisXScalar(thisXScalar);
    //
    this.__scalarData._clearWithDataState(queryDataState: queryDataState);
  }

  // ***************************************************************************
  // ***************************************************************************

  Type getValueType() {
    return VALUE;
  }

  Type getFilterInputType() {
    return FILTER_INPUT;
  }

  Type getFilterCriteriaType() {
    return FILTER_CRITERIA;
  }

  // ***************************************************************************
  // ****** UPDATE UI COMPONENTS ***********************************************
  // ***************************************************************************

  void updateAllUIComponents({
    required bool withoutFilters,
    bool force = true,
  }) {
    if (!withoutFilters) {
      filterModel?.updateAllUIComponents();
    }
    updateControlWidgets(force: force);
    updateFragmentWidgets(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateControlWidgets({bool force = true}) {
    for (_RefreshableWidgetState state in _scalarControlWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateFragmentWidgets({bool force = true}) {
    for (_RefreshableWidgetState state in _scalarFragmentWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<VALUE>> callApiQuery({
    required FILTER_CRITERIA filterCriteria,
  });

  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================

  @_RootMethodAnnotation()
  @_ScalarExecuteQuickActionAnnotation()
  Future<bool> executeQuickAction<DATA extends Object>({
    FILTER_INPUT? filterInput,
    required ActionConfirmationType actionConfirmationType,
    required QuickAction<DATA> action,
    required AfterScalarQuickAction afterQuickAction,
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
    List<_ScalarOpt> forceQueryScalarOpts = [];
    switch (afterQuickAction) {
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
      forceFilterModelOpt: _FilterModelOpt(
        filterModel: _registeredOrDefaultFilterModel,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: forceQueryScalarOpts,
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XScalar thisXScalar = xShelf.findXScalarByName(this.name)!;
    //
    _TaskUnit taskUnit = _ScalarQuickActionTaskUnit(
      xScalar: thisXScalar,
      action: action,
      afterQuickAction: afterQuickAction,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  ///
  @nonVirtual
  @_RootMethodAnnotation()
  @_ScalarQueryAnnotation()
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
    _XShelf xShelf = await shelf._queryAll(
      forceFilterModelOpt: _FilterModelOpt(
        filterModel: _registeredOrDefaultFilterModel,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: [
        _ScalarOpt(scalar: this),
      ],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XScalar xScalar = xShelf.findXScalarByName(this.name)!;
    ScalarQueryResult result = xScalar.queryResult;
    return result.success;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      this.updateControlWidgets();
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasMountedUIComponent() {
    return _scalarFragmentWidgetStates.isNotEmpty ||
        _scalarControlWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponent() {
    return _hasActiveScalarFragmentWidgetState() ||
        _hasActiveControlWidgetState();
  }

  // ***************************************************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // ***************************************************************************

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
      shelf._startLoadDataForLazyUIComponentsIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      _fireScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeControlWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    _scalarControlWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      _fireScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

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
      shelf._startLoadDataForLazyUIComponentsIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      _fireScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeScalarFragmentWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    _scalarFragmentWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      _fireScalarHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _fireScalarHidden() {
    FlutterArtist.codeFlowLogger._addEvent(
      ownerClassInstance: this,
      event: "Scalar '${getClassName(this)}' just hides all UI Components!",
      isLibCode: true,
    );
    switch (hiddenBehavior) {
      case ScalarHiddenBehavior.none:
        break;
      case ScalarHiddenBehavior.clear:
        break;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isAllowQuery() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

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
