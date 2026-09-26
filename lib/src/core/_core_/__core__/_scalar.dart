part of '../core.dart';

abstract class Scalar<
    ID extends Comparable,
    VALUE extends Identifiable<ID>,
    FILTER_INPUT extends FilterInput,
    FILTER_CRITERIA extends FilterCriteria> extends _Core {
  late final Shelf shelf;

  QueryType __lastQueryType = QueryType.realQuery;
  QueryType get lastQueryType => __lastQueryType;

  // Safe nullable parent without LateInitializationError
  Scalar? _parent;

  Scalar? get parent => _parent;

  late final debug = _ScalarDebugInfo(scalar: this);

  String? get parentScalarName => _parent?.name;
  bool get isRoot => _parent == null;

  Scalar get rootScalar => _parent == null ? this : _parent!.rootScalar;

  final List<Scalar> _childScalars;
  List<Scalar> get childScalars => List.unmodifiable(_childScalars);

  List<Scalar> get descendantScalars {
    List<Scalar> ret = [];
    for (Scalar childScalar in _childScalars) {
      ret.add(childScalar);
      ret.addAll(childScalar.descendantScalars);
    }
    return List.unmodifiable(ret);
  }

  List<Scalar> get descendantScalarsWithSameFilterModel {
    if (filterModel == null) return [];
    List<Scalar> ret = [];
    for (Scalar childScalar in _childScalars) {
      if (childScalar.filterModel != null &&
          filterModel!.name == childScalar.filterModel!.name) {
        ret.add(childScalar);
      }
      ret.addAll(childScalar.descendantScalarsWithSameFilterModel);
    }
    return ret;
  }

  List<Scalar> get ancestorScalars =>
      ascendingAncestorScalars.reversed.toList();

  List<Scalar> get lineageScalars =>
      List.unmodifiable([...ancestorScalars, this, ...descendantScalars]);

  List<Scalar> get ascendingAncestorScalars {
    List<Scalar> list = [];
    Scalar slr = this;
    while (true) {
      Scalar? p = slr.parent;
      if (p == null) break;
      list.add(p);
      slr = p;
    }
    return List.unmodifiable(list);
  }

  List<Scalar> get descendingAncestorScalars =>
      ascendingAncestorScalars.reversed.toList();

  bool isSameWith(Scalar other) {
    if (shelf.name != other.shelf.name) return false;
    return name == other.name;
  }

  bool isAncestorOf(Scalar other) {
    if (shelf.name != other.shelf.name || name == other.name) return false;
    Scalar s = other;
    while (true) {
      Scalar? p = s.parent;
      if (p == null) return false;
      if (p.name == name) return true;
      s = p;
    }
  }

  bool isDescendantOf(Scalar other) => other.isAncestorOf(this);

  final String name;
  String get _shortPathName => "${shelf.name} >> $name";
  String get pathInfo => "scalar > ${shelf.name} > $name";

  final String? registeredFilterModelName;
  final String? description;
  final ScalarConfig config;
  final ScalarEffectiveConfig effectiveConfig;

  bool __isQuerying = false;
  bool get isQuerying => __isQuerying;

  late final FilterModel<FILTER_INPUT, FILTER_CRITERIA>
      _registeredOrDefaultFilterModel;

  FilterModel<FILTER_INPUT, FILTER_CRITERIA>
      get registeredOrDefaultFilterModel => _registeredOrDefaultFilterModel;

  FilterModel<FILTER_INPUT, FILTER_CRITERIA>? get filterModel {
    if (_registeredOrDefaultFilterModel is _DefaultFilterModel) {
      return null;
    } else {
      return _registeredOrDefaultFilterModel;
    }
  }

  late final ui = _ScalarUiComponents(scalar: this);

  // ===========================================================================
  // EMBEDDED SCALAR DATA STATE & STORAGE
  // ===========================================================================

  FilterCriteriaSnapshot<FILTER_CRITERIA>? _filterCriteriaSnapshot;
  _ScalarValueWrap<ID, VALUE> __current =
      _ScalarValueWrap<ID, VALUE>(id: null, value: null);

  ScalarDataState _scalarDataState = const ScalarDataStatePending.initial();
  PageData<VALUE>? _lastQueryResult;
  ActionResultState? _lastQueryResultState;
  int _filterCriteriaChangeCount = 0;

  PageData<VALUE>? get lastQueryResult => _lastQueryResult;
  ActionResultState? get lastQueryResultState => _lastQueryResultState;
  ScalarDataState get dataState => _scalarDataState;

  FILTER_CRITERIA? get filterCriteria =>
      _filterCriteriaSnapshot?.criteriaOrNull;
  FilterCriteriaSnapshot<FILTER_CRITERIA>? get debugXFilterCriteria =>
      _filterCriteriaSnapshot;

  VALUE? get value => __current._value;
  ID? get valueId => __current._id;
  String? get parentScalarValueId => _parent?.valueId?.toString();

  bool get hasError => scalarErrorInfo != null || filterErrorInfo != null;

  ScalarErrorInfo? get scalarErrorInfo => switch (dataState) {
        ScalarDataStatePending(:final errorInfo?) => errorInfo,
        ScalarDataStateLoadedStale(:final errorInfo?) => errorInfo,
        _ => null,
      };

  ErrorInfo? get filterErrorInfo => filterModel?.errorInfo;

  _ScalarSyncSessionState<ID>? _scalarSyncSessionState;

  void _resetBlockSyncSessionState({
    required ExecutionTrace? executionTrace,
  }) {
    _scalarSyncSessionState = null;
  }

  bool _hasReactionBookmark() => _scalarSyncSessionState != null;

  bool _isMatchScalarSyncSessionState(
      _ScalarSyncSessionState? scalarSyncSessionState) {
    if (scalarSyncSessionState == null) return false;
    return scalarSyncSessionState.parentScalarValueId == parentScalarValueId &&
        scalarSyncSessionState.filterCriteria == filterCriteria;
  }

  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================

  Scalar({
    required this.name,
    required this.description,
    required ScalarConfig config,
    required String? filterModelName,
    required List<Scalar>? childScalars,
  })  : config = config.copy(),
        effectiveConfig = ScalarEffectiveConfig._fromConfig(config),
        registeredFilterModelName = filterModelName,
        _childScalars = childScalars ?? [] {
    for (Scalar childScalar in _childScalars) {
      childScalar._parent = this;
      childScalar._scalarDataState = const ScalarDataStateNone();
    }
  }

  XScalar<ID, VALUE> _createXScalar({
    required XFilterModel xFilterModel,
  }) {
    return XScalar<ID, VALUE>._(
      scalar: this,
      xFilterModel: xFilterModel,
    );
  }

  Set<Type> getDeclaredReactionDataTypes() {
    return effectiveConfig.reactions.map((r) => r.dataType).toSet();
  }

  Set<Type> getResolvedReactionDataTypes() {
    final declaredTypes = getDeclaredReactionDataTypes();
    final Set<Type> allEffectiveTypes = {...declaredTypes};

    for (var family in FlutterArtist.appConfig.projectionFamilies) {
      if (declaredTypes.any((type) => family.members.contains(type))) {
        allEffectiveTypes.addAll(family.members);
      }
    }
    return allEffectiveTypes;
  }

  bool isPendingOrStale({required bool requiresVisible}) {
    final bool visible = ui.hasVisibleViews(includeDescendants: true);
    if (requiresVisible && !visible) return false;
    return dataState.isPending || dataState.isStale;
  }

  bool hasAccumulatedEvents() {
    if (_scalarSyncSessionState == null) return false;
    return ui.hasVisibleViews(includeDescendants: true);
  }

  void _receiveEvent({
    required ExecutionTrace executionTrace,
    required EventSourceType eventSourceType,
    required List<Type> eventDataTypes,
  }) {
    if (dataState.isNone || eventDataTypes.isEmpty) return;

    final Set<Type> scalarReactionTypes = getResolvedReactionDataTypes();
    if (scalarReactionTypes.isEmpty) return;

    final bool isEffected = DataTypeEventUtils.hasIntersection(
      scalarReactionTypes,
      eventDataTypes.toSet(),
    );

    if (isEffected) {
      _updateScalarSyncSessionState(
        executionTrace: executionTrace,
        eventSourceType: eventSourceType,
        dataTypes: eventDataTypes,
      );
    }
  }

  void _updateScalarSyncSessionState({
    required ExecutionTrace executionTrace,
    required EventSourceType eventSourceType,
    required List<Type> dataTypes,
  }) {
    if (_scalarSyncSessionState == null ||
        _scalarSyncSessionState!.filterCriteria != filterCriteria ||
        _scalarSyncSessionState!.parentScalarValueId !=
            _parent?.valueId?.toString()) {
      _scalarSyncSessionState = _ScalarSyncSessionState(
        scalar: this,
        parentScalarValueId: _parent?.valueId?.toString(),
        filterCriteria: filterCriteria,
      );
    }

    _scalarSyncSessionState?.addReceivedEventInfo(
      eventSourceType: eventSourceType,
      dataTypes: dataTypes,
    );

    executionTrace.addInfo(
      codeId: "#86300",
      shortDesc: "Added ScalarReceivedEventInfo to session",
    );

    if (_scalarSyncSessionState != null) {
      final nextState = ScalarDataStateUtils.calculateNewLazyDataState(
        currentScalarDataState: dataState,
        hasParentValue: _parent != null,
        isRootScalar: isRoot,
        parentValueChanged: false,
        filterCriteriaChanged: false,
        hasIncomingEvent: true,
      );

      if (nextState != dataState) {
        _scalarDataState = nextState;
        executionTrace.addInfo(
          codeId: "#86400",
          shortDesc:
              "Transitioned Scalar dataState to $nextState due to SyncSession update",
        );
      }
    }
  }

  // ===========================================================================
  // EXECUTION UNIT: _unitLoadExtraDataQuickAction
  // ===========================================================================

  @_ExecutionUnitMethodAnnotation()
  @_ScalarLoadExtraDataQuickActionAnnotation()
  Future<bool> _unitLoadExtraDataQuickAction<DATA extends Object>({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XScalar<ID, VALUE> thisXScalar,
    required ScalarLoadExtraDataQuickActionIntent<ID, VALUE, DATA>
        executionIntent,
  }) async {
    __assertThisXScalar(thisXScalar);

    executionTrace.addInfo(
      codeId: "#40000",
      shortDesc:
          "Begin ${debugObjHtml(this)} -> ${executionUnitType.asDebugExecutionUnit()}.",
    );

    final loadResult = executionIntent.resultWrapper._setResult(
      ScalarLoadExtraDataResult(),
      objectCaller: this,
      methodName: '_unitLoadExtraDataQuickAction',
    );

    ApiResult<DATA>? result;
    try {
      executionTrace.addControllableCall(
        codeId: "#40100",
        caller: executionIntent.action,
        methodName: "performLoadExtraData",
        suffixShortDesc: "",
      );

      result = await executionIntent.action.performLoadExtraData();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName:
            '${getClassName(executionIntent.action)}.performLoadExtraData',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      loadResult._setErrorInfo(errorInfo: errorInfo);
      executionTrace.addInfo(
        codeId: "#40200",
        shortDesc:
            "The ${debugObjHtml(executionIntent.action)}.performLoadExtraData() method was called with an error!",
        errorInfo: errorInfo,
      );
      return false;
    }

    bool success = true;
    if (result != null && result.error != null) {
      success = false;

      final ErrorInfo errorInfo = _handleRestError(
        shelf: shelf,
        methodName:
            "${getClassName(executionIntent.action)}.performLoadExtraData",
        message: result.error!.errorMessage,
        errorDetails: result.error!.errorDetails,
        showSnackBar: true,
        tipDocument: null,
      );
      executionTrace.addInfo(
        codeId: "#40300",
        shortDesc:
            "The ${debugObjHtml(executionIntent.action)}.performLoadExtraData() method was called with an error!",
        errorInfo: errorInfo,
      );
    }

    DATA? extraData = result?.data;

    return await _showAfterScalarLoadExtraData(
      executionTrace: executionTrace,
      action: executionIntent.action,
      afterQuickAction: executionIntent.afterQuickAction,
      extraData: extraData,
      success: success,
    );
  }

  Future<bool> _showAfterScalarLoadExtraData<DATA extends Object>({
    required ExecutionTrace executionTrace,
    required ScalarQuickExtraDataLoadAction<DATA> action,
    required AfterScalarLoadExtraDataQuickAction afterQuickAction,
    required DATA? extraData,
    required bool success,
  }) async {
    BuildContext context = FlutterArtistCore.context;
    bool success2;
    try {
      executionTrace.addControllableCall(
        codeId: "#41000",
        caller: action,
        methodName: "onExtraDataLoaded",
        suffixShortDesc: "",
        parameters: {
          "success": success,
          "extraData": extraData,
        },
      );
      await action.onExtraDataLoaded(
        context,
        success: success,
        extraData: extraData,
      );
      success2 = true;
    } catch (e, stackTrace) {
      final errorInfo = ErrorInfo.fromError(error: e, stackTrace: stackTrace);
      executionTrace.addInfo(
        codeId: "#41300",
        shortDesc:
            "The ${debugObjHtml(action)}.onExtraDataLoaded() method was called with an error!",
        errorInfo: errorInfo,
      );
      success2 = false;
    }
    switch (afterQuickAction) {
      case AfterScalarLoadExtraDataQuickAction.none:
        break;
      case AfterScalarLoadExtraDataQuickAction.update:
        ui.refreshAllViews(withoutFilters: true);
    }
    return success2;
  }

  // ===========================================================================
  // EXECUTION UNIT: _unitClear
  // ===========================================================================

  @_ExecutionUnitMethodAnnotation()
  @_ScalarClearAnnotation()
  Future<void> _unitClear({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XScalar thisXScalar,
    required ScalarClearIntent<ID, VALUE> executionIntent,
  }) async {
    __assertThisXScalar(thisXScalar);

    executionTrace.addInfo(
      codeId: "#39000",
      shortDesc:
          "Begin ${debugObjHtml(this)} -> ${executionUnitType.asDebugExecutionUnit()}.",
    );

    executionTrace.addInfo(
      codeId: "#39100",
      shortDesc: "${debugObjHtml(this)} -> Clear data and set to pending. "
          "Clear data of child scalars and set its to none."
          "${_childScalars.isEmpty ? '\n ** No children -> Nothing to do!' : ''}",
    );

    executionIntent.resultWrapper._setResult(
      ScalarClearResult(precheck: null),
      objectCaller: this,
      methodName: '_unitClear',
    );

    __clearWithDataStateAndChildrenToNonCascade(
      thisXScalar: thisXScalar,
      scalarDataState: const ScalarDataStatePending.initial(),
      errorInFilter: false,
      resetSyncSessionState: true,
    );
  }

  // ===========================================================================
  // EXECUTION UNIT: _unitQuery
  // ===========================================================================

  @_ExecutionUnitMethodAnnotation()
  @_ScalarQueryAnnotation()
  Future<void> _unitQuery({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XScalar thisXScalar,
    required ScalarQueryIntent<ID, VALUE> executionIntent,
  }) async {
    __assertThisXScalar(thisXScalar);

    final QueryHint initialQueryHint = thisXScalar.queryHint;
    thisXScalar._setQueriedTrue();
    thisXScalar._createAndSetScalarExecutionIntentDone(lastIntentInfo: "Query");
    thisXScalar.resetExecutionHints();

    executionTrace.addInfo(
      codeId: "#12000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()}",
    );

    final executionResult = executionIntent.resultWrapper._setResult(
      ScalarQueryResult(precheck: null),
      objectCaller: this,
      methodName: '_unitQuery',
    );

    final bool provideScalarContext =
        ui.hasVisibleViews(includeDescendants: true);

    final DebugScalarSyncSessionState<ID>? currentSyncSessionState =
        _scalarSyncSessionState;

    final ScalarQueryPlan<ID> queryPlan =
        ScalarQueryStrategyResolver.resolveQueryPlan<ID>(
      scalar: this,
      syncSessionState: currentSyncSessionState,
      queryHint: initialQueryHint,
      provideScalarContext: provideScalarContext,
    );

    if (queryPlan.action == null) {
      executionTrace.addInfo(
        codeId: "#12080",
        shortDesc:
            "QueryPlan action is NULL -> Skip query execution, @dataState: $dataState, @value: ${debugObjHtml(value)}.",
      );
      return;
    }

    ScalarDataState newScalarDataState = dataState;

    final XFilterModel xFilterModel = thisXScalar.xFilterModel;
    final FilterModel filterModel = xFilterModel.filterModel;
    final FilterCriteriaSnapshot<FILTER_CRITERIA>?
        committedFilterCriteriaSnapshot =
        filterModel._committedFilterCriteriaSnapshot
            as FilterCriteriaSnapshot<FILTER_CRITERIA>?;

    if (committedFilterCriteriaSnapshot == null ||
        committedFilterCriteriaSnapshot.isError) {
      executionTrace.addInfo(
        codeId: "#12340",
        shortDesc:
            "${debugObjHtml(filterModel)} error --> clear data of ${debugObjHtml(this)} and set to error.",
      );
      __stopQueryWithFilterErrorCascade(
        thisXScalar: thisXScalar,
        scalarErrorInfo: null,
      );
      return;
    }

    committedFilterCriteriaSnapshot
        as FilterCriteriaSnapshotSuccess<FILTER_CRITERIA>;
    final bool filterCriteriaChanged = _isFilterCriteriaSnapshotChanged(
      newFilterCriteriaSnapshot: committedFilterCriteriaSnapshot,
    );

    ActionResultState queryResultState;
    ScalarErrorInfo? sclrErrorInfo;

    final performQueryMethod = ScalarErrorMethod.performQuery;
    final ID? oldValueId = __current._id;
    ID? newValueId;
    VALUE? newValue;

    try {
      __refreshQueryingState(isQuerying: true);

      executionTrace.addControllableCall(
        codeId: "#12400",
        caller: this,
        methodName: "performQuery",
        suffixShortDesc: "",
        parameters: {
          "parentScalarValue": _parent?.value,
          "filterCriteria": committedFilterCriteriaSnapshot.filterCriteria,
        },
      );

      debug._performQueryCount++;
      final ApiResult<VALUE> result = await performQuery(
        parentScalarValue: _parent?.value,
        filterCriteria: committedFilterCriteriaSnapshot.filterCriteria,
      );

      result.throwIfError();

      queryResultState = ActionResultState.success;
      newValue = result.data;
      newValueId = newValue?.id;
      _resetBlockSyncSessionState(executionTrace: executionTrace);
    } catch (e, stackTrace) {
      queryResultState = ActionResultState.fail;

      sclrErrorInfo = ScalarErrorInfo(
        scalarErrorMethod: performQueryMethod,
        error: e,
        errorStackTrace: stackTrace,
      );

      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: performQueryMethod.name,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.scalarPerformQuery,
      );
      executionResult._setErrorInfo(errorInfo: errorInfo);
      thisXScalar.queryResult._setErrorInfo(errorInfo: errorInfo);
    } finally {
      __refreshQueryingState(isQuerying: false);
    }

    final calculationInput = ScalarQueryCalculatorInput(
      queryResultState: queryResultState,
      scalarErrorOrigin: ScalarErrorOrigin.directFetch,
      scalarErrorInfo: sclrErrorInfo,
      currentDataState: dataState,
      filterCriteriaChanged: filterCriteriaChanged,
    );
    final ScalarQueryCalculatorResult calculationResult =
        ScalarQueryStateCalculator.calculate(calculationInput);

    newScalarDataState = calculationResult.newScalarDataState;

    if (sclrErrorInfo != null) {
      _updateStateAfterQueryError(newScalarDataState: newScalarDataState);
      final List<XScalar> descendantXScalars =
          thisXScalar.getDescendantXScalars(sameFilterOnly: true);

      __stopDescendantQueryWithError(
        descendantXScalars: descendantXScalars,
        scalarErrorOrigin: ScalarErrorOrigin.directFetch.toCascadedOrigin(),
      );
      return;
    }

    newScalarDataState = const ScalarDataStateLoadedFresh();
    __setQueryDataWithState(
      thisXScalar: thisXScalar,
      xFilterCriteria: committedFilterCriteriaSnapshot,
      dataState: newScalarDataState,
      valueId: newValueId,
      value: newValue,
      queryResultState: ActionResultState.success,
    );

    if (newValue == null) {
      __clearAllChildrenScalarsToNone(thisXScalar: thisXScalar);
      return;
    }

    if (filterCriteriaChanged || newValueId != oldValueId) {
      __clearAllChildrenScalarsToPending(thisXScalar: thisXScalar);
    }
  }

  // ===========================================================================
  // EMBEDDED INTERNAL DATA MANIPULATION
  // ===========================================================================

  void _updateStateAfterQueryError({
    required ScalarDataState newScalarDataState,
  }) {
    _lastQueryResultState = ActionResultState.fail;
    _scalarDataState = newScalarDataState;
  }

  void _clearWithDataState({required ScalarDataState scalarDataState}) {
    _scalarDataState = scalarDataState;
    __current = _ScalarValueWrap<ID, VALUE>(id: null, value: null);
    _filterCriteriaSnapshot = null;
  }

  bool _isFilterCriteriaSnapshotChanged({
    required FilterCriteriaSnapshot<FILTER_CRITERIA> newFilterCriteriaSnapshot,
  }) {
    return newFilterCriteriaSnapshot != _filterCriteriaSnapshot;
  }

  void _setScalarDataState({
    required ScalarDataState newScalarDataState,
  }) {
    _scalarDataState = newScalarDataState;
  }

  void _clearValueWithDataState({
    required ScalarDataState scalarDataState,
    required bool errorInFilter,
    required bool resetSyncSessionState,
  }) {
    _scalarDataState = scalarDataState;
    if (resetSyncSessionState) {
      _resetBlockSyncSessionState(executionTrace: null);
    }
    if (hasError) {
      _lastQueryResultState = ActionResultState.fail;
      if (errorInFilter) {
        __setNewFilterCriteriaSnapshot(newXFilterCriteria: null);
      }
    }
    __current = _ScalarValueWrap<ID, VALUE>(id: null, value: null);
  }

  void _updateData({
    required FilterCriteriaSnapshot<FILTER_CRITERIA>? filterCriteriaSnapshot,
    required ID? valueId,
    required VALUE? value,
    required ScalarDataState dataState,
    required ActionResultState queryResultState,
  }) {
    __setNewFilterCriteriaSnapshot(newXFilterCriteria: filterCriteriaSnapshot);
    __current = _ScalarValueWrap<ID, VALUE>(id: valueId, value: value);
    _scalarDataState = dataState;
    _lastQueryResultState = queryResultState;
  }

  void __setNewFilterCriteriaSnapshot({
    required FilterCriteriaSnapshot<FILTER_CRITERIA>? newXFilterCriteria,
  }) {
    final bool changed = _filterCriteriaSnapshot != newXFilterCriteria;
    _filterCriteriaSnapshot = newXFilterCriteria;
    if (changed) {
      _filterCriteriaChangeCount++;
    }
  }

  void __stopQueryWithFilterErrorCascade({
    required XScalar thisXScalar,
    required ScalarErrorInfo? scalarErrorInfo,
  }) {
    __assertThisXScalar(thisXScalar);
    thisXScalar.queryResult._setFilterError();

    final scalarErrorOrigin = ScalarErrorOrigin.filterModel;
    const fallbackDilemmaStrategy = FallbackDilemmaStrategy.preserveStableCache;

    final ScalarDataState newScalarDataState =
        ScalarQueryStateCalculator.calculateDataStateOnError(
      currentDataState: dataState,
      scalarErrorOrigin: scalarErrorOrigin,
      scalarErrorInfo: scalarErrorInfo,
      dilemmaStrategy: fallbackDilemmaStrategy,
    );

    _lastQueryResultState = ActionResultState.fail;
    _scalarDataState = newScalarDataState;

    final List<XScalar> descendantXScalars =
        thisXScalar.getDescendantXScalars(sameFilterOnly: true);

    __stopDescendantQueryWithError(
      descendantXScalars: descendantXScalars,
      scalarErrorOrigin: scalarErrorOrigin.toCascadedOrigin(),
    );
  }

  void __stopDescendantQueryWithError({
    required List<XScalar> descendantXScalars,
    required ScalarErrorOrigin scalarErrorOrigin,
  }) {
    const fallbackDilemmaStrategy = FallbackDilemmaStrategy.preserveStableCache;

    for (final descendantXScalar in descendantXScalars) {
      final descendantScalar = descendantXScalar.scalar;
      final descendantState =
          ScalarQueryStateCalculator.calculateDataStateOnError(
        currentDataState: descendantScalar.dataState,
        scalarErrorOrigin: scalarErrorOrigin,
        scalarErrorInfo: null,
        dilemmaStrategy: fallbackDilemmaStrategy,
      );
      descendantXScalar._queried = true;
      descendantScalar._lastQueryResultState = ActionResultState.fail;
      descendantScalar._setScalarDataState(
        newScalarDataState: descendantState,
      );
    }
  }

  void __setQueryDataWithState({
    required XScalar thisXScalar,
    required FilterCriteriaSnapshot<FILTER_CRITERIA>? xFilterCriteria,
    required ScalarDataState dataState,
    required ID? valueId,
    required VALUE? value,
    required ActionResultState queryResultState,
  }) {
    __assertThisXScalar(thisXScalar);
    _updateData(
      filterCriteriaSnapshot: xFilterCriteria,
      dataState: dataState,
      valueId: valueId,
      value: value,
      queryResultState: queryResultState,
    );
  }

  void __clearAllChildrenScalarsToNone({required XScalar thisXScalar}) {
    __assertThisXScalar(thisXScalar);
    for (var childXScalar in thisXScalar.childXScalars) {
      childXScalar.scalar.__clearWithDataStateAndChildrenToNonCascade(
        thisXScalar: childXScalar,
        scalarDataState: const ScalarDataStateNone(),
        errorInFilter: false,
        resetSyncSessionState: true,
      );
    }
  }

  void __clearAllChildrenScalarsToPending({required XScalar thisXScalar}) {
    __assertThisXScalar(thisXScalar);
    for (var childXScalar in thisXScalar.childXScalars) {
      childXScalar.scalar.__clearWithDataStateAndChildrenToNonCascade(
        thisXScalar: childXScalar,
        scalarDataState: const ScalarDataStatePending.initial(),
        errorInFilter: false,
        resetSyncSessionState: true,
      );
    }
  }

  void __clearWithDataStateAndChildrenToNonCascade({
    required XScalar thisXScalar,
    required ScalarDataState scalarDataState,
    required bool errorInFilter,
    required bool resetSyncSessionState,
  }) {
    __assertThisXScalar(thisXScalar);
    __clearValueWithDataState(
      thisXScalar: thisXScalar,
      scalarDataState: scalarDataState,
      errorInFilter: errorInFilter,
      resetSyncSessionState: resetSyncSessionState,
    );

    for (var childXScalar in thisXScalar.childXScalars) {
      childXScalar.scalar.__clearWithDataStateAndChildrenToNonCascade(
        thisXScalar: childXScalar,
        scalarDataState: const ScalarDataStateNone(),
        errorInFilter: false,
        resetSyncSessionState: true,
      );
    }
  }

  void __clearValueWithDataState({
    required XScalar thisXScalar,
    required ScalarDataState scalarDataState,
    required bool errorInFilter,
    required bool resetSyncSessionState,
  }) {
    __assertThisXScalar(thisXScalar);
    _clearValueWithDataState(
      scalarDataState: scalarDataState,
      errorInFilter: errorInFilter,
      resetSyncSessionState: resetSyncSessionState,
    );
  }

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      ui.refreshControlBars();
    } catch (_) {}
  }

  void _broadcastScalarHidden() {
    switch (effectiveConfig.onHideAction) {
      case ScalarHiddenAction.none:
        break;
      case ScalarHiddenAction.clear:
        break;
    }
  }

  bool isQueryAllowed() => true;

  bool canShowFilterCriteria() {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    return filterModel != null &&
        loggedInUser != null &&
        loggedInUser.isSystemUser;
  }

  @_PrecheckMethod()
  Actionable<ScalarQueryPrecheck> canQuery({bool checkAllow = true}) {
    return __canQuery(checkBusy: true, checkAllow: checkAllow);
  }

  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isQueryAllowed() {
    try {
      bool allow = isQueryAllowed();
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        errorInfo: ErrorInfo.fromError(error: e, stackTrace: stackTrace),
      );
    }
  }

  @_PrecheckPrivateMethod()
  Actionable<ScalarQueryPrecheck> __canQuery({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<ScalarQueryPrecheck>.no(
          errCode: ScalarQueryPrecheck.busy);
    }
    if (checkAllow) {
      CheckAllowResult result = __isQueryAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<ScalarQueryPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<ScalarQueryPrecheck>.no(
            errCode: ScalarQueryPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<ScalarQueryPrecheck>.no(
            errCode: ScalarQueryPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    return Actionable<ScalarQueryPrecheck>.yes();
  }

  @_PrecheckPrivateMethod()
  Actionable<ScalarClearPrecheck> __canClearScalar({required bool checkBusy}) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<ScalarClearPrecheck>.no(
        errCode: ScalarClearPrecheck.busy,
      );
    }
    return Actionable<ScalarClearPrecheck>.yes();
  }

  Future<void> showDebugFilterCriteriaViewerDialog() async {
    BuildContext context = FlutterArtistCore.context;
    await DebugViewerDialog.openDebugFilterCriteriaInspector(
      context: context,
      locationInfo: '',
      filterModel: registeredOrDefaultFilterModel,
    );
  }

  @_RootMethodAnnotation()
  Future<void> showScalarErrorViewerDialog(BuildContext context) async {
    if (!hasError) return;
    final ScalarErrorInfo? activeScalarErrorInfo = scalarErrorInfo;
    if (activeScalarErrorInfo != null) {
      await ScalarErrorViewerDialog.show(
        context: context,
        scalarErrorInfo: activeScalarErrorInfo,
      );
      return;
    }
    final ErrorInfo? errorInfo = filterErrorInfo;
    if (errorInfo != null) {
      await ErrorViewerDialog.show(context: context, errorInfo: errorInfo);
    }
  }

  // ===========================================================================
  // GENERICS TYPES:
  // ===========================================================================

  Type getValueType() => VALUE;
  Type getFilterInputType() => FILTER_INPUT;
  Type getFilterCriteriaType() => FILTER_CRITERIA;

  // ===========================================================================
  // ABSTRACT CONTRACTS
  // ===========================================================================

  @_AbstractMethodAnnotation()
  Future<ApiResult<VALUE>> performQuery({
    required Object? parentScalarValue,
    required FILTER_CRITERIA filterCriteria,
  });

  @_RootMethodAnnotation()
  @_ScalarQueryAnnotation()
  Future<ScalarQueryResult> query({FILTER_INPUT? filterInput}) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "query",
      parameters: {"filterInput": filterInput},
      isLibMethod: true,
    );
    final XShelf xShelf = _XShelfScalarQuery(
      scalar: this,
      filterInput: filterInput,
    );
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();

    XScalar xScalar = xShelf.findXScalarByName(name)!;
    return xScalar.queryResult;
  }

  @_RootMethodAnnotation()
  @_ScalarClearAnnotation()
  Future<ScalarClearResult> clear() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "clear",
      parameters: {},
      isLibMethod: true,
    );
    Actionable<ScalarClearPrecheck> actionable =
        __canClearScalar(checkBusy: true);
    if (!actionable.yes) {
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return ScalarClearResult(precheck: actionable.errCode);
    }
    final XShelf xShelf = _XShelfScalarClear(scalar: this);
    final XScalar thisXScalar = xShelf.findXScalarByName(name)!;
    final executionIntent =
        thisXScalar._createAndSetScalarExecutionIntentClear();
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionIntent.result;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXScalar(XScalar thisXScalar) {
    if (thisXScalar.scalar != this || thisXScalar.name != name) {
      throw "Error Assert scalar: ${thisXScalar.scalar} - $this";
    }
  }
}
