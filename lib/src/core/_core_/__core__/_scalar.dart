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

  late final Scalar? parent;

  String? get parentScalarName => parent?.name;

  bool get isRoot => parent == null;

  Scalar get rootScalar {
    if (parent == null) {
      return this;
    }
    return parent!.rootScalar;
  }

  final List<Scalar> _childScalars;

  List<Scalar> get childScalars => [..._childScalars];

  List<Scalar> get descendantScalars {
    List<Scalar> ret = [];
    for (Scalar childScalar in _childScalars) {
      ret.add(childScalar);
      ret.addAll(childScalar.descendantScalars);
    }
    return ret;
  }

  List<Scalar> get descendantScalarsWithSameFilterModel {
    if (this.filterModel == null) {
      return [];
    }
    List<Scalar> ret = [];
    for (Scalar childScalar in _childScalars) {
      if (childScalar.filterModel != null) {
        if (this.filterModel!.name == childScalar.filterModel!.name) {
          ret.add(childScalar);
        }
      }
      ret.addAll(childScalar.descendantScalarsWithSameFilterModel);
    }
    return ret;
  }

  List<Scalar> get ancestorScalars {
    return ascendingAncestorScalars.reversed.toList();
  }

  ///
  /// Ancestor Scalars + this Scalar + descendant Scalars.
  ///
  List<Scalar> get lineageScalars {
    return <Scalar>[...ancestorScalars, this, ...descendantScalars];
  }

  ///
  /// Ascending ancestor scalars.
  ///
  List<Scalar> get ascendingAncestorScalars {
    List<Scalar> list = [];
    Scalar slr = this;
    while (true) {
      Scalar? p = slr.parent;
      if (p == null) {
        break;
      }
      list.add(p);
      slr = p;
    }
    return list;
  }

  ///
  /// Descending ancestor scalars.
  ///
  List<Scalar> get descendingAncestorScalars {
    return ascendingAncestorScalars.reversed.toList();
  }

  bool isSameWith(Scalar other) {
    if (this.shelf.name != other.shelf.name) {
      return false;
    }
    if (this.name == other.name) {
      return true;
    }
    return false;
  }

  bool isAncestorOf(Scalar other) {
    if (this.shelf.name != other.shelf.name) {
      return false;
    }
    if (this.name == other.name) {
      return false;
    }
    Scalar s = other;
    while (true) {
      Scalar? p = s.parent;
      if (p == null) {
        return false;
      }
      if (p.name == this.name) {
        return true;
      }
      s = p;
    }
  }

  bool isDescendantOf(Scalar other) {
    return other.isAncestorOf(this);
  }

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

  late final _internalEffectedShelfMembers = EffectedShelfMembers.ofScalar(
    eventScalar: this,
  );

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

  DataState get dataState => __scalarData._scalarDataState;

  FILTER_CRITERIA? get filterCriteria => __scalarData._filterCriteria;

  VALUE? get value => __scalarData.current._value;

  void _setToPending() {
    __scalarData._clearValueWithDataState(
      scalarDataState: DataState.pending,
      errorInFilter: false,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  _ScalarReQryCon? _scalarReQryCon;

  bool _hasReactionBookmark() {
    return _scalarReQryCon != null;
  }

  bool _isMatchScalarReQryCon(_ScalarReQryCon? scalarReQryCon) {
    if (scalarReQryCon == null) {
      return false;
    }
    return scalarReQryCon.parentScalarValueId == parentScalarValueId &&
        scalarReQryCon.filterCriteria == filterCriteria;
  }

  // ***************************************************************************
  // ***************************************************************************

  Scalar({
    required this.name,
    required this.description,
    required ScalarConfig config,
    required String? filterModelName,
    required List<Scalar>? childScalars,
  })  : config = config.copy(),
        registerFilterModelName = filterModelName,
        _childScalars = childScalars ?? [] {
    for (Scalar childScalar in _childScalars) {
      childScalar.parent = this;
    }
  }

  // ***************************************************************************

  XScalar<VALUE> _createXScalar({
    required XFilterModel xFilterModel,
  }) {
    return XScalar<VALUE>._(
      scalar: this,
      xFilterModel: xFilterModel,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  List<Event> getOutsideDataTypesToListen() {
    final List<Event> list = [];
    //
    list.addAll(config.executeScalarLevelReactionToEvents);
    //
    return list.toSet().toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_ScalarQueryAnnotation()
  Future<void> _unitQuery({
    required XScalar thisXScalar,
  }) async {
    __assertThisXScalar(thisXScalar);
    //
    bool hasActiveUI = ui.hasActiveUIComponent();
    QryHint queryHint = thisXScalar.queryHint;

    if (queryHint != QryHint.force) {
      if (this.dataState != DataState.ready && hasActiveUI) {
        queryHint = QryHint.force;
      }
    }

    if (queryHint == QryHint.none) {
      print("        ~~~~~~~> IGNORED --> queryHint: $queryHint - [$name]");
      //
      if (this.dataState == DataState.ready && this.value != null) {
        for (XScalar childXScalar in thisXScalar.childXScalars) {
          thisXScalar.xShelf._addTaskUnit(
            taskUnit: _ScalarQueryTaskUnit(
              xScalar: childXScalar,
            ),
          );
        }
      }
      return;
    } else if (queryHint == QryHint.markAsPending) {
      print("        ~~~~~~~> PENDING --> queryHint: $queryHint - [$name]");
      this.__clearWithDataStateAndChildrenToNonCascade(
        thisXScalar: thisXScalar,
        scalarDataState: DataState.pending,
        errorInFilter: false,
      );
      thisXScalar.setReQueryDone();
      return;
    }
    //
    // this.dataState != DataState.ready || thisXScalar.queryHint
    //
    DataState newScalarDataState = this.dataState;
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
      final XFilterModel xFilterModel = thisXScalar.xFilterModel;
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
      // __clearWithDataState(
      //   thisXScalar: thisXScalar,
      //   scalarDataState: DataState.error,
      // );
      // thisXScalar.queryResult._setFilterError();

      // Set Scalar to error cascade.
      this.__clearWithDataStateAndChildrenToNonCascade(
        thisXScalar: thisXScalar,
        scalarDataState: DataState.error,
        errorInFilter: true,
      );
      thisXScalar.queryResult._setFilterError();
      return;
    }
    //
    // Ready FilterCriteria:
    //
    bool xCriteriaChanged = __scalarData._isXCriteriaChanged(
      newFilterCriteria: filterCriteriaOfFilterModel,
    );
    //
    final callApiQueryMethod = ScalarErrorMethod.callApiQuery;
    bool isQueryError = false;
    final String? oldValueId = __scalarData.current._id;
    String? valueId;
    VALUE? value;
    try {
      __clearScalarError();
      __refreshQueryingState(isQuerying: true);
      //
      __callApiQueryCount++;
      ApiResult<VALUE> result = await callApiQuery(
        parentScalarValue: parent?.value,
        filterCriteria: filterCriteriaOfFilterModel,
      );
      //
      // Throw ApiError:
      result.throwIfError();
      //
      // Query DONE!
      //
      thisXScalar.setReQueryDone();
      value = result.data;
      valueId = value == null
          ? null
          : toValueId(
              filterCriteria: filterCriteriaOfFilterModel,
              value: value,
            );
    } catch (e, stackTrace) {
      isQueryError = true;
      //
      final scalarErrorInfo = ScalarErrorInfo(
        scalarDataState: DataState.error,
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
    // Test Cases: [12a], [12b].
    if (isQueryError) {
      newScalarDataState = DataState.error;
      __setQueryDataWithState(
        thisXScalar: thisXScalar,
        filterCriteria: null,
        dataState: newScalarDataState,
        valueId: null,
        value: null,
        queryResultState: ActionResultState.fail,
      );
      __clearWithDataStateAndChildrenToNonCascade(
        thisXScalar: thisXScalar,
        scalarDataState: newScalarDataState,
        errorInFilter: false,
      );
      return;
    }
    // No ERROR!
    newScalarDataState = DataState.ready;
    __setQueryDataWithState(
      thisXScalar: thisXScalar,
      filterCriteria: filterCriteriaOfFilterModel,
      dataState: newScalarDataState,
      valueId: valueId,
      value: value,
      queryResultState: ActionResultState.success,
    );
    //
    if (value == null) {
      __clearAllChildrenScalarsToNone(thisXScalar: thisXScalar);
      return;
    }
    //
    if (xCriteriaChanged || valueId != oldValueId) {
      this.__clearAllChildrenScalarsToPending(
        thisXScalar: thisXScalar,
      );
    }
    //
    for (XScalar childXScalar in thisXScalar.childXScalars) {
      thisXScalar.xShelf._addTaskUnit(
        taskUnit: _ScalarQueryTaskUnit(
          xScalar: childXScalar,
        ),
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_ScalarClearanceAnnotation()
  Future<void> _unitClearance({required XScalar thisXScalar}) async {
    __assertThisXScalar(thisXScalar);
    //
    __clearWithDataStateAndChildrenToNonCascade(
      thisXScalar: thisXScalar,
      scalarDataState: DataState.pending,
      errorInFilter: false,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_ScalarLoadExtraDataQuickActionAnnotation()
  Future<bool> _unitLoadExtraDataQuickAction<DATA extends Object>({
    required XScalar thisXScalar,
    required ScalarQuickExtraDataLoadAction<DATA> action,
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
    required ScalarQuickExtraDataLoadAction<DATA> action,
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
    if (dataState != DataState.error ||
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

  void __clearWithDataStateAndChildrenToNonCascade({
    required XScalar thisXScalar,
    required DataState scalarDataState,
    required bool errorInFilter,
  }) {
    __assertThisXScalar(thisXScalar);
    //
    __clearValueWithDataState(
      thisXScalar: thisXScalar,
      scalarDataState: scalarDataState,
      errorInFilter: errorInFilter,
    );

    for (var childXScalar in thisXScalar.childXScalars) {
      childXScalar.scalar.__clearWithDataStateAndChildrenToNonCascade(
        thisXScalar: childXScalar,
        scalarDataState: DataState.none,
        errorInFilter: false,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setQueryDataWithState({
    required XScalar thisXScalar,
    required FILTER_CRITERIA? filterCriteria,
    required DataState dataState,
    required String? valueId,
    required VALUE? value,
    required ActionResultState queryResultState,
  }) {
    __assertThisXScalar(thisXScalar);
    //
    __scalarData._updateFrom(
      filterCriteria: filterCriteria,
      dataState: dataState,
      valueId: valueId,
      value: value,
      queryResultState: queryResultState,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearAllChildrenScalarsToNone({
    required XScalar thisXScalar,
  }) {
    __assertThisXScalar(thisXScalar);
    //
    for (var childXScalar in thisXScalar.childXScalars) {
      childXScalar.scalar.__clearWithDataStateAndChildrenToNonCascade(
        thisXScalar: childXScalar,
        scalarDataState: DataState.none,
        errorInFilter: false,
      );
    }
  }

  void __clearAllChildrenScalarsToPending({
    required XScalar thisXScalar,
  }) {
    __assertThisXScalar(thisXScalar);
    //
    for (var childXScalar in thisXScalar.childXScalars) {
      childXScalar.scalar.__clearWithDataStateAndChildrenToNonCascade(
        thisXScalar: childXScalar,
        scalarDataState: DataState.pending,
        errorInFilter: false,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearWithDataState({
    required XScalar thisXScalar,
    required DataState scalarDataState,
  }) {
    __assertThisXScalar(thisXScalar);
    //
    __scalarData._clearWithDataState(
      scalarDataState: scalarDataState,
    );
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

  String get valueId {
    return ""; // TODO: Hardcode!.
  }

  String? get parentScalarValueId {
    return parent?.valueId;
  }

  // ***************************************************************************
  // ***************************************************************************

  String toValueId({
    required FILTER_CRITERIA filterCriteria,
    required VALUE value,
  }) {
    return "";
  }

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<VALUE>> callApiQuery({
    required Object? parentScalarValue,
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

  @_RootMethodAnnotation()
  @_ScalarLoadExtraDataQuickActionAnnotation()
  Future<bool> executeQuickLoadExtraDataAction<DATA extends Object>({
    FILTER_INPUT? filterInput,
    required ActionConfirmationType actionConfirmationType,
    required ScalarQuickExtraDataLoadAction<DATA> action,
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
    //
    final XShelf xShelf = _XShelfScalarQuickExtraDataLoadAction(
      scalar: this,
      filterInput: filterInput,
    );
    //
    final XScalar thisXScalar = xShelf.findXScalarByName(this.name)!;
    //
    _STaskUnit taskUnit = _ScalarLoadExtraDataQuickActionTaskUnit(
      xScalar: thisXScalar,
      action: action,
      afterQuickAction: afterQuickAction,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXShelf(xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
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
    final XShelf xShelf = _XShelfScalarQuery(
      scalar: this,
      filterInput: filterInput,
    );
    //
    xShelf._initQueryTasks();
    FlutterArtist._rootQueue._addXShelf(xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    XScalar xScalar = xShelf.findXScalarByName(this.name)!;
    ScalarQueryResult result = xScalar.queryResult;
    return result;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Clear and set block to "Pending State".
  ///
  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_ScalarClearanceAnnotation()
  Future<ScalarClearanceResult> clear({Function()? navigate}) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "clear",
      parameters: {},
    );
    // @Same-Code-Precheck-01
    Actionable<ScalarClearancePrecheck> actionable = __canClearScalar(
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
      return ScalarClearanceResult(
        precheck: actionable.errCode,
      );
    }
    //
    final XShelf xShelf = _XShelfScalarClearance(scalar: this);

    final XScalar thisXScalar = xShelf.findXScalarByName(name)!;
    final _ResultedSTaskUnit taskUnit = _ScalarClearanceTaskUnit(
      xScalar: thisXScalar,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXShelf(xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    // _executeNavigation(navigate: navigate); // ????
    //
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearValueWithDataState({
    required XScalar thisXScalar,
    required DataState scalarDataState,
    required bool errorInFilter,
  }) {
    __assertThisXScalar(thisXScalar);
    //
    __scalarData._clearValueWithDataState(
      scalarDataState: scalarDataState,
      errorInFilter: errorInFilter,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      ui.updateControlBarWidgets();
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

  @_PrecheckPrivateMethod()
  Actionable<ScalarClearancePrecheck> __canClearScalar({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<ScalarClearancePrecheck>.no(
        errCode: ScalarClearancePrecheck.busy,
      );
    }
    // bool hasActiveUI = ui.hasActiveUIComponent(alsoCheckChildren: true);
    // if (hasActiveUI) {
    //   return Actionable<ScalarClearancePrecheck>.no(
    //     errCode: ScalarClearancePrecheck.hasActiveUI,
    //   );
    // }
    return Actionable<ScalarClearancePrecheck>.yes();
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

  void __assertThisXScalar(XScalar thisXScalar) {
    if (thisXScalar.scalar != this || thisXScalar.name != name) {
      String message = "Error Assert scalar: ${thisXScalar.scalar} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
