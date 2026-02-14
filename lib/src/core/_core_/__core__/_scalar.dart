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

  late final ui = _ScalarUiComponents(scalar: this);

  // ***************************************************************************
  // ***************************************************************************

  ScalarErrorInfo? _scalarErrorInfo;

  ScalarErrorInfo? get scalarErrorInfo => _scalarErrorInfo;

  DataState get dataState => __scalarData._scalarDataState;

  FILTER_CRITERIA? get filterCriteria =>
      __scalarData._xFilterCriteria?.filterCriteria;

  XFilterCriteria<FILTER_CRITERIA>? get debugXFilterCriteria =>
      __scalarData._xFilterCriteria;

  VALUE? get value => __scalarData.current._value;

  void _setToPending() {
    __scalarData._clearValueWithDataState(
      scalarDataState: DataState.pending,
      errorInFilter: false,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  _ScalarReQryCon? _scalarReQryCondition;

  bool _hasReactionBookmark() {
    return _scalarReQryCondition != null;
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
    list.addAll(config.onExternalShelfEvents.scalarLevelReactionTo);
    //
    return list.toSet().toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_ScalarQueryAnnotation()
  Future<void> _unitQuery({
    required MasterFlowItem masterFlowItem,
    required TaskType taskType,
    required XScalar thisXScalar,
  }) async {
    __assertThisXScalar(thisXScalar);
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#12000",
      shortDesc: "${debugObjHtml(this)} -> Begin ${taskType.asDebugTaskUnit()}",
      lineFlowType: LineFlowType.debug,
    );
    //
    bool hasXActiveUI = ui.hasActiveUiComponent(alsoCheckChildren: true);
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#12020",
      shortDesc: "${debugObjHtml(this)} has UIX Visible? $hasXActiveUI",
    );
    //
    QryHint queryHint = thisXScalar.queryHint;

    if (queryHint != QryHint.force) {
      if (this.dataState != DataState.ready && hasXActiveUI) {
        queryHint = QryHint.force;
      }
    }
    masterFlowItem._addLineFlowItem(
      codeId: "#12040",
      shortDesc: "Calculated: @queryHint: $queryHint.",
    );

    if (queryHint == QryHint.none) {
      masterFlowItem._addLineFlowItem(
        codeId: "#12080",
        shortDesc:
            "@queryHint: $queryHint, @dataState: $dataState, @value: ${debugObjHtml(this.value)}.",
      );
      //
      if (this.dataState == DataState.ready && this.value != null) {
        masterFlowItem._addLineFlowItem(
          codeId: "#12100",
          shortDesc: "Create ${TaskType.scalarQuery.asDebugTaskUnit()}(s) "
              "for all child scalars and add to Queue."
              "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
          lineFlowType: LineFlowType.info,
        );
        for (XScalar childXScalar in thisXScalar.childXScalars) {
          final taskUnit = _ScalarQueryTaskUnit(
            xScalar: childXScalar,
          );
          masterFlowItem._addLineFlowItem(
            codeId: "#12120",
            shortDesc: "Create ${taskUnit.asDebugTaskUnit()} and add to Queue.",
            lineFlowType: LineFlowType.addTaskUnit,
          );
          thisXScalar.xShelf._addTaskUnit(
            taskUnit: taskUnit,
          );
        }
      }
      return;
    } else if (queryHint == QryHint.markAsPending) {
      masterFlowItem._addLineFlowItem(
        codeId: "#12140",
        shortDesc:
            "@queryHint: $queryHint, @dataState: $dataState, @value: ${debugObjHtml(this.value)}.",
      );
      //
      masterFlowItem._addLineFlowItem(
        codeId: "#12180",
        shortDesc:
            "${debugObjHtml(this)} --> clear data and set to <b>pending</b> state. "
            "Clear data of child scalars and set them to <b>none</b>."
            "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        lineFlowType: LineFlowType.info,
      );
      //
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
    XFilterCriteria<FILTER_CRITERIA>? xFilterCriteriaOfFilterModel;
    try {
      final XFilterModel xFilterModel = thisXScalar.xFilterModel;
      final FilterModel filterModel = xFilterModel.filterModel;
      // SAME-AS: #0004
      if (!xFilterModel.queried) {
        masterFlowItem._addLineFlowItem(
          codeId: "#12220",
          shortDesc:
              "${debugObjHtml(this)} @queried: ${xFilterModel.queried} --> need to load data",
        );
        FILTER_INPUT? filterInput = xFilterModel.filterInput as FILTER_INPUT?;
        //
        xFilterCriteriaOfFilterModel =
            await filterModel._startNewFilterActivity(
          masterFlowItem: masterFlowItem,
          activityType: FilterActivityType.newFilt,
          filterInput: filterInput,
        ) as XFilterCriteria<FILTER_CRITERIA>?;
        //
        xFilterModel.queried = true;
      } else {
        masterFlowItem._addLineFlowItem(
          codeId: "#12300",
          shortDesc:
              "${debugObjHtml(this)} @queried: ${xFilterModel.queried} --> no need to load data.",
        );
        xFilterCriteriaOfFilterModel =
            filterModel._xFilterCriteria! as XFilterCriteria<FILTER_CRITERIA>;
      }
    } catch (e, stackTrace) {
      /* Never Error */
    }
    //
    // Has Error in FilterModel.
    //
    if (xFilterCriteriaOfFilterModel == null) {
      masterFlowItem._addLineFlowItem(
        codeId: "#12340",
        shortDesc:
            "${debugObjHtml(filterModel)} error --> clear data of ${debugObjHtml(this)} and set to <b>error</b>. "
            "Clear data of child scalar and set them to <b>none</b>.",
        lineFlowType: LineFlowType.info,
      );
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
      newXFilterCriteria: xFilterCriteriaOfFilterModel,
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
      masterFlowItem._addLineFlowItem(
        codeId: "#12400",
        shortDesc: "Calling ${debugObjHtml(this)}.callApiQuery()...",
        parameters: {
          "parentScalarValue": parent?.value,
          "filterCriteria": xFilterCriteriaOfFilterModel.filterCriteria,
        },
        lineFlowType: LineFlowType.controllableCalling,
      );
      ApiResult<VALUE> result = await callApiQuery(
        parentScalarValue: parent?.value,
        filterCriteria: xFilterCriteriaOfFilterModel.filterCriteria,
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
              filterCriteria: xFilterCriteriaOfFilterModel.filterCriteria,
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
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: callApiQueryMethod.name,
        // AppError, ApiError or others.
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.scalarCallApiQuery,
      );
      //
      thisXScalar.queryResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      masterFlowItem._addLineFlowItem(
        codeId: "#12440",
        shortDesc:
            "The ${debugObjHtml(this)}.callApiQuery() was called with an error!",
        errorInfo: errorInfo,
      );
      isQueryError = true;
    } finally {
      __refreshQueryingState(isQuerying: false);
    }
    // Test Cases: [12a], [12b].
    if (isQueryError) {
      newScalarDataState = DataState.error;
      //
      masterFlowItem._addLineFlowItem(
        codeId: "#12500",
        shortDesc: "${debugObjHtml(this)} --> set value to null",
      );
      __setQueryDataWithState(
        thisXScalar: thisXScalar,
        xFilterCriteria: null,
        dataState: newScalarDataState,
        valueId: null,
        value: null,
        queryResultState: ActionResultState.fail,
      );
      masterFlowItem._addLineFlowItem(
        codeId: "#12520",
        shortDesc:
            "${debugObjHtml(this)} --> clear value and set state to <b>error</b>. "
            "Clear value of child scalars and set them to <b>none</b>."
            "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      );
      __clearWithDataStateAndChildrenToNonCascade(
        thisXScalar: thisXScalar,
        scalarDataState: newScalarDataState,
        errorInFilter: false,
      );
      return;
    }
    // No ERROR!
    masterFlowItem._addLineFlowItem(
      codeId: "#12600",
      shortDesc:
          "${debugObjHtml(this)} --> set state to ready and set value to ${debugObjHtml(value)}.",
    );
    newScalarDataState = DataState.ready;
    __setQueryDataWithState(
      thisXScalar: thisXScalar,
      xFilterCriteria: xFilterCriteriaOfFilterModel,
      dataState: newScalarDataState,
      valueId: valueId,
      value: value,
      queryResultState: ActionResultState.success,
    );
    //
    if (value == null) {
      masterFlowItem._addLineFlowItem(
        codeId: "#12680",
        shortDesc:
            "${debugObjHtml(this)} --> @value: null --> clear data of all child scalars and set them to <b>none</b>."
            "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        lineFlowType: LineFlowType.info,
      );
      __clearAllChildrenScalarsToNone(thisXScalar: thisXScalar);
      return;
    }
    //
    if (xCriteriaChanged || valueId != oldValueId) {
      masterFlowItem._addLineFlowItem(
        codeId: "#12700",
        shortDesc:
            "${debugObjHtml(this)} --> @filterCriteria changed --> clear data of child scalars and set them to <b>pending</b>."
            "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        lineFlowType: LineFlowType.info,
      );
      this.__clearAllChildrenScalarsToPending(
        thisXScalar: thisXScalar,
      );
    }
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#12800",
      shortDesc: "Create ${TaskType.scalarQuery.asDebugTaskUnit()}(s) "
          "for all child scalars and add to queue."
          "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      lineFlowType: LineFlowType.info,
    );
    for (XScalar childXScalar in thisXScalar.childXScalars) {
      final taskUnit = _ScalarQueryTaskUnit(
        xScalar: childXScalar,
      );
      masterFlowItem._addLineFlowItem(
        codeId: "#12840",
        shortDesc: "Create ${taskUnit.asDebugTaskUnit()} and add to queue.",
        lineFlowType: LineFlowType.addTaskUnit,
      );
      thisXScalar.xShelf._addTaskUnit(
        taskUnit: taskUnit,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_ScalarClearanceAnnotation()
  Future<void> _unitClearance({
    required MasterFlowItem masterFlowItem,
    required TaskType taskType,
    required XScalar thisXScalar,
  }) async {
    __assertThisXScalar(thisXScalar);
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#39000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${taskType.asDebugTaskUnit()}.",
      lineFlowType: LineFlowType.debug,
    );
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#39000",
      shortDesc:
          "${debugObjHtml(this)} ->  Clear data and set to <b>pending</b>. "
          "Clear data of child scalars and set its to <b>none</b>."
          "${_childScalars.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      lineFlowType: LineFlowType.info,
    );
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
    required MasterFlowItem masterFlowItem,
    required TaskType taskType,
    required XScalar thisXScalar,
    required ScalarQuickExtraDataLoadAction<DATA> action,
    required AfterScalarLoadExtraDataQuickAction afterQuickAction,
  }) async {
    __assertThisXScalar(thisXScalar);
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#40000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${taskType.asDebugTaskUnit()}.",
      lineFlowType: LineFlowType.debug,
    );
    //
    ApiResult<DATA>? result;
    try {
      masterFlowItem._addLineFlowItem(
        codeId: "#40100",
        shortDesc: "Calling ${debugObjHtml(action)}.callApiLoadExtraData().",
        lineFlowType: LineFlowType.controllableCalling,
      );
      //
      result = await action.callApiLoadExtraData();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApiLoadExtraData',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      masterFlowItem._addLineFlowItem(
        codeId: "#40200",
        shortDesc:
            "The ${debugObjHtml(action)}.callApiLoadExtraData() method was called with an error!",
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
        methodName: "${getClassName(action)}.callApiLoadExtraData",
        message: result.error!.errorMessage,
        errorDetails: result.error!.errorDetails,
        showSnackBar: true,
        tipDocument: null,
      );
      masterFlowItem._addLineFlowItem(
        codeId: "#40300",
        shortDesc:
            "The ${debugObjHtml(action)}.callApiLoadExtraData() method was called with an error!",
        errorInfo: errorInfo,
      );
    }
    //
    DATA? extraData = result?.data;
    //
    return await _showAfterScalarLoadExtraData(
      masterFlowItem: masterFlowItem,
      action: action,
      afterQuickAction: afterQuickAction,
      extraData: extraData,
      success: success,
    );
  }

  Future<bool> _showAfterScalarLoadExtraData<DATA extends Object>({
    required MasterFlowItem masterFlowItem,
    required ScalarQuickExtraDataLoadAction<DATA> action,
    required AfterScalarLoadExtraDataQuickAction afterQuickAction,
    required DATA? extraData,
    required bool success,
  }) async {
    BuildContext context =
        FlutterArtist.coreFeaturesAdapter.getCurrentContext();
    bool success2;
    try {
      masterFlowItem._addLineFlowItem(
        codeId: "#41000",
        shortDesc: "Calling ${debugObjHtml(action)}.doWithExtraData().",
        parameters: {
          "success": success,
          "extraData": extraData,
        },
        lineFlowType: LineFlowType.controllableCalling,
      );
      await action.doWithExtraData(
        context,
        success: success,
        extraData: extraData,
      );
      success2 = true;
    } catch (e, stackTrace) {
      final errorInfo = ErrorInfo.fromError(error: e, stackTrace: stackTrace);
      //
      masterFlowItem._addLineFlowItem(
        codeId: "#41300",
        shortDesc:
            "The ${debugObjHtml(action)}.doWithExtraData() method was called with an error!",
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

  @_RootMethodAnnotation()
  void showScalarErrorViewerDialog(BuildContext context) {
    if (dataState == DataState.error) {
      if (_scalarErrorInfo != null) {
        ScalarErrorViewerDialog.open(
          context: context,
          scalarErrorInfo: _scalarErrorInfo!,
        );
      } else if (filterModel != null) {
        if (filterModel!.dataState == DataState.error &&
            filterModel!._errorInfo != null) {
          ErrorViewerDialog.open(
            context: context,
            errorInfo: filterModel!._errorInfo!,
          );
        }
      }
    }
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
    required XFilterCriteria<FILTER_CRITERIA>? xFilterCriteria,
    required DataState dataState,
    required String? valueId,
    required VALUE? value,
    required ActionResultState queryResultState,
  }) {
    __assertThisXScalar(thisXScalar);
    //
    __scalarData._updateData(
      xFilterCriteria: xFilterCriteria,
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
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeQuickLoadExtraDataAction",
      parameters: {
        "filterInput": filterInput,
        "actionConfirmationType": actionConfirmationType,
        "action": action,
        "afterQuickAction": afterQuickAction,
        "navigate": navigate,
      },
      navigate: null,
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
    masterFlowItem._addLineFlowItem(
      codeId: "#80340",
      shortDesc: "Creating <b>_ScalarLoadExtraDataQuickActionTaskUnit</b>.",
      lineFlowType: LineFlowType.addTaskUnit,
    );
    _STaskUnit taskUnit = _ScalarLoadExtraDataQuickActionTaskUnit(
      xScalar: thisXScalar,
      action: action,
      afterQuickAction: afterQuickAction,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
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
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "query",
      parameters: {
        "filterInput": filterInput,
      },
      navigate: null,
      isLibMethod: true,
    );
    masterFlowItem._addLineFlowItem(
      codeId: "#54000",
      shortDesc: "Creating <b>$_XShelfScalarQuery</b>..",
    );
    //
    final XShelf xShelf = _XShelfScalarQuery(
      scalar: this,
      filterInput: filterInput,
    );
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#54100",
      shortDesc: "Calling ${debugObjHtml(xShelf)}._initQueryTaskUnits()..",
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    xShelf._initQueryTaskUnits(masterFlowItem: masterFlowItem);
    //
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
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
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "clear",
      parameters: {
        "navigate": navigate,
      },
      navigate: null,
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    //
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#80000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canClearScalar() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
      },
    );
    //
    // @Same-Code-Precheck-01
    Actionable<ScalarClearancePrecheck> actionable = __canClearScalar(
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      masterFlowItem._addLineFlowItem(
        codeId: "#80040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
        lineFlowType: LineFlowType.debug,
      );
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return ScalarClearanceResult(
        precheck: actionable.errCode,
      );
    }
    //
    final XShelf xShelf = _XShelfScalarClearance(scalar: this);
    final XScalar thisXScalar = xShelf.findXScalarByName(name)!;
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#80340",
      shortDesc: "Creating <b>_ScalarClearanceTaskUnit</b>.",
      lineFlowType: LineFlowType.addTaskUnit,
    );
    final _ResultedSTaskUnit taskUnit = _ScalarClearanceTaskUnit(
      xScalar: thisXScalar,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
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
      ui.updateControlBars();
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void _fireScalarHidden() {
    // FlutterArtist.codeFlowLogger._addEvent(
    //   ownerClassInstance: this,
    //   event: "Scalar '${getClassName(this)}' just hides all UI Components!",
    //   isLibCode: true,
    // );
    switch (config.onHideAction) {
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

  ///
  /// Do not override
  ///
  bool canQuery() {
    return isQueryAllowed();
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
    // bool hasActiveUI = ui.hasActiveUiComponent(alsoCheckChildren: true);
    // if (hasActiveUI) {
    //   return Actionable<ScalarClearancePrecheck>.no(
    //     errCode: ScalarClearancePrecheck.hasActiveUI,
    //   );
    // }
    return Actionable<ScalarClearancePrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugFilterCriteriaViewerDialog() async {
    BuildContext context =
        FlutterArtist.coreFeaturesAdapter.getCurrentContext();
    //
    await DebugViewerDialog.openDebugFilterCriteriaViewer(
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
