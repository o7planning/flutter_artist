part of '../core.dart';

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
    > extends _Core {
  late final Shelf shelf;

  PageData<VALUE>? get lastQueryResult => __scalarData._lastQueryResult;

  ActionResultState? get lastQueryResultState =>
      __scalarData._lastQueryResultState;

  QueryType __lastQueryType = QueryType.realQuery;

  QueryType get lastQueryType => __lastQueryType;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  int __callApiQueryCount = 0;

  int get callApiQueryCount => __callApiQueryCount;

  int get filterCriteriaChangeCount => __scalarData._filterCriteriaChangeCount;

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

  @DebugMethodAnnotation()
  String get debugClassDefinition {
    return "${getClassName(this)}$debugClassParametersDefinition";
  }

  @DebugMethodAnnotation()
  String get debugClassParametersDefinition {
    return "<${getFilterInputType()}, ${getValueType()}, ${getFilterCriteriaType()}>";
  }

  ///
  /// FilterModel Name registered in [Shelf.registerStructure()] method.
  ///
  final String? registerFilterModelName;

  final String? description;

  final ScalarConfig config;

  final _internalListeners = EffectedShelfMembers();

  bool __isQuerying = false;

  bool get isQuerying => __isQuerying;

  ///
  /// This field is not null.
  /// If this scalar does not declare a FilterModel, it will have the default FilterModel.
  ///
  late final FilterModel<FILTER_INPUT, FILTER_CRITERIA>
      _registeredOrDefaultFilterModel;

  ///
  /// This field is not null.
  /// If this scalar does not declare a FilterModel, it will have the default FilterModel.
  ///
  FilterModel<FILTER_INPUT, FILTER_CRITERIA>
      get registeredOrDefaultFilterModel => _registeredOrDefaultFilterModel;

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

  late final _ScalarUIComponents ui = _ScalarUIComponents(scalar: this);

  // ***************************************************************************
  // ***************************************************************************

  ScalarErrorInfo? _scalarErrorInfo;

  ScalarErrorInfo? get scalarErrorInfo => _scalarErrorInfo;

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
    required ScalarConfig config,
    required String? filterModelName,
  })  : config = config.copy(),
        registerFilterModelName = filterModelName;

  // ***************************************************************************
  // ***************************************************************************

  List<Type> getOutsideDataTypesToListen() {
    final List<Type> list = [];
    //
    list.addAll(config.reQueryByExternalShelfEvents);
    //
    return list.toSet().toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_ScalarQueryAnnotation()
  Future<void> _unitQuery({
    required _XScalar thisXScalar,
  }) async {
    __assertThisXScalar(thisXScalar);
    //
    bool hasActiveUI = ui.hasActiveUIComponent();
    QryHint forceQuery = thisXScalar.queryHint;
    if (forceQuery != QryHint.force) {
      if (this.queryDataState != DataState.ready && hasActiveUI) {
        forceQuery = QryHint.force;
      }
    }
    //
    print(
        ">> ${getClassName(this)}._unitQuery - queryState: $queryDataState, forceQuery: ${thisXScalar.queryHint}");
    //
    if (forceQuery == QryHint.none) {
      return;
    } else if (forceQuery == QryHint.markAsPending) {
      __scalarData._queryDataState = DataState.pending;
      return;
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
          activityType: FilterActivityType.newFilt,
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
      thisXScalar.queryResult._setFilterError();
      return;
    }
    //
    // Ready FilterCriteria:
    //
    bool xCriteriaChanged = this.__scalarData._isXCriteriaChanged(
          newFilterCriteria: filterCriteriaOfFilterModel,
        );
    //
    final callApiQueryMethod = ScalarErrorMethod.callApiQuery;
    bool isQueryError = false;
    VALUE? value;
    try {
      __clearScalarError();
      __refreshQueryingState(isQuerying: true);
      //
      ApiResult<VALUE> result = await callApiQuery(
        filterCriteria: filterCriteriaOfFilterModel,
      );
      //
      // Throw ApiError:
      result.throwIfError();
      //
      value = result.data;
    } catch (e, stackTrace) {
      isQueryError = true;
      //
      final scalarErrorInfo = ScalarErrorInfo(
        queryDataState: queryDataState,
        scalarErrorMethod: callApiQueryMethod,
        error: e, // AppError, ApiError or others.
        errorStackTrace: stackTrace,
      );
      __setScalarErrorInfo(scalarErrorInfo);
      //
      AppError appError = _handleError(
        shelf: shelf,
        methodName: callApiQueryMethod.name,
        // AppError, ApiError or others.
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      thisXScalar.queryResult._setAppError(
        appError: appError,
        stackTrace: appError is ApiError ? null : stackTrace,
      );
      isQueryError = true;
    } finally {
      __refreshQueryingState(isQuerying: false);
    }
    //
    if (isQueryError) {
      newQueryDataState = DataState.error;
    } else {
      newQueryDataState = DataState.ready;
    }
    // TODO: Test Case.
    __setQueryDataWithState(
      thisXScalar: thisXScalar,
      filterCriteria: filterCriteriaOfFilterModel,
      dataState: newQueryDataState,
      value: value,
    );
    //
    return;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_ScalarQuickActionAnnotation()
  Future<bool> _unitQuickAction({
    required _XScalar thisXScalar,
    required ScalarQuickAction action,
    required ScalarQuickActionResult taskResult,
  }) async {
    __assertThisXScalar(thisXScalar);
    //
    ApiResult<void>? result;
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
      // Throw ApiError.
      result.throwIfError();
    } catch (e, stackTrace) {
      AppError appError = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApi',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      taskResult._setAppError(
        appError: appError,
        stackTrace: appError is ApiError ? null : stackTrace,
      );
      return false;
    }
    //
    FlutterArtist.storage.ev._fireEventFromShelfToOtherShelves(
      eventShelf: shelf,
      events: action.config.affectedItemTypes,
    );
    //
    switch (action.config.afterQuickAction) {
      case AfterScalarQuickAction.none:
        break;
      case AfterScalarQuickAction.query:
        var taskUnit = _ScalarQueryTaskUnit(
          xScalar: thisXScalar,
        );
        FlutterArtist._taskUnitQueue.addTaskUnit(taskUnit);
    }
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_ScalarLoadExtraDataQuickActionAnnotation()
  Future<bool> _unitLoadExtraDataQuickAction<DATA extends Object>({
    required _XScalar thisXScalar,
    required ScalarLoadExtraDataQuickAction<DATA> action,
    required AfterScalarLoadExtraDataQuickAction afterQuickAction,
  }) async {
    __assertThisXScalar(thisXScalar);
    //
    ApiResult<DATA>? result;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        ownerClassInstance: action,
        methodName: "callApiLoadExtraData",
        parameters: null,
        navigate: null,
        isLibCode: false,
      );
      //
      result = await action.callApiLoadExtraData();
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApiLoadExtraData',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
    //
    bool success = true;
    if (result != null && result.error != null) {
      success = false;
      //
      _handleRestError(
        shelf: shelf,
        methodName: "${getClassName(action)}.callApiLoadExtraData",
        message: result.error!.errorMessage,
        errorDetails: result.error!.errorDetails,
        showSnackBar: true,
      );
    }
    //
    try {
      DATA? extraData = result?.data;
      //
      // IMPORTANT: No await.
      //
      _showAfterScalarLoadExtraData(
        action: action,
        afterQuickAction: afterQuickAction,
        extraData: extraData,
        success: success,
      );
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
    return true;
  }

  Future<void> _showAfterScalarLoadExtraData<DATA extends Object>({
    required ScalarLoadExtraDataQuickAction<DATA> action,
    required AfterScalarLoadExtraDataQuickAction afterQuickAction,
    required DATA? extraData,
    required bool success,
  }) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await action.doWithExtraData(
      context,
      success: success,
      extraData: extraData,
    );
    switch (afterQuickAction) {
      case AfterScalarLoadExtraDataQuickAction.none:
        break;
      case AfterScalarLoadExtraDataQuickAction.update:
        ui.updateAllUIComponents(withoutFilters: true);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  void showScalarErrorViewerDialog(BuildContext context) {
    if (queryDataState != DataState.error ||
        _scalarErrorInfo == null ||
        _scalarErrorInfo!.scalarErrorMethod != ScalarErrorMethod.callApiQuery) {
      return;
    }
    ScalarErrorViewerDialog.showScalarErrorViewerDialog(
      context: context,
      scalarErrorInfo: _scalarErrorInfo!,
    );
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
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<VALUE>> callApiQuery({
    required FILTER_CRITERIA filterCriteria,
  });

  // ***************************************************************************
  // ***************************************************************************

  void __clearScalarError() {
    _scalarErrorInfo = null;
  }

  void __setScalarErrorInfo(ScalarErrorInfo errorInfo) {
    _scalarErrorInfo = errorInfo;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<ScalarQuickActionPrecheck> __canQuickAction({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<ScalarQuickActionPrecheck>.no(
        errCode: ScalarQuickActionPrecheck.busy,
      );
    }
    switch (queryDataState) {
      case DataState.pending:
        return Actionable<ScalarQuickActionPrecheck>.no(
          errCode: ScalarQuickActionPrecheck.scalarInPendingState,
        );
      case DataState.error:
        return Actionable<ScalarQuickActionPrecheck>.no(
          errCode: ScalarQuickActionPrecheck.scalarInErrorState,
        );
      case DataState.none:
        return Actionable<ScalarQuickActionPrecheck>.no(
          errCode: ScalarQuickActionPrecheck.scalarInNoneState,
        );
      case DataState.ready:
        break;
    }
    //
    return Actionable<ScalarQuickActionPrecheck>.yes();
  }

  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================

  @_RootMethodAnnotation()
  @_ScalarQuickActionAnnotation()
  Future<ScalarQuickActionResult> executeQuickAction({
    FILTER_INPUT? filterInput,
    required ActionConfirmationType actionConfirmationType,
    required ScalarQuickAction action,
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
      },
    );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<ScalarQuickActionPrecheck> actionable = __canQuickAction(
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      return ScalarQuickActionResult(
        precheck: actionable.errCode,
        stackTrace: actionable.stackTrace,
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
      return ScalarQuickActionResult(
        precheck: ScalarQuickActionPrecheck.cancelled,
      );
    }

    // _QShelf.forScalarQuickAction.
    _XShelf xShelf = _XShelf.forScalarQuickAction(
      scalar: this,
    );
    //
    _XScalar thisXScalar = xShelf.findXScalarByName(this.name)!;
    //
    _ResultedTaskUnit taskUnit = _ScalarQuickActionTaskUnit(
      xScalar: thisXScalar,
      action: action,
    );
    //
    FlutterArtist._taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ScalarLoadExtraDataQuickActionAnnotation()
  Future<bool> executeQuickLoadExtraDataAction<DATA extends Object>({
    FILTER_INPUT? filterInput,
    required ActionConfirmationType actionConfirmationType,
    required ScalarLoadExtraDataQuickAction<DATA> action,
    required AfterScalarLoadExtraDataQuickAction afterQuickAction,
    required Function(BuildContext context)? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "executeQuickLoadExtraDataAction",
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
      confirm = await _showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    //
    if (!confirm) {
      return false;
    }
    //
    // List<_ScalarOpt> forceQueryScalarOpts = [];
    // switch (afterQuickAction) {
    //   case AfterScalarLoadExtraDataQuickAction.none:
    //     break;
    //   case AfterScalarLoadExtraDataQuickAction.update:
    //     // TODO: Xem lai.
    //     forceQueryScalarOpts = [
    //       _ScalarOpt(scalar: this),
    //     ];
    // }
    // _QShelf.forScalarQuickExtraDataLoadAction.
    _XShelf xShelf = _XShelf.forScalarQuickExtraDataLoadAction(
        scalar: this, filterInput: filterInput);
    //
    _XScalar thisXScalar = xShelf.findXScalarByName(this.name)!;
    //
    _TaskUnit taskUnit = _ScalarLoadExtraDataQuickActionTaskUnit(
      xScalar: thisXScalar,
      action: action,
      afterQuickAction: afterQuickAction,
    );
    //
    FlutterArtist._taskUnitQueue.addTaskUnit(taskUnit);
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
  Future<ScalarQueryResult> query({
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
    _XShelf xShelf = _XShelf.forScalarQuery(
      scalar: this,
      filterInput: filterInput,
    );
    await xShelf.shelf._queryShelf(xShelf: xShelf);
    //
    _XScalar xScalar = xShelf.findXScalarByName(this.name)!;
    ScalarQueryResult result = xScalar.queryResult;
    return result;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      ui.updateControlWidgets();
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void _fireScalarHidden() {
    FlutterArtist.codeFlowLogger._addEvent(
      ownerClassInstance: this,
      event: "Scalar '${getClassName(this)}' just hides all UI Components!",
      isLibCode: true,
    );
    switch (config.hiddenBehavior) {
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

  void showFilterCriteriaDialog() {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    //
    FilterCriteriaDialog.showScalarFilterCriteriaDialog(
      context: context,
      scalar: this,
    );
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
