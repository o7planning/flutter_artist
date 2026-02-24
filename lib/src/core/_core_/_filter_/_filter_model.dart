part of '../core.dart';

abstract class FilterModel<
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria // EmptyFilterCriteria
    > extends _Core {
  bool _filterCriteriaPrechecked = false;

  late final Shelf shelf;

  late final String name;

  final FilterModelConfig config;

  String get pathInfo {
    return "filter-model > ${shelf.name} > $name";
  }

  final List<Block> _blocks = [];

  List<Block> get blocks => List.unmodifiable(_blocks);

  final List<Scalar> _scalars = [];

  List<Scalar> get scalars => List.unmodifiable(_scalars);

  XFilterCriteria<FILTER_CRITERIA>? _xFilterCriteria;

  FILTER_CRITERIA? get filterCriteria => _xFilterCriteria?.filterCriteria;

  XFilterCriteria<FILTER_CRITERIA>? get debugXFilterCriteria =>
      _xFilterCriteria;

  int __loadCount = 0;

  int get loadCount => __loadCount;

  int __filterActivityCount = 0;

  int get filterActivityCount => __filterActivityCount;

  bool _loadTimeUiActive = false;

  bool get loadTimeUiActive => _loadTimeUiActive;

  bool __initiatedAtLeastOnce = false;

  bool get initiatedAtLeastOnce => __initiatedAtLeastOnce;

  bool __lockAddMoreQuery = false;

  bool get lockAddMoreQuery => __lockAddMoreQuery;

  bool _isDefaultFilterModel = false;

  bool get isDefaultFilterModel => _isDefaultFilterModel;

  late final FilterModelStructure _filterModelStructure;

  FilterModelStructure get filterModelStructure => _filterModelStructure;

  DataState get dataState => _filterModelStructure._filterDataState;

  // TODO: Test case.
  ErrorInfo? _errorInfo;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  late final ui = _FilterUiComponents(filterModel: this);

  // ***************************************************************************
  // ***************************************************************************

  FilterModel({
    FilterModelConfig config = const FilterModelConfig(),
  }) : config = config.copy() {
    __defineFilterModelStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearFilterError() {
    _errorInfo = null;
  }

  void __setErrorInfo(ErrorInfo? errorInfo) {
    _errorInfo = errorInfo;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// ```dart
  /// @override
  /// FilterModelStructure defineFilterModelStructure() {
  ///   return FilterModelStructure(
  ///     criteriaStructure: FilterCriteriaStructure(
  ///       simpleCriterionDefs: [
  ///         SimpleFilterCriterionDef<String>(criterionBaseName: "searchText"),
  ///       ],
  ///       multiOptCriterionDefs: [
  ///         // Multi Options Single Selection Criterion.
  ///         MultiOptFilterCriterionDef<AlbumInfo>.singleSelection(
  ///           criterionBaseName: "album",
  ///           fieldName: 'albumId',
  ///           toFieldValue: (AlbumInfo? rawValue) {
  ///             return SimpleVal.ofInt(rawValue?.id);
  ///           },
  ///         ),
  ///       ],
  ///     ),
  ///     conditionStructure: FilterConditionStructure(
  ///       connector: FilterConnector.and,
  ///       conditionDefs: [
  ///         FilterConditionDef.simple(
  ///           tildeCriterionName: "searchText~",
  ///           operator: FilterOperator.containsIgnoreCase,
  ///         ),
  ///         FilterConditionDef.simple(
  ///           tildeCriterionName: "album~",
  ///           operator: FilterOperator.equalTo,
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  FilterModelStructure defineFilterModelStructure();

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  @_AbstractMethodAnnotation()
  Future<XData?> performLoadMultiOptTildeCriterionXData({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required FILTER_INPUT? filterInput,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  OptValueWrap? specifyDefaultValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required XData multiOptTildeCriterionXData,
    required SelectionType selectionType,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  // SAME-AS: #0011 (form - specifyDefaultValuesForSimpleProps)
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? specifyDefaultValuesForSimpleTildeCriteria();

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  ///
  /// ```dart
  /// @override
  /// ValueWrap? extractUpdateValueForMultiOptTildeCriterion({
  ///     required String multiOptTildeCriterionName,
  ///     required String multiOptCriterionBaseName,
  ///     required Object? parentMultiOptTildeCriterionValue,
  ///     required SelectionType selectionType,
  ///     required ExampleFilterInput filterInput,
  ///     required XData multiOptTildeCriterionXData,
  /// }) {
  ///    if(multiOptTildeCriterionName == "company") {
  ///       int inputCompanyId = filterInput.filterInput;
  ///       CompanyInfo? inputCompany = materPropData?.getItemById(inputCompanyId);
  ///       return ValueWrap.single(inputCompany)
  ///    }
  ///    return null;
  /// }
  /// ```
  ///
  // OLD: getMultiOptCriterionValueFromFilterInput
  @_AbstractMethodAnnotation()
  OptValueWrap? extractUpdateValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required XData multiOptTildeCriterionXData,
    required FILTER_INPUT filterInput,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  // OLD: getSimpleCriterionValuesFromFilterInput.
  // SAME-AS: #0010 (form - extractUpdateValuesForSimpleProps)
  @_AbstractMethodAnnotation()
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleTildeCriteria({
    required FILTER_INPUT filterInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called immediately after
  /// calling [performLoadMultiOptTildeCriterionXData]
  /// methods if there are no errors.
  ///
  /// ```dart
  ///  MyFilterCriteria createNewFilterCriteria({
  ///     required Map<String, dynamic> tildeCriteriaMap,
  ///  }) {
  ///      return MyFilterCriteria(
  ///         company: tildeCriteriaMap["company"],
  ///         department: tildeCriteriaMap["department"],
  ///      );
  ///  }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  FILTER_CRITERIA createNewFilterCriteria({
    required Map<String, dynamic> tildeCriteriaMap,
  });

  XFilterCriteria<FILTER_CRITERIA> __createXFilterCriteria({
    required Map<String, dynamic> tildeCriteriaMap,
    required FilterConditionGroupVal baseCriteria,
    required bool isPrecheck,
  }) {
    FILTER_CRITERIA filterCriteria = createNewFilterCriteria(
      tildeCriteriaMap: tildeCriteriaMap,
    );
    filterCriteria._initFilterCriteria(
      baseCriteria: baseCriteria,
      isPrecheck: isPrecheck,
    );
    return XFilterCriteria<FILTER_CRITERIA>(
      filterCriteria: filterCriteria,
      filterCriteriaMap: tildeCriteriaMap,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __filterCriteriaPrecheck() {
    if (_filterCriteriaPrechecked) {
      return;
    }
    try {
      final xFilterCriteria = __createXFilterCriteria(
        tildeCriteriaMap: {},
        baseCriteria: FilterConditionGroupVal.empty(),
        isPrecheck: true,
      );
      FILTER_CRITERIA filterCriteria = xFilterCriteria.filterCriteria;
    } on FilterModelRegisterError catch (e) {
      rethrow;
    }
    // IMPORTANT: If can not initial FilterCriteria,..
    catch (e) {
      // Do nothing.
    }
    _filterCriteriaPrechecked = true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FilterModelLoadDataAnnotation()
  Future<bool> _unitLoadFilterData({
    required MasterFlowItem masterFlowItem,
    required TaskType taskType,
    required XFilterModel thisXFilterModel,
    required FilterModelDataLoadResult taskResult,
  }) async {
    __assertThisXFilterModel(thisXFilterModel);
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#24000",
      shortDesc: "Begin ${taskType.asDebugTaskUnit()}.",
      lineFlowType: LineFlowType.debug,
    );
    //
    try {
      // SAME-AS: #0004
      if (!thisXFilterModel.queried) {
        FILTER_INPUT? filterInput =
            thisXFilterModel.filterInput as FILTER_INPUT?;
        //
        _xFilterCriteria = await _startNewFilterActivity(
          masterFlowItem: masterFlowItem,
          activityType: FilterActivityType.newFilt,
          filterInput: filterInput,
        );
        //
        thisXFilterModel.queried = true;
      }
      return true;
    } catch (e, stackTrace) {
      // @@TODO@@ 12 Test.
      print("ERROR _unitQuery: $stackTrace");
      /* Never Error */
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FilterPanelChangeAnnotation()
  Future<bool> _unitFilterPanelChanged({
    required MasterFlowItem masterFlowItem,
    required TaskType taskType,
    required XFilterModel xFilterModel,
  }) async {
    __assertThisXFilterModel(xFilterModel);
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#30000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${taskType.asDebugTaskUnit()}.",
      lineFlowType: LineFlowType.debug,
    );
    //
    _filterModelStructure._setFilterDataState(DataState.pending);
    //
    XFilterCriteria<FILTER_CRITERIA>? xFilterCriteria =
        await _startNewFilterActivity(
      masterFlowItem: masterFlowItem,
      activityType: FilterActivityType.updateFromFilterPanel,
      filterInput: null,
    );
    return xFilterCriteria != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __defineFilterModelStructure() {
    try {
      _filterModelStructure = defineFilterModelStructure();
      _filterModelStructure.filterModel = this;
      __filterCriteriaPrecheck();
    }
    // criterionBaseName is not valid:
    on FilterCriterionInvalidBaseNameError catch (e) {
      String message = "Invalid criterionBaseName '${e.criterionBaseName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // fieldName is not valid:
    on FilterCriterionFieldNameInvalidError catch (e) {
      String message = "Invalid fieldName '${e.fieldName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // No Field Converter:
    on FilterCriterionNoFieldValueConverterError catch (e) {
      String message =
          "Data type of '${e.criterionBaseName}' is '${e.dataType}' (Not simple data type).\n"
          "So you need to provide toFieldValue() function.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // tildeCriterionName is not valid:
    on TildeFilterCriterionNameInvalidError catch (e) {
      String message = "Invalid tildeCriterionName '${e.tildeCriterionName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // parentMatchSuffix is not valid:
    on TildeFilterCriterionSuffixInvalidError catch (e) {
      String message =
          "Invalid parentMatchSuffix '${e.tildeSuffix}' (The correct examples: '~', '~1', '~min').\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // criterionBaseName not found:
    on TildeFilterCriterionBaseCriterionNotFoundError catch (e) {
      String message =
          "There is no criterionBaseName '${e.criterionBaseName}' corresponding to tildeCriterionName '${e.tildeCriterionName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // Duplicate criterionBaseName
    on FilterCriterionDuplicateNameError catch (e) {
      String message = "Duplicate criterionBaseName '${e.criterionBaseName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // Duplicate fieldName
    on FilterCriterionDuplicateFieldNameError catch (e) {
      String message =
          "Duplicate fieldName '${e.fieldName}' (criterionBaseName: ${e.criterionBaseName}).\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // TildeCriterionConfig - Invalid Suffix.
    on TildeCriterionConfigInvalidSuffixError catch (e) {
      String message =
          "Invalid TildeCriterionConfig(suffix: '${e.tildeSuffix}') (criterionBaseName: ${e.criterionBaseName}).\n"
          "The correct examples: '~', '~1', '~min'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // TildeCriterionConfig - Duplicate Suffix.
    on TildeCriterionConfigDuplicationSuffixError catch (e) {
      String message =
          "Duplicate TildeCriterionConfig(suffix: '${e.tildeSuffix}') (criterionBaseName: ${e.criterionBaseName}).\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // Duplicate tildeCriterionName in a Group:
    on FilterConditionGroupDuplicateTildeError catch (e) {
      String message =
          "Duplicate tildeCriterionName '${e.tildeCriterionName}' in '${e.groupName}' group.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // Duplicate groupName:
    on FilterConditionGroupDuplicateNameError catch (e) {
      String message = "Duplicate groupName '${e.groupName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // FilterCriteria class: Duplicate criterionName.
    on FilterCriteriaDuplicateCriterionError catch (e) {
      String message = "Duplicate criterionBaseName '${e.criterionBaseName}'.\n"
          "@see the '${e.filterCriteriaClassName}.registerSupportedCriteria()' method for details.";
      throw _createFatalAppError(message);
    }
    // FilterCriteria class: Duplicate Field.
    on FilterCriteriaDuplicateFieldError catch (e) {
      String message = "Duplicate field '${e.field}'.\n"
          "@see the '${e.filterCriteriaClassName}.registerSupportedCriteria()' method for details.";
      throw _createFatalAppError(message);
    }
    // Other Error:
    catch (e, stackTrace) {
      print(stackTrace);
      String message =
          "Unknown Error $e in ${getClassNameWithoutGenerics(this)}";
      throw _createFatalAppError(message);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Rename?
  Map<String, dynamic> get initialCriteriaValues {
    return _filterModelStructure._initialCriteriaValues;
  }

  // TODO: Rename?
  Map<String, dynamic> get criteriaValues {
    return _filterModelStructure._currentCriteriaValues;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isDirty() {
    return _filterModelStructure._isDirty();
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getTildeCriterionValue(String tildeCriterionName) {
    return _filterModelStructure._getCurrentCriterionValue(
      tildeCriterionName: tildeCriterionName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? getMultiOptTildeCriterionXData(String multiOptTildeCriterionName) {
    return _filterModelStructure._getMultiOptTildeCriterionXData(
      multiOptTildeCriterionName,
    );
  }

  dynamic getMultiOptTildeCriterionData(String multiOptTildeCriterionName) {
    XData? multiOptTildeCriterionXData = getMultiOptTildeCriterionXData(
      multiOptTildeCriterionName,
    );
    //
    dynamic data = multiOptTildeCriterionXData?.data;
    if (data != null) {
      return data;
    } else {
      return data;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printStructureAndTempData(String prefix) {
    _filterModelStructure._printTemporaryInfo(prefix);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _formKeyPatchValue({required Map<String, dynamic> newCurrentValue}) {
    try {
      FlutterArtist._lockAddMoreQuery = true;
      __lockAddMoreQuery = true;
      _formKey.currentState?.patchValue(newCurrentValue);
    } finally {
      FlutterArtist._lockAddMoreQuery = false;
      __lockAddMoreQuery = false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Return null is error.
  ///
  @_ImportantMethodAnnotation(
      "Called after changing in FilterPanel or Querying in Block or Scalar.")
  Future<XFilterCriteria<FILTER_CRITERIA>?> _startNewFilterActivity({
    required MasterFlowItem masterFlowItem,
    required FILTER_INPUT? filterInput,
    required FilterActivityType activityType,
  }) async {
    __filterActivityCount++;
    //
    if (activityType == FilterActivityType.newFilt) {
      __loadCount++;
      __clearFilterError();
    }
    final Map<String, dynamic> formKeyInstantValues =
        _formKey.currentState?.instantValue ?? {};
    //
    if (this is! _DefaultFilterModel) {
      masterFlowItem._addLineFlowItem(
        codeId: "#31020",
        shortDesc:
            "Calling <b>_filterModelStructure._setupTemporaryStateForNewActivity()</b>..",
        lineFlowType: LineFlowType.nonControllableCalling,
      );
    }
    try {
      _filterModelStructure._setupTemporaryStateForNewActivity(
        activityType: activityType,
        formKeyInstantValues: formKeyInstantValues,
        filterInput: filterInput,
      );
    } catch (e, stackTrace) {
      dynamic error = e;
      if (e is FilterCriterionTypeMismatchError) {
        // Bug: #Bug#002
        error = e.toAppError(
          filterModelName: getClassNameWithoutGenerics(this),
        );
      } else if (e is FilterMultiOptMsMismatchError) {
        // Bug: #Bug#003
        error = e.toAppError(
          filterModelName: getClassNameWithoutGenerics(this),
        );
      }
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "_setupTemporaryStateForNewActivity",
        error: error,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      masterFlowItem._addLineFlowItem(
        codeId: "#31030",
        shortDesc:
            "The ${debugObjHtml(this)}._loadMultiOptCriterionDataCascade() was called with an error.",
        errorInfo: errorInfo,
      );
      //
      _filterModelStructure._setFilterDataState(DataState.error);
      _xFilterCriteria = null;
      return _xFilterCriteria;
    }
    //
    // Load OptProp Data:
    //
    try {
      for (MultiOptTildeFilterCriterionModel multiOptCriterion
          in _filterModelStructure._rootOptCriterionModels) {
        masterFlowItem._addLineFlowItem(
          codeId: "#31040",
          shortDesc:
              "Calling ${debugObjHtml(this)}._loadMultiOptCriterionDataCascade() method "
              "to load data for ${debugObjHtml(multiOptCriterion)} and its descendants.",
          parameters: {
            "activityType": activityType,
            "filterInput": filterInput,
            "parentMultiOptTildeCriterionValue": null,
            "multiOptCriterion": multiOptCriterion,
            "formKeyInstantValues": formKeyInstantValues,
          },
          lineFlowType: LineFlowType.nonControllableCalling,
        );
        //
        // Load OptCriterion Data and set default and selected.
        //
        // May throw ApiError.
        //
        await _loadMultiOptCriterionDataCascade(
          masterFlowItem: masterFlowItem,
          filterInput: filterInput,
          parentMultiOptTildeCriterionValue: null,
          multiOptCriterion: multiOptCriterion,
          formKeyInstantValues: formKeyInstantValues,
          activityType: activityType,
        );
      }
    } catch (e, stackTrace) {
      final FilterErrorInfo filterErrorInfo;
      final dataStateError = DataState.error;
      if (e is FilterCriterionTypeMismatchError) {
        // Bug: #Bug#001
        filterErrorInfo = FilterErrorInfo(
          filterDataState: dataStateError,
          filterErrorMethod: FilterErrorMethod.unknown,
          activityType: activityType,
          tildeCriterionName: null,
          error: e.toAppError(
            filterModelName: getClassNameWithoutGenerics(this),
          ),
          errorStackTrace: stackTrace,
        );
      } else if (e is FilterMethodError) {
        // TODO-xxx
        filterErrorInfo = FilterErrorInfo(
          filterDataState: dataStateError,
          filterErrorMethod: e.filterErrorMethod,
          activityType: activityType,
          tildeCriterionName: e.tildeCriterionName,
          error: e.error,
          errorStackTrace: e.errorStackTrace,
        );
      } else {
        filterErrorInfo = FilterErrorInfo(
          filterDataState: dataStateError,
          filterErrorMethod: FilterErrorMethod.unknown,
          activityType: activityType,
          tildeCriterionName: null,
          error: e,
          errorStackTrace: stackTrace,
        );
      }
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: filterErrorInfo.methodName,
        error: filterErrorInfo.error,
        stackTrace: filterErrorInfo.errorStackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.filterModelPerformLoadMultiOptCriterionXData,
      );
      masterFlowItem._addLineFlowItem(
        codeId: "#31080",
        shortDesc:
            "The ${debugObjHtml(this)}._loadMultiOptCriterionDataCascade() was called with an error.",
        errorInfo: errorInfo,
      );
      //
      _filterModelStructure._setFilterDataState(dataStateError);
      __setErrorInfo(errorInfo);
      _xFilterCriteria = null;
      return _xFilterCriteria;
    }
    //
    if (filterInput != null) {
      try {
        masterFlowItem._addLineFlowItem(
          codeId: "#31140",
          shortDesc:
              "Calling ${debugObjHtml(this)}.updatedSimpleCriterionValues() method "
              "to get values from filterInput to update for simpleCriteria",
          parameters: {
            "filterInput": filterInput,
          },
          lineFlowType: LineFlowType.controllableCalling,
        );
        final Map<String, SimpleValueWrap?> updatedSimpleCriterionValues =
            extractUpdateValuesForSimpleTildeCriteria(
                  filterInput: filterInput,
                ) ??
                {};
        for (String tildeCriterionName in updatedSimpleCriterionValues.keys) {
          // Check and throw error if 'tildeCriterionName' is not a SimpleFilterCriterion:
          __throwErrorIfNotASimpleCriterionName(
            tildeCriterionName: tildeCriterionName,
            filterErrorMethod:
                FilterErrorMethod.extractUpdateValuesForSimpleTildeCriteria,
          );
          SimpleValueWrap? valueWrap =
              updatedSimpleCriterionValues[tildeCriterionName];
          // SAME-AS: #0012 (formModel)
          if (valueWrap != null) {
            _filterModelStructure._setTempSimpleCriterionValue(
              tildeCriterionName: tildeCriterionName,
              value: valueWrap.value,
            );
          }
        }
      } catch (e, stackTrace) {
        final ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: "extractUpdateValuesForSimpleTildeCriteria",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: null,
        );
        //
        masterFlowItem._addLineFlowItem(
          codeId: "#31200",
          shortDesc:
              "The ${debugObjHtml(this)}.updatedSimpleCriterionValues() method was called with an error.",
          errorInfo: errorInfo,
        );
        //
        _filterModelStructure._setFilterDataState(DataState.error);
        _xFilterCriteria = null;
        return _xFilterCriteria;
      }
    }
    // filterInput is null
    else {
      try {
        if (!__initiatedAtLeastOnce) {
          if (this is! _DefaultFilterModel) {
            masterFlowItem._addLineFlowItem(
              codeId: "#31300",
              shortDesc:
                  "Calling ${debugObjHtml(this)}.specifyDefaultValuesForSimpleTildeCriteria() method "
                  "to get default values for <b>simple criteria</b>.",
              lineFlowType: LineFlowType.controllableCalling,
            );
          }
          final Map<String, dynamic> defaultSimpleCriterionValues =
              specifyDefaultValuesForSimpleTildeCriteria() ?? {};

          for (String tildeCriterionName in defaultSimpleCriterionValues.keys) {
            // Check and throw error if 'tildeCriterionName' is not a SimpleFilterCriterion:
            __throwErrorIfNotASimpleCriterionName(
              tildeCriterionName: tildeCriterionName,
              filterErrorMethod:
                  FilterErrorMethod.specifyDefaultValuesForSimpleTildeCriteria,
            );
            //
            dynamic value = defaultSimpleCriterionValues[tildeCriterionName];
            _filterModelStructure._setTempSimpleCriterionValue(
              tildeCriterionName: tildeCriterionName,
              value: value,
            );
          }
        }
      } catch (e, stackTrace) {
        final ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: "specifyDefaultValuesForSimpleTildeCriteria",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: null,
        );
        masterFlowItem._addLineFlowItem(
          codeId: "#31380",
          shortDesc:
              "The ${debugObjHtml(this)}.specifyDefaultValuesForSimpleTildeCriteria() method was called with an error.",
          errorInfo: errorInfo,
        );
        //
        _filterModelStructure._setFilterDataState(DataState.error);
        _xFilterCriteria = null;
        return _xFilterCriteria;
      }
    }
    //
    try {
      if (this is! _DefaultFilterModel) {
        masterFlowItem._addLineFlowItem(
          codeId: "#31420",
          shortDesc:
              "Calling ${debugObjHtml(this)}.createNewFilterCriteria() method "
              "to convert criteria in type of Map to a Dart object.",
          parameters: {
            "dataMap": _filterModelStructure._tempCriteriaValues,
          },
          lineFlowType: LineFlowType.controllableCalling,
          tipDocument: TipDocument.filterCriteria,
        );
      }
      //
      // Update Real FromData from Temporary FormData:
      //
      _filterModelStructure._updateTempToReal();
      //
      // IMPORTANT:
      //
      _formKeyPatchValue(
        newCurrentValue: _filterModelStructure._currentCriteriaValues,
      );
      //
      final Map<String, dynamic> newCriteriaMap = {
        ..._filterModelStructure._tempCriteriaValues
      };

      FilterConditionGroupVal baseCriteria = _filterModelStructure
          .rootConditionGroupModel
          .toFilterCriteriaGroupVal();

      // Convert Map Data to FilterCriteria Object.
      final XFilterCriteria<FILTER_CRITERIA> newXFilterCriteria =
          __createXFilterCriteria(
        tildeCriteriaMap: newCriteriaMap,
        baseCriteria: baseCriteria,
        isPrecheck: false,
      );
      //
      if (this is! _DefaultFilterModel) {
        masterFlowItem._addLineFlowItem(
          codeId: "#31460",
          shortDesc:
              "Got an instance of ${debugObjHtml(newXFilterCriteria)} (Dart object).\n"
              "This object will be passed to the <b>@filterCriteria</b> parameter "
              "of the <b>Block.query()</b> or <b>Scalar.query()</b> method.",
          tipDocument: TipDocument.filterCriteria,
        );
      }
      //
      _xFilterCriteria = newXFilterCriteria;
      //
      __initiatedAtLeastOnce = true;
      _filterModelStructure._setFilterDataState(DataState.ready);
      //
      return _xFilterCriteria;
    } catch (e, stackTrace) {
      print(stackTrace);
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "createNewFilterCriteria",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      //
      _filterModelStructure._setFilterDataState(DataState.error);
      __setErrorInfo(errorInfo);
      //
      // IMPORTANT:
      //
      _formKeyPatchValue(
        newCurrentValue: _filterModelStructure._currentCriteriaValues,
      );
      //
      _xFilterCriteria = null;
      masterFlowItem._addLineFlowItem(
        codeId: "#31500",
        shortDesc:
            "The ${debugObjHtml(this)}.createNewFilterCriteria() method was called with an error!",
        errorInfo: errorInfo,
      );
      return _xFilterCriteria;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadMultiOptCriterionDataCascade({
    required MasterFlowItem masterFlowItem,
    required FILTER_INPUT? filterInput,
    required Object? parentMultiOptTildeCriterionValue,
    required MultiOptTildeFilterCriterionModel multiOptCriterion,
    required Map<String, dynamic> formKeyInstantValues,
    required FilterActivityType activityType,
  }) async {
    final String multiOptTildeCriterionName =
        multiOptCriterion.tildeCriterionName;
    final String multiOptCriterionBaseName = multiOptCriterion.criterionName;
    final SelectionType selectionType = multiOptCriterion.selectionType;

    masterFlowItem._addLineFlowItem(
      codeId: "#82000",
      shortDesc:
          "Begin of ${debugObjHtml(this)}._loadMultiOptCriterionDataCascade() method.",
      parameters: {
        "filterInput": filterInput,
        "parentMultiOptTildeCriterionValue": parentMultiOptTildeCriterionValue,
        "multiOptCriterion": multiOptCriterion,
        "activityType": activityType,
      },
      lineFlowType: LineFlowType.debug,
    );

    final MultiOptTildeFilterCriterionModel? multiOptCriterionParent =
        multiOptCriterion.parent;
    // Get current OptCriterion data:
    XData? tempMultiOptCriterionXData =
        _filterModelStructure._getTempMultiOptCriterionXData(
      multiOptTildeCriterionName,
    );
    final dynamic tempCurrentMultiOptValue =
        _filterModelStructure._getTempCurrentCriterionValue(
            tildeCriterionName: multiOptTildeCriterionName);
    //
    dynamic newSelectedValue =
        _filterModelStructure._getTempCurrentCriterionValue(
      tildeCriterionName: multiOptTildeCriterionName,
    );
    if (activityType == FilterActivityType.updateFromFilterPanel) {
      if (formKeyInstantValues.containsKey(multiOptTildeCriterionName)) {
        newSelectedValue = formKeyInstantValues[multiOptTildeCriterionName];
      }
    }
    //
    final bool valueChanged;
    if (tempMultiOptCriterionXData == null) {
      valueChanged = false;
    } else {
      valueChanged = !tempMultiOptCriterionXData.isSameItemOrItemList(
        itemOrItemList1: tempCurrentMultiOptValue,
        itemOrItemList2: newSelectedValue,
      );
    }
    masterFlowItem._addLineFlowItem(
      codeId: "#82100",
      shortDesc: "Debug:",
      parameters: {
        "tempCurrentMultiOptValue": tempCurrentMultiOptValue,
        "newSelectedValue": newSelectedValue,
        "valueChanged": valueChanged,
      },
      lineFlowType: LineFlowType.debug,
    );
    // May throw Type error here!
    multiOptCriterion._tempCurrentValue = newSelectedValue;
    //
    if (valueChanged) {
      _filterModelStructure._updateChildrenMultiOptValueToNullCascade(
        multiOptCriterion: multiOptCriterion,
      );
    }
    //
    if (multiOptCriterionParent != null) {
      XData? tempMultiOptXDataParent =
          _filterModelStructure._getTempMultiOptCriterionXData(
        multiOptCriterionParent.tildeCriterionName,
      );
      //
      if (tempMultiOptXDataParent != null) {
        // Item or Item List (Multi Selection):
        Object? parentOptCriterionValueOLD =
            _filterModelStructure._getCurrentCriterionValue(
          tildeCriterionName: multiOptCriterionParent.tildeCriterionName,
        );
        // Parent Value change?
        bool isSame = tempMultiOptXDataParent.isSameItemOrItemList(
          itemOrItemList1: parentOptCriterionValueOLD,
          itemOrItemList2: parentMultiOptTildeCriterionValue,
        );
        if (!isSame) {
          tempMultiOptCriterionXData = null;
        }
      } else {
        tempMultiOptCriterionXData = null;
      }
    }
    //
    if (tempMultiOptCriterionXData == null) {
      _filterModelStructure._setTempMultiOptCriterionXData(
        multiOptTildeCriterionName: multiOptTildeCriterionName,
        multiOptXData: null,
      );
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterModelStructure._updateCriteriaTempValues({
        multiOptTildeCriterionName: null,
      });
    }
    bool newLoaded = false;
    if (tempMultiOptCriterionXData == null) {
      // Always increase "_loadCount" value regardless of error.
      multiOptCriterion._loadCount++;
      newLoaded = true;
      //
      try {
        masterFlowItem._addLineFlowItem(
          codeId: "#82300",
          shortDesc:
              "Calling ${debugObjHtml(this)}.performLoadMultiOptTildeCriterionXData():",
          parameters: {
            "filterInput": filterInput,
            "parentMultiOptTildeCriterionValue":
                parentMultiOptTildeCriterionValue,
            "multiOptCriterionBaseName": multiOptCriterionBaseName,
            "multiOptTildeCriterionName": multiOptTildeCriterionName,
            "selectionType": selectionType,
          },
          lineFlowType: LineFlowType.debug,
        );
        // May throw AppError, ApiError or others.
        //
        // Load OptCriterion data from Rest API.
        // May throw ApiError.
        //
        tempMultiOptCriterionXData =
            await performLoadMultiOptTildeCriterionXData(
          filterInput: filterInput,
          parentMultiOptTildeCriterionValue: parentMultiOptTildeCriterionValue,
          multiOptCriterionBaseName: multiOptCriterionBaseName,
          multiOptTildeCriterionName: multiOptTildeCriterionName,
          selectionType: selectionType,
        );
        masterFlowItem._addLineFlowItem(
          codeId: "#82400",
          shortDesc: "Debug. Return value: ",
          parameters: {
            "tempMultiOptCriterionXData": tempMultiOptCriterionXData,
          },
          lineFlowType: LineFlowType.debug,
        );
      } catch (e, stackTrace) {
        // TODO: Test Case??
        throw FilterMethodError(
          tildeCriterionName: multiOptTildeCriterionName,
          filterErrorMethod:
              FilterErrorMethod.performLoadMultiOptTildeCriterionXData,
          error: e, // May be AppError, ApiError or others.
          errorStackTrace: stackTrace,
        );
      }
    }
    //
    // IMPORTANT: Do not use empty list here
    // to avoid cast Error (List<dynamic> to List<ITEM>)
    //
    List? currentSelectedItems; // will be null or not empty.
    // Candidate Selected Items:
    List? candidateSelectedItems;
    if (tempMultiOptCriterionXData != null) {
      OptValueWrap? inputValueWrap;
      if (filterInput != null) {
        // Test Case: [20c], [20d].
        inputValueWrap = __extractUpdateValueForMultiOptTildeCriterion(
          filterInput: filterInput,
          parentMultiOptTildeCriterionValue: parentMultiOptTildeCriterionValue,
          multiOptTildeCriterionXData: tempMultiOptCriterionXData,
          multiOptCriterionBaseName: multiOptCriterionBaseName,
          multiOptTildeCriterionName: multiOptTildeCriterionName,
          selectionType: selectionType,
        );
      } else {
        final parentMatchSuffix = multiOptCriterion.parentMatchSuffix;
        final defaultSettingPolicy = multiOptCriterion.defaultSettingPolicy;
        if ((!__initiatedAtLeastOnce &&
                defaultSettingPolicy == DefaultSettingPolicy.onInitialOnly) ||
            (newLoaded &&
                multiOptCriterion._tempCurrentValue == null &&
                defaultSettingPolicy == DefaultSettingPolicy.onEveryLoad)) {
          masterFlowItem._addLineFlowItem(
            codeId: "#82460",
            shortDesc:
                "Calling ${debugObjHtml(this)}.__specifyDefaultValueForMultiOptTildeCriterion():",
            parameters: {
              "parentMultiOptTildeCriterionValue":
                  parentMultiOptTildeCriterionValue,
              "multiOptCriterionBaseName": multiOptCriterionBaseName,
              "multiOptTildeCriterionName": multiOptTildeCriterionName,
              "selectionType": selectionType,
            },
            lineFlowType: LineFlowType.nonControllableCalling,
          );
          inputValueWrap = __specifyDefaultValueForMultiOptTildeCriterion(
            multiOptCriterionBaseName: multiOptCriterionBaseName,
            multiOptTildeCriterionName: multiOptTildeCriterionName,
            parentMultiOptTildeCriterionValue:
                parentMultiOptTildeCriterionValue,
            multiOptTildeCriterionXData: tempMultiOptCriterionXData,
            selectionType: selectionType,
          );
          masterFlowItem._addLineFlowItem(
            codeId: "#82470",
            shortDesc: "Debug",
            parameters: {
              "inputValueWrap": inputValueWrap,
            },
            lineFlowType: LineFlowType.debug,
          );
        }
      }
      //
      // Current selected value:
      // It can be a single value or a List.
      //
      final dynamic tempCurrentValue =
          _filterModelStructure._getTempCurrentCriterionValue(
        tildeCriterionName: multiOptTildeCriterionName,
      );
      //
      if (tempCurrentValue != null) {
        if (tempCurrentValue is List) {
          currentSelectedItems =
              tempCurrentValue.isEmpty ? null : tempCurrentValue;
        } else {
          currentSelectedItems = [tempCurrentValue];
        }
      }
      if (currentSelectedItems != null) {
        currentSelectedItems =
            tempMultiOptCriterionXData._findInternalItemsByDynamics(
          dynamicValues: currentSelectedItems,
          removeCurrentNotFoundItems: true,
          addToInternalIfNotFound: false,
        );
      }
      // Candidate Selected Items:
      candidateSelectedItems = inputValueWrap?.values;

      if (candidateSelectedItems == null || candidateSelectedItems.isEmpty) {
        candidateSelectedItems = currentSelectedItems;
      }
    } else {
      currentSelectedItems = null;
      candidateSelectedItems = null;
    }
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#82600",
      shortDesc:
          "Calling ${debugObjHtml(this)}._setTempMultiOptCriterionXData():",
      parameters: {
        "multiOptTildeCriterionName": multiOptTildeCriterionName,
        "multiOptXData": tempMultiOptCriterionXData,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    _filterModelStructure._setTempMultiOptCriterionXData(
      multiOptTildeCriterionName: multiOptTildeCriterionName,
      multiOptXData: tempMultiOptCriterionXData,
    );
    //
    // TODO: Double check this code:
    //
    if (candidateSelectedItems != null && candidateSelectedItems.isNotEmpty) {
      if (multiOptCriterion.selectionType == SelectionType.single) {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
        Object? candidateSelectedItem = candidateSelectedItems.first;
        _filterModelStructure._updateCriteriaTempValues({
          multiOptTildeCriterionName: candidateSelectedItem,
        });
      } else {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _filterModelStructure._updateCriteriaTempValues({
          multiOptTildeCriterionName: candidateSelectedItems,
        });
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterModelStructure._updateCriteriaTempValues({
        multiOptTildeCriterionName: null,
      });
    }
    //
    Object? tempSelectedCriterionValue =
        _filterModelStructure._getTempCurrentCriterionValue(
      tildeCriterionName: multiOptTildeCriterionName,
    );
    masterFlowItem._addLineFlowItem(
      codeId: "#82800",
      shortDesc: "Debug:",
      parameters: {
        "tildeCriterionName": multiOptTildeCriterionName,
        "tempSelectedCriterionValue": tempSelectedCriterionValue,
      },
      lineFlowType: LineFlowType.debug,
    );

    if (tempSelectedCriterionValue != null) {
      for (MultiOptTildeFilterCriterionModel child
          in multiOptCriterion.children) {
        await _loadMultiOptCriterionDataCascade(
          masterFlowItem: masterFlowItem,
          filterInput: filterInput,
          parentMultiOptTildeCriterionValue: tempSelectedCriterionValue,
          multiOptCriterion: child,
          activityType: activityType,
          formKeyInstantValues: formKeyInstantValues,
        );
      }
    } else {
      // Do nothing.
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __createNullValueWrapAppError({
    required String methodName,
    required String multiOptTildeCriterionName,
  }) {
    MultiOptTildeFilterCriterionModel? multiOptCriterion = _filterModelStructure
        ._getMultiOptFilterCriterion(multiOptTildeCriterionName);
    if (multiOptCriterion == null) {
      throw "The '$multiOptTildeCriterionName' is not $MultiOptTildeFilterCriterionModel";
    }
    String message =
        "The ${getClassName(this)}.$methodName() method must return a non-null $OptValueWrap for the multiOptTildeCriterionName '$multiOptTildeCriterionName'. ";
    if (multiOptCriterion.selectionType == SelectionType.single) {
      message += "$OptValueWrap.single(null) or $OptValueWrap.single(value). ";
    } else {
      message +=
          "$OptValueWrap.multi([null]) or $OptValueWrap.multi([value]). ";
    }
    message +=
        "And return null for not $MultiOptTildeFilterCriterionModel. See the specification of this method for more information.";
    // throw AppError(errorMessage: message);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __throwErrorIfNotASimpleCriterionName({
    required String tildeCriterionName,
    required FilterErrorMethod filterErrorMethod,
  }) {
    if (_filterModelStructure._isMultiOptFilterCriterion(tildeCriterionName)) {
      throw DevError(
        errorMessage:
            '$tildeCriterionName is not a ${getTypeNameWithoutGenerics(SimpleTildeFilterCriterionModel)}',
        errorDetails: [
          "See ${getClassNameWithoutGenerics(this)}.${getClassNameWithoutGenerics(filterErrorMethod)}() method."
        ],
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  OptValueWrap? __extractUpdateValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required XData multiOptTildeCriterionXData,
    required FILTER_INPUT filterInput,
  }) {
    OptValueWrap? valueWrap = extractUpdateValueForMultiOptTildeCriterion(
      filterInput: filterInput,
      parentMultiOptTildeCriterionValue: parentMultiOptTildeCriterionValue,
      multiOptTildeCriterionXData: multiOptTildeCriterionXData,
      multiOptCriterionBaseName: multiOptCriterionBaseName,
      multiOptTildeCriterionName: multiOptTildeCriterionName,
      selectionType: selectionType,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppError(
        methodName: "extractUpdateValueForMultiOptTildeCriterion",
        multiOptTildeCriterionName: multiOptTildeCriterionName,
      );
      return null;
    }
    List? value = valueWrap.values;
    return OptValueWrap.multi(
      multiOptTildeCriterionXData._findInternalItemsByDynamics(
        dynamicValues: value,
        addToInternalIfNotFound: false,
        removeCurrentNotFoundItems: true,
      ),
    );
  }

  OptValueWrap? __specifyDefaultValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required XData multiOptTildeCriterionXData,
  }) {
    OptValueWrap? valueWrap = specifyDefaultValueForMultiOptTildeCriterion(
      multiOptCriterionBaseName: multiOptCriterionBaseName,
      multiOptTildeCriterionName: multiOptTildeCriterionName,
      parentMultiOptTildeCriterionValue: parentMultiOptTildeCriterionValue,
      multiOptTildeCriterionXData: multiOptTildeCriterionXData,
      selectionType: selectionType,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppError(
        methodName: "specifyDefaultValueForMultiOptTildeCriterion",
        multiOptTildeCriterionName: multiOptTildeCriterionName,
      );
    }
    List? value = valueWrap?.values ?? [];
    return OptValueWrap.multi(
      multiOptTildeCriterionXData._findInternalItemsByDynamics(
        dynamicValues: value,
        addToInternalIfNotFound: false,
        removeCurrentNotFoundItems: true,
      ),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Used for FilterPanel.
  ///
  Map<String, dynamic> _initialValuesForFilterPanel() {
    return _filterModelStructure._currentCriteriaValues;
  }

  // ***************************************************************************
  // ***************************************************************************

  // Change Event from GUI.
  @_ImportantMethodAnnotation(
      "Called when the user makes a change on the FilterPanel")
  @_FilterPanelChangeAnnotation()
  Future<void> _onChangeFromFilterPanel() async {
    print("#~~~~~~~~~~~~~~~> _onChangeFromFilterPanel");
    //
    final XShelf xShelf = _XShelfFilterPanelChange(filterModel: this);
    //
    final XFilterModel xFilterModel = xShelf.findXFilterModelByName(name)!;
    _FilterPanelChangeTaskUnit taskUnit = _FilterPanelChangeTaskUnit(
      xFilterModel: xFilterModel,
    );
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _afterBuildFilterPanel() {
    //
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isEnabled() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  String get debugClassDefinition {
    return "${getClassName(this)}$debugClassParametersDefinition";
  }

  @DebugMethodAnnotation()
  String get debugClassParametersDefinition {
    return "<${getFilterInputType()}, ${getFilterCriteriaType()}>";
  }

  Type getFilterCriteriaType() {
    return FILTER_CRITERIA;
  }

  Type getFilterInputType() {
    return FILTER_INPUT;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Query all Scalars and Blocks of this FilterModel.
  ///
  @_RootMethodAnnotation()
  Future<bool> queryAll({
    FILTER_INPUT? filterInput,
  }) async {
    if (__lockAddMoreQuery) {
      return false;
    }
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryAll",
      parameters: {
        "filterInput": filterInput,
      },
      navigate: null,
      isLibMethod: true,
    );
    // Test Cases: [48b] - query() & queryAll().
    return await __query(
      masterFlowItem: masterFlowItem,
      methodName: "queryAll",
      filterInput: filterInput,
      forceQueryAll: true,
    );
  }

  ///
  /// Query all Scalars and Blocks of this FilterModel if they are visible on the UI.
  ///
  /// Any Scalar or Block that is not queried will be set to LAZY state.
  ///
  @_RootMethodAnnotation()
  Future<bool> query({
    FILTER_INPUT? filterInput,
  }) async {
    if (__lockAddMoreQuery) {
      return false;
    }
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "query",
      parameters: {
        "filterInput": filterInput,
      },
      navigate: null,
      isLibMethod: true,
    );
    // Test Cases: [48b] - query() & queryAll().
    return await __query(
      masterFlowItem: masterFlowItem,
      methodName: "query",
      filterInput: filterInput,
      forceQueryAll: false,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> __query({
    required MasterFlowItem masterFlowItem,
    FILTER_INPUT? filterInput,
    required String methodName,
    required bool forceQueryAll,
  }) async {
    if (__lockAddMoreQuery) {
      return false;
    }
    masterFlowItem._addLineFlowItem(
      codeId: "#55000",
      shortDesc: "Creating <b>$_XShelfFilterModelQuery</b>..",
    );
    //
    final XShelf xShelf = _XShelfFilterModelQuery(
      filterModel: this,
      filterInput: filterInput,
      forceQueryAll: forceQueryAll,
    );
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#55100",
      shortDesc: "Calling ${debugObjHtml(xShelf)}._initQueryTaskUnits()..",
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    xShelf._initQueryTaskUnits(masterFlowItem: masterFlowItem);
    //
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugFilterModelViewerDialog() async {
    BuildContext context =
        FlutterArtist.coreFeaturesAdapter.getCurrentContext();
    //
    await DebugViewerDialog.openDebugFilterModelViewer(
      context: context,
      locationInfo: "locationInfo", // TODO: Remove.
      filterModel: this,
    );
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
      filterModel: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0009 (form)
  MultiOptTildeFilterCriterionModel? findMultiOptFilterCriterion({
    required String multiOptTildeCriterionName,
  }) {
    return _filterModelStructure._findMultiOptFilterCriterion(
      multiOptTildeCriterionName: multiOptTildeCriterionName,
    );
  }

  // SAME-AS: #0008 (formModel.debugGetMultiOptPropLoadCount())
  int debugGetMultiOptCriteriaLoadCount(String multiOptTildeCriterionName) {
    return _filterModelStructure._debugGetMultiOptCriterionLoadCount(
      multiOptTildeCriterionName: multiOptTildeCriterionName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXFilterModel(XFilterModel thisXFilterModel) {
    if (!identical(thisXFilterModel.filterModel, this)) {
      String message =
          "Error Assert filter model: ${thisXFilterModel.filterModel} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
