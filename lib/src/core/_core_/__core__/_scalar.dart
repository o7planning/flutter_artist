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
    ID extends Comparable,
    VALUE extends Identifiable<ID>,
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria // EmptyFilterCriteria
    > extends _Core {
  late final Shelf shelf;

  PageData<VALUE>? get lastQueryResult => __scalarData._lastQueryResult;

  ActionResultState? get lastQueryResultState =>
      __scalarData._lastQueryResultState;

  QueryType __lastQueryType = QueryType.realQuery;

  QueryType get lastQueryType => __lastQueryType;

  late final Scalar? parent;

  late final _ScalarDebugInfo debug = _ScalarDebugInfo(scalar: this);

  String? get parentScalarName => parent?.name;

  bool get isRoot => parent == null;

  Scalar get rootScalar {
    if (parent == null) {
      return this;
    }
    return parent!.rootScalar;
  }

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
    return List.unmodifiable([...ancestorScalars, this, ...descendantScalars]);
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
    return List.unmodifiable(list);
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

  ///
  /// FilterModel Name registered in [Shelf.defineShelfStructure()] method.
  ///
  final String? registeredFilterModelName;

  final String? description;

  final ScalarConfig config;

  final ScalarEffectiveConfig effectiveConfig;

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
  /// Returns a FilterModel declared in the [Shelf.defineShelfStructure()] method.
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
      _ScalarData<ID, VALUE, FILTER_INPUT, FILTER_CRITERIA>(this);

  late final ui = _ScalarUiComponents(scalar: this);

  // ***************************************************************************
  // ***************************************************************************

  /// Indicates whether the scalar or its underlying filter model currently has an active error.
  bool get hasError {
    return scalarErrorInfo != null || filterErrorInfo != null;
  }

  ScalarErrorInfo? get scalarErrorInfo {
    return switch (dataState) {
      ScalarDataStatePending(:final errorInfo?) => errorInfo,
      ScalarDataStateLoadedStale(:final errorInfo?) => errorInfo,
      _ => null,
    };
  }

  ErrorInfo? get filterErrorInfo {
    return filterModel?.errorInfo;
  }

  ScalarDataState get dataState => __scalarData._scalarDataState;

  FILTER_CRITERIA? get filterCriteria =>
      __scalarData._filterCriteriaMappedValue?.filterCriteria;

  FilterCriteriaMappedValue<FILTER_CRITERIA>? get debugXFilterCriteria =>
      __scalarData._filterCriteriaMappedValue;

  VALUE? get value => __scalarData.current._value;

  void _resetSyncSessionState({
    required ExecutionTrace? executionTrace,
  }) {
    _scalarSyncSessionState = null;
  }

  _ScalarSyncSessionState<ID>? _scalarSyncSessionState;

  bool _hasReactionBookmark() {
    return _scalarSyncSessionState != null;
  }

  bool _isMatchScalarReQryCon(_ScalarSyncSessionState? scalarReQryCon) {
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
        effectiveConfig = ScalarEffectiveConfig._fromConfig(config),
        registeredFilterModelName = filterModelName,
        _childScalars = childScalars ?? [] {
    for (Scalar childScalar in _childScalars) {
      childScalar.parent = this;
    }
  }

  // ***************************************************************************

  XScalar<ID, VALUE> _createXScalar({
    required XFilterModel xFilterModel,
  }) {
    return XScalar<ID, VALUE>._(
      scalar: this,
      xFilterModel: xFilterModel,
    );
  }

  // ***************************************************************************

  /// Checks if this Block exposes or is associated with the given [type].
  /// All comments are in English for global users to read.
  bool _exposesDataType(Type type) {
    // 1. Check against the core data types of the Block
    if (type == VALUE) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Returns the data types explicitly declared in the configuration
  /// that this scalar should react to.
  Set<Type> getDeclaredReactionDataTypes() {
    return effectiveConfig.reactions.map((r) => r.dataType).toSet();
  }

  /// Resolves and returns all data types—including those within the same
  /// [ProjectionFamily]—that will actually trigger a reaction in this scalar.
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

  // ***************************************************************************
  // ***************************************************************************

  bool isPendingOrStale({required bool requiresVisible}) {
    final bool visible = ui.hasActiveUiComponent(alsoCheckChildren: true);
    if (requiresVisible) {
      if (!visible) {
        return false;
      }
    }
    return dataState.isPending || dataState.isStale;
  }

  // TODO: Rename (+ `Visible` in name)
  bool hasAccumulatedEvents() {
    if (_scalarSyncSessionState == null) {
      return false;
    }
    return ui.hasActiveUiComponent(alsoCheckChildren: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Entry point called when this Scalar receives an event dispatched from internal/external sources.
  void _receiveEvent({
    required ExecutionTrace executionTrace,
    required EventSourceType eventSourceType,
    required List<Type> eventDataTypes,
  }) {
    if (dataState.isNone) {
      return;
    }
    if (eventDataTypes.isEmpty) {
      return;
    }

    final Set<Type> scalarReactionTypes = getResolvedReactionDataTypes();

    if (scalarReactionTypes.isEmpty) {
      print("@TEMP scalarReactionTypes is null --> Ignore..");
      return;
    }

    final bool isEffected = eventDataTypes.isNotEmpty &&
        DataTypeEventUtils.hasIntersection(
          scalarReactionTypes,
          eventDataTypes.toSet(),
        );

    if (isEffected) {
      _updateSyncSessionState(
        executionTrace: executionTrace,
        eventSourceType: eventSourceType,
        dataTypes: eventDataTypes,
      );
    }
  }

  /// Manages session instantiation, appends the received event info, and recalculates [_dataState].
  void _updateSyncSessionState({
    required ExecutionTrace executionTrace,
    required EventSourceType eventSourceType,
    required List<Type> dataTypes,
  }) {
    executionTrace._addTraceStep(
      codeId: "#86000",
      shortDesc: "Calling Scalar._updateSyncSessionState()",
      traceStepType: TraceStepType.nonControllableCalling,
    );

    print("########## - 1: _updateSyncSessionState");

    // Initialize or reset session if boundary constraints (filter criteria or parent context) shifted
    if (_scalarSyncSessionState == null ||
        _scalarSyncSessionState!.filterCriteria != filterCriteria ||
        _scalarSyncSessionState!.parentScalarValueId != parent?.valueId) {
      print("########## - 2: _updateSyncSessionState");

      _scalarSyncSessionState = _ScalarSyncSessionState(
        scalar: this,
        parentScalarValueId: parent?.valueId,
        filterCriteria: filterCriteria,
      );
    }

    print(
        "########## - 3: _scalarSyncSessionState: $_scalarSyncSessionState, dataState: $dataState");

    // Append received event metadata
    _scalarSyncSessionState?.addReceivedEventInfo(
      eventSourceType: eventSourceType,
      dataTypes: dataTypes,
    );

    executionTrace._addTraceStep(
      codeId: "#86300",
      shortDesc: "Added ScalarReceivedEventInfo to session",
    );

    // Recalculate ScalarDataState upon incoming event invalidation
    if (_scalarSyncSessionState != null) {
      final nextState =
          _scalarSyncSessionState!.calculateNextDataState(dataState);
      print("########## - 4: nextState: $nextState");

      // Test Case: [84b].
      if (nextState != dataState) {
        __scalarData._scalarDataState = nextState;
        print(
            "########## - 5: __scalarData._scalarDataState: ${__scalarData._scalarDataState}");
        executionTrace._addTraceStep(
          codeId: "#86400",
          shortDesc:
              "Transitioned Scalar dataState to $nextState due to SyncSession update",
        );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_ScalarQueryAnnotation()
  Future<void> _unitQuery({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XScalar thisXScalar,
  }) async {
    __assertThisXScalar(thisXScalar);
    //
    executionTrace._addTraceStep(
      codeId: "#12000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()}",
      traceStepType: TraceStepType.debug,
    );
    //
    bool provideScalarContext =
        ui.hasActiveUiComponent(alsoCheckChildren: true);
    //
    executionTrace._addTraceStep(
      codeId: "#12020",
      shortDesc: "${debugObjHtml(this)} has UIX Visible? $provideScalarContext",
    );
    //
    QryHint queryHint = thisXScalar.queryHint;

    if (queryHint != QryHint.force) {
      if (provideScalarContext && (dataState.isPending || dataState.isStale)) {
        queryHint = QryHint.force;
      }
    }
    executionTrace._addTraceStep(
      codeId: "#12040",
      shortDesc: "Calculated: @queryHint: $queryHint.",
    );

    final DebugScalarSyncSessionState<ID>? currentSyncSessionState =
        _scalarSyncSessionState;

    final ScalarQueryPlan<ID> queryPlan =
        ScalarQueryStrategyResolver.resolveQueryPlan<ID>(
      scalar: this,
      syncSessionState: currentSyncSessionState,
    );

    print("&&&&&&&&&&&&&&& Scalar queryHint: $queryHint");

    if (queryHint == QryHint.none) {
      executionTrace._addTraceStep(
        codeId: "#12080",
        shortDesc:
            "@queryHint: $queryHint, @dataState: $dataState, @value: ${debugObjHtml(this.value)}.",
      );
      //
      if (dataState.isLoaded && this.value != null) {
        executionTrace._addTraceStep(
          codeId: "#12100",
          shortDesc:
              "Create ${ExecutionUnitType.scalarQuery.asDebugExecutionUnit()}(s) "
              "for all child scalars and add to Queue."
              "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
          traceStepType: TraceStepType.info,
        );
        for (XScalar childXScalar in thisXScalar.childXScalars) {
          final executionUnit = _ScalarQueryExecutionUnit(
            xScalar: childXScalar,
          );
          executionTrace._addTraceStep(
            codeId: "#12120",
            shortDesc:
                "Create ${executionUnit.asDebugExecutionUnit()} and add to Queue.",
            traceStepType: TraceStepType.addExecutionUnit,
          );
          thisXScalar.xShelf._addExecutionUnit(
            executionUnit: executionUnit,
          );
        }
      }
      return;
    } else if (queryHint == QryHint.markAsPending) {
      executionTrace._addTraceStep(
        codeId: "#12140",
        shortDesc:
            "@queryHint: $queryHint, @dataState: $dataState, @value: ${debugObjHtml(this.value)}.",
      );
      //
      executionTrace._addTraceStep(
        codeId: "#12180",
        shortDesc:
            "${debugObjHtml(this)} --> clear data and set to <b>pending</b> state. "
            "Clear data of child scalars and set them to <b>none</b>."
            "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        traceStepType: TraceStepType.info,
      );
      //
      this.__clearWithDataStateAndChildrenToNonCascade(
        thisXScalar: thisXScalar,
        scalarDataState: ScalarDataStatePending(),
        errorInFilter: false,
        resetSyncSessionState: true,
      );
      thisXScalar.setReQueryDone();
      return;
    }
    //
    // this.dataState != DataState.loaded || thisXScalar.queryHint
    //
    ScalarDataState newScalarDataState = this.dataState;
    //
    FilterCriteriaMappedValue<FILTER_CRITERIA>? filterCriteriaMvOfFilterModel;
    try {
      final XFilterModel xFilterModel = thisXScalar.xFilterModel;
      final FilterModel filterModel = xFilterModel.filterModel;
      // SAME-AS: #0004
      if (!xFilterModel.queried) {
        executionTrace._addTraceStep(
          codeId: "#12220",
          shortDesc:
              "${debugObjHtml(this)} @queried: ${xFilterModel.queried} --> need to load data",
        );
        FILTER_INPUT? filterInput = xFilterModel.filterInput as FILTER_INPUT?;
        //
        filterCriteriaMvOfFilterModel =
            await filterModel._startNewFilterActivity(
          executionTrace: executionTrace,
          activityType: FilterActivityType.newFilt,
          filterInput: filterInput,
          formKeyInstantValuesInUI: null,
        ) as FilterCriteriaMappedValue<FILTER_CRITERIA>?;
        //
        xFilterModel.queried = true;
      } else {
        executionTrace._addTraceStep(
          codeId: "#12300",
          shortDesc:
              "${debugObjHtml(this)} @queried: ${xFilterModel.queried} --> no need to load data.",
        );
        filterCriteriaMvOfFilterModel = filterModel._filterCriteriaMappedValue!
            as FilterCriteriaMappedValue<FILTER_CRITERIA>;
      }
    } catch (e, _) {
      /* Never Error */
    }
    //
    // Has Error in FilterModel.
    //
    if (filterCriteriaMvOfFilterModel == null) {
      executionTrace._addTraceStep(
        codeId: "#12340",
        shortDesc:
            "${debugObjHtml(filterModel)} error --> clear data of ${debugObjHtml(this)} and set to <b>error</b>. "
            "Clear data of child scalar and set them to <b>none</b>.",
        traceStepType: TraceStepType.info,
      );
      // Set Scalar to error cascade.
      __stopQueryWithFilterErrorCascade(
        thisXScalar: thisXScalar,
        scalarErrorInfo: null,
      );
      return;
    }
    //
    // Ready FilterCriteria:
    //
    final bool filterCriteriaChanged =
        __scalarData._isFilterCriteriaMappedValueChanged(
      newFilterCriteriaMappedValue: filterCriteriaMvOfFilterModel,
    );
    //
    ActionResultState queryResultState;
    ScalarErrorInfo? sclrErrorInfo;
    //
    final performQueryMethod = ScalarErrorMethod.performQuery;
    bool isQueryError = false;
    final ID? oldValueId = __scalarData.current._id;
    ID? valueId;
    VALUE? value;
    //
    try {
      __refreshQueryingState(isQuerying: true);
      //
      executionTrace._addTraceStep(
        codeId: "#12400",
        shortDesc: "Calling ${debugObjHtml(this)}.performQuery()...",
        parameters: {
          "parentScalarValue": parent?.value,
          "filterCriteria": filterCriteriaMvOfFilterModel.filterCriteria,
        },
        traceStepType: TraceStepType.controllableCalling,
      );
      //
      debug.__performQueryCount++;
      ApiResult<VALUE> result = await performQuery(
        parentScalarValue: parent?.value,
        filterCriteria: filterCriteriaMvOfFilterModel.filterCriteria,
      );
      //
      // Throw ApiError:
      result.throwIfError();
      //
      // Query DONE!
      //
      thisXScalar.setReQueryDone();
      queryResultState = ActionResultState.success;
      value = result.data;
      valueId = value?.id;
      _resetSyncSessionState(executionTrace: executionTrace);
    } catch (e, stackTrace) {
      queryResultState = ActionResultState.fail;
      isQueryError = true;
      //
      sclrErrorInfo = ScalarErrorInfo(
        scalarErrorMethod: performQueryMethod,
        error: e, // AppError, ApiError or others.
        errorStackTrace: stackTrace,
      );
      //
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: performQueryMethod.name,
        // AppError, ApiError or others.
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.scalarPerformQuery,
      );
      //
      thisXScalar.queryResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      executionTrace._addTraceStep(
        codeId: "#12440",
        shortDesc:
            "The ${debugObjHtml(this)}.performQuery() was called with an error!",
        errorInfo: errorInfo,
      );
    } finally {
      __refreshQueryingState(isQuerying: false);
    }
    //
    final calculationInput = ScalarQueryCalculatorInput(
      queryResultState: queryResultState,
      scalarErrorOrigin: ScalarErrorOrigin.directFetch,
      scalarErrorInfo: sclrErrorInfo,
      currentDataState: dataState,
      filterCriteriaChanged: filterCriteriaChanged,
    );
    final ScalarQueryCalculatorResult calculationResult =
        ScalarQueryStateCalculator.calculate(calculationInput);

    print("@TEMP INPUT: ");
    print(calculationInput.getDebugInfo());
    print(calculationResult.getDebugInfo());

    // Extract variables directly into your pre-existing downstream fields securely
    newScalarDataState = calculationResult.newScalarDataState;

    // Test Cases: [12a], [12b].
    // Test Cases: [80b].
    if (sclrErrorInfo != null) {
      executionTrace._addTraceStep(
        codeId: "#12500",
        shortDesc:
            "${debugObjHtml(this)} --> Query error -> newScalarDataState: $newScalarDataState",
      );
      __scalarData._updateStateAfterQueryError(
        newScalarDataState: newScalarDataState,
      );
      final List<XScalar> descendantXScalars =
          thisXScalar.getDescendantXScalars(sameFilterOnly: true);

      __stopDescendantQueryWithError(
        descendantXScalars: descendantXScalars,
        scalarErrorOrigin: ScalarErrorOrigin.directFetch.toCascadedOrigin(),
      );
      return;
    }

    // No ERROR!
    executionTrace._addTraceStep(
      codeId: "#12600",
      shortDesc:
          "${debugObjHtml(this)} --> set state to loađed and set value to ${debugObjHtml(value)}.",
    );
    newScalarDataState = ScalarDataStateLoadedFresh();
    __setQueryDataWithState(
      thisXScalar: thisXScalar,
      xFilterCriteria: filterCriteriaMvOfFilterModel,
      dataState: newScalarDataState,
      valueId: valueId,
      value: value,
      queryResultState: ActionResultState.success,
    );
    //
    if (value == null) {
      executionTrace._addTraceStep(
        codeId: "#12680",
        shortDesc:
            "${debugObjHtml(this)} --> @value: null --> clear data of all child scalars and set them to <b>none</b>."
            "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        traceStepType: TraceStepType.info,
      );
      __clearAllChildrenScalarsToNone(thisXScalar: thisXScalar);
      return;
    }
    //
    if (filterCriteriaChanged || valueId != oldValueId) {
      executionTrace._addTraceStep(
        codeId: "#12700",
        shortDesc:
            "${debugObjHtml(this)} --> @filterCriteria changed --> clear data of child scalars and set them to <b>pending</b>."
            "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        traceStepType: TraceStepType.info,
      );
      this.__clearAllChildrenScalarsToPending(
        thisXScalar: thisXScalar,
      );
    }
    //
    executionTrace._addTraceStep(
      codeId: "#12800",
      shortDesc:
          "Create ${ExecutionUnitType.scalarQuery.asDebugExecutionUnit()}(s) "
          "for all child scalars and add to queue."
          "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      traceStepType: TraceStepType.info,
    );
    for (XScalar childXScalar in thisXScalar.childXScalars) {
      final executionUnit = _ScalarQueryExecutionUnit(
        xScalar: childXScalar,
      );
      executionTrace._addTraceStep(
        codeId: "#12840",
        shortDesc:
            "Create ${executionUnit.asDebugExecutionUnit()} and add to queue.",
        traceStepType: TraceStepType.addExecutionUnit,
      );
      thisXScalar.xShelf._addExecutionUnit(
        executionUnit: executionUnit,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_ScalarClearAnnotation()
  Future<void> _unitClear({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XScalar thisXScalar,
  }) async {
    __assertThisXScalar(thisXScalar);
    //
    executionTrace._addTraceStep(
      codeId: "#39000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${executionUnitType.asDebugExecutionUnit()}.",
      traceStepType: TraceStepType.debug,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#39000",
      shortDesc:
          "${debugObjHtml(this)} ->  Clear data and set to <b>pending</b>. "
          "Clear data of child scalars and set its to <b>none</b>."
          "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      traceStepType: TraceStepType.info,
    );
    //
    __clearWithDataStateAndChildrenToNonCascade(
      thisXScalar: thisXScalar,
      scalarDataState: ScalarDataStatePending(),
      errorInFilter: false,
      resetSyncSessionState: true,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_ScalarLoadExtraDataQuickActionAnnotation()
  Future<bool> _unitLoadExtraDataQuickAction<DATA extends Object>({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XScalar thisXScalar,
    required ScalarQuickExtraDataLoadAction<DATA> action,
    required AfterScalarLoadExtraDataQuickAction afterQuickAction,
  }) async {
    __assertThisXScalar(thisXScalar);
    //
    executionTrace._addTraceStep(
      codeId: "#40000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${executionUnitType.asDebugExecutionUnit()}.",
      traceStepType: TraceStepType.debug,
    );
    //
    ApiResult<DATA>? result;
    try {
      executionTrace._addTraceStep(
        codeId: "#40100",
        shortDesc: "Calling ${debugObjHtml(action)}.performLoadExtraData().",
        traceStepType: TraceStepType.controllableCalling,
      );
      //
      result = await action.performLoadExtraData();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.performLoadExtraData',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionTrace._addTraceStep(
        codeId: "#40200",
        shortDesc:
            "The ${debugObjHtml(action)}.performLoadExtraData() method was called with an error!",
        errorInfo: errorInfo,
      );
      return false;
    }
    //
    bool success = true;
    if (result != null && result.error != null) {
      success = false;
      //
      final ErrorInfo errorInfo = _handleRestError(
        shelf: shelf,
        methodName: "${getClassName(action)}.performLoadExtraData",
        message: result.error!.errorMessage,
        errorDetails: result.error!.errorDetails,
        showSnackBar: true,
        tipDocument: null,
      );
      executionTrace._addTraceStep(
        codeId: "#40300",
        shortDesc:
            "The ${debugObjHtml(action)}.performLoadExtraData() method was called with an error!",
        errorInfo: errorInfo,
      );
    }
    //
    DATA? extraData = result?.data;
    //
    return await _showAfterScalarLoadExtraData(
      executionTrace: executionTrace,
      action: action,
      afterQuickAction: afterQuickAction,
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
      executionTrace._addTraceStep(
        codeId: "#41000",
        shortDesc: "Calling ${debugObjHtml(action)}.onExtraDataLoaded().",
        parameters: {
          "success": success,
          "extraData": extraData,
        },
        traceStepType: TraceStepType.controllableCalling,
      );
      await action.onExtraDataLoaded(
        context,
        success: success,
        extraData: extraData,
      );
      success2 = true;
    } catch (e, stackTrace) {
      final errorInfo = ErrorInfo.fromError(error: e, stackTrace: stackTrace);
      //
      executionTrace._addTraceStep(
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
        ui.updateAllUiComponents(withoutFilters: true);
    }
    return success2;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __stopQueryWithFilterErrorCascade({
    required XScalar thisXScalar,
    required ScalarErrorInfo? scalarErrorInfo,
  }) {
    __assertThisXScalar(thisXScalar);
    thisXScalar.queryResult._setFilterError();

    final scalarErrorOrigin = ScalarErrorOrigin.filterModel;

    final fallbackDilemmaStrategy = FallbackDilemmaStrategy.preserveStableCache;

    final ScalarDataState newScalarDataState =
        ScalarQueryStateCalculator.calculateDataStateOnError(
      currentDataState: dataState,
      scalarErrorOrigin: scalarErrorOrigin,
      scalarErrorInfo: scalarErrorInfo,
      dilemmaStrategy: fallbackDilemmaStrategy,
    );

    __scalarData._lastQueryResultState = ActionResultState.fail;
    __scalarData._scalarDataState = newScalarDataState;

    final List<XScalar> descendantXScalars =
        thisXScalar.getDescendantXScalars(sameFilterOnly: true);

    __stopDescendantQueryWithError(
      descendantXScalars: descendantXScalars,
      scalarErrorOrigin: scalarErrorOrigin.toCascadedOrigin(),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __stopDescendantQueryWithError({
    required List<XScalar> descendantXScalars,
    required ScalarErrorOrigin scalarErrorOrigin,
  }) {
    FallbackDilemmaStrategy fallbackDilemmaStrategy =
        FallbackDilemmaStrategy.preserveStableCache;

    for (final descendant in descendantXScalars) {
      final descendantState =
          ScalarQueryStateCalculator.calculateDataStateOnError(
        currentDataState: descendant.scalar.dataState,
        scalarErrorOrigin: scalarErrorOrigin,
        scalarErrorInfo: null,
        dilemmaStrategy: fallbackDilemmaStrategy,
      );
      print("*** scalarErrorOrigin $scalarErrorOrigin");
      print("descendant: $descendant, descendantState: $descendantState");

      descendant.scalar.__scalarData._lastQueryResultState =
          ActionResultState.fail;
      descendant.scalar.__scalarData._scalarDataState = descendantState;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

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
      await ErrorViewerDialog.show(
        context: context,
        errorInfo: errorInfo,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearWithDataStateAndChildrenToNonCascade({
    required XScalar thisXScalar,
    required ScalarDataState scalarDataState,
    required bool errorInFilter,
    required bool resetSyncSessionState,
  }) {
    __assertThisXScalar(thisXScalar);
    //
    __clearValueWithDataState(
      thisXScalar: thisXScalar,
      scalarDataState: scalarDataState,
      errorInFilter: errorInFilter,
      resetSyncSessionState: resetSyncSessionState,
    );

    for (var childXScalar in thisXScalar.childXScalars) {
      childXScalar.scalar.__clearWithDataStateAndChildrenToNonCascade(
        thisXScalar: childXScalar,
        scalarDataState: ScalarDataStateNone(),
        errorInFilter: false,
        resetSyncSessionState: true,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setQueryDataWithState({
    required XScalar thisXScalar,
    required FilterCriteriaMappedValue<FILTER_CRITERIA>? xFilterCriteria,
    required ScalarDataState dataState,
    required ID? valueId,
    required VALUE? value,
    required ActionResultState queryResultState,
  }) {
    __assertThisXScalar(thisXScalar);
    //
    __scalarData._updateData(
      filterCriteriaMappedValue: xFilterCriteria,
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
        scalarDataState: ScalarDataStateNone(),
        errorInFilter: false,
        resetSyncSessionState: true,
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
        scalarDataState: ScalarDataStatePending(),
        errorInFilter: false,
        resetSyncSessionState: true,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearWithDataState({
    required XScalar thisXScalar,
    required ScalarDataState scalarDataState,
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

  @_AbstractMethodAnnotation()
  Future<ApiResult<VALUE>> performQuery({
    required Object? parentScalarValue,
    required FILTER_CRITERIA filterCriteria,
  });

  //
  // // ***************************************************************************
  // // ***************************************************************************
  //
  // void __clearScalarError() {
  //   _scalarErrorInfo = null;
  // }
  //
  // void __setScalarErrorInfo(ScalarErrorInfo errorInfo) {
  //   _scalarErrorInfo = errorInfo;
  // }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ScalarLoadExtraDataQuickActionAnnotation()
  Future<bool> executeQuickLoadExtraDataAction<DATA extends Object>({
    FILTER_INPUT? filterInput,
    required ActionConfirmationType actionConfirmationType,
    required ScalarQuickExtraDataLoadAction<DATA> action,
    required AfterScalarLoadExtraDataQuickAction afterQuickAction,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeQuickLoadExtraDataAction",
      parameters: {
        "filterInput": filterInput,
        "actionConfirmationType": actionConfirmationType,
        "action": action,
        "afterQuickAction": afterQuickAction,
      },
      isLibMethod: true,
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
    executionTrace._addTraceStep(
      codeId: "#80340",
      shortDesc:
          "Creating <b>_ScalarLoadExtraDataQuickActionExecutionUnit</b>.",
      traceStepType: TraceStepType.addExecutionUnit,
    );
    _ShelfMemberExecutionUnit executionUnit =
        _ScalarLoadExtraDataQuickActionExecutionUnit(
      xScalar: thisXScalar,
      action: action,
      afterQuickAction: afterQuickAction,
    );
    //
    xShelf._addExecutionUnit(executionUnit: executionUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
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
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "query",
      parameters: {
        "filterInput": filterInput,
      },
      isLibMethod: true,
    );
    executionTrace._addTraceStep(
      codeId: "#54000",
      shortDesc: "Creating <b>$_XShelfScalarQuery</b>..",
    );
    //
    final XShelf xShelf = _XShelfScalarQuery(
      scalar: this,
      filterInput: filterInput,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#54100",
      shortDesc: "Calling ${debugObjHtml(xShelf)}._initQueryExecutionUnits()..",
      traceStepType: TraceStepType.nonControllableCalling,
    );
    xShelf._initQueryExecutionUnits(executionTrace: executionTrace);
    //
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
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
  @_ReturnExecutionUnitResultMethodAnnotation()
  @_ScalarClearAnnotation()
  Future<ScalarClearResult> clear() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "clear",
      parameters: {},
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    //
    //
    executionTrace._addTraceStep(
      codeId: "#80000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canClearScalar() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
      },
    );
    //
    // @Same-Code-Precheck-01
    Actionable<ScalarClearPrecheck> actionable = __canClearScalar(
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      executionTrace._addTraceStep(
        codeId: "#80040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
        traceStepType: TraceStepType.debug,
      );
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return ScalarClearResult(
        precheck: actionable.errCode,
      );
    }
    //
    final XShelf xShelf = _XShelfScalarClear(scalar: this);
    final XScalar thisXScalar = xShelf.findXScalarByName(name)!;
    //
    executionTrace._addTraceStep(
      codeId: "#80340",
      shortDesc: "Creating <b>_ScalarClearExecutionUnit</b>.",
      traceStepType: TraceStepType.addExecutionUnit,
    );
    final _ShelfMemberResultedExecutionUnit executionUnit = _ScalarClearExecutionUnit(
      xScalar: thisXScalar,
    );
    //
    xShelf._addExecutionUnit(executionUnit: executionUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return executionUnit.executionUnitResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearValueWithDataState({
    required XScalar thisXScalar,
    required ScalarDataState scalarDataState,
    required bool errorInFilter,
    required bool resetSyncSessionState,
  }) {
    __assertThisXScalar(thisXScalar);
    //
    __scalarData._clearValueWithDataState(
      scalarDataState: scalarDataState,
      errorInFilter: errorInFilter,
      resetSyncSessionState: resetSyncSessionState,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      ui.updateControlBars();
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void _broadcastScalarHidden() {
    // FlutterArtist.codeFlowLogger._addEvent(
    //   ownerClassInstance: this,
    //   event: "Scalar '${getClassName(this)}' just hides all UI Components!",
    //   isLibCode: true,
    // );
    switch (effectiveConfig.onHideAction) {
      case ScalarHiddenAction.none:
        break;
      case ScalarHiddenAction.clear:
        break;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isQueryAllowed() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool canShowFilterCriteria() {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    return filterModel != null &&
        loggedInUser != null &&
        loggedInUser.isSystemUser;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<ScalarQueryPrecheck> canQuery({
    bool checkAllow = true,
  }) {
    return __canQuery(checkBusy: true, checkAllow: checkAllow);
  }

  // ***************************************************************************

  ///
  /// Allows to Query the Scalar.
  ///
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

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<ScalarQueryPrecheck> __canQuery({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<ScalarQueryPrecheck>.no(
          errCode: ScalarQueryPrecheck.busy);
    }
    //
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
    //
    return Actionable<ScalarQueryPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<ScalarClearPrecheck> __canClearScalar({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<ScalarClearPrecheck>.no(
        errCode: ScalarClearPrecheck.busy,
      );
    }
    // bool hasActiveUI = ui.hasActiveUiComponent(alsoCheckChildren: true);
    // if (hasActiveUI) {
    //   return Actionable<ScalarClearPrecheck>.no(
    //     errCode: ScalarClearPrecheck.hasActiveUI,
    //   );
    // }
    return Actionable<ScalarClearPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugFilterCriteriaViewerDialog() async {
    BuildContext context = FlutterArtistCore.context;
    //
    await DebugViewerDialog.openDebugFilterCriteriaInspector(
      context: context,
      locationInfo: '',
      filterModel: registeredOrDefaultFilterModel,
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
