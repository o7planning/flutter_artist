part of '../core.dart';

abstract class FilterModel<
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria // EmptyFilterCriteria
    > extends _Core {
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

  bool _loadTimeUIActive = false;

  bool get loadTimeUIActive => _loadTimeUIActive;

  bool __initiatedAtLeastOnce = false;

  bool get initiatedAtLeastOnce => __initiatedAtLeastOnce;

  bool __lockAddMoreQuery = false;

  bool get lockAddMoreQuery => __lockAddMoreQuery;

  bool _isDefaultFilterModel = false;

  bool get isDefaultFilterModel => _isDefaultFilterModel;

  late final FilterModelStructure _filterModelStructure;

  FilterModelStructure get filterModelStructure => _filterModelStructure;

  DataState get dataState => _filterModelStructure._filterDataState;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  late final ui = _FilterUIComponents(filterModel: this);

  // ***************************************************************************
  // ***************************************************************************

  FilterModel({
    FilterModelConfig config = const FilterModelConfig(),
  }) : config = config.copy() {
    __registerCriteriaStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// ```dart
  /// FilterCriteriaStructure registerCriteriaStructure() {
  ///   return FilterCriteriaStructure(
  ///     simpleCriteria: [],
  ///     multiOptCriteria: [
  ///       // Multi Options Single Selection Criterion:
  ///       MultiOptSsCriterion(
  ///         criterionNameX: "company",
  ///         children: [
  ///           // Multi Options Multi Selections Criterion:
  ///           MultiOptMsCriterion(
  ///              criterionNameX: "department",
  ///           ),
  ///         ],
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  FilterModelStructure registerCriteriaStructure();

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  @_AbstractMethodAnnotation()
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionName,
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required FILTER_INPUT? filterInput,
    required Object? parentMultiOptCriterionValue,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  OptValueWrap? specifyDefaultValueForMultiOptCriterion({
    required String multiOptCriterionName,
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  // SAME-AS: #0011 (form - specifyDefaultValuesForSimpleProps)
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? specifyDefaultValuesForSimpleCriteria();

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  ///
  /// ```dart
  /// @override
  /// ValueWrap? getUpdatedValueForMultiOptCriterion({
  ///     required String multiOptCriterionNameX,
  ///     required SelectionType selectionType,
  ///     required ExampleFilterInput filterInput,
  ///     required XData multiOptCriterionXData,
  ///     required Object? parentMultiOptCriterionValue,
  /// }) {
  ///    if(multiOptCriterionNameX == "company") {
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
  OptValueWrap? getUpdatedValueForMultiOptCriterion({
    required String multiOptCriterionName,
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required FILTER_INPUT filterInput,
    required Object? parentMultiOptCriterionValue,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  // OLD: getSimpleCriterionValuesFromFilterInput.
  // SAME-AS: #0010 (form - getUpdatedValuesForSimpleProps)
  @_AbstractMethodAnnotation()
  Map<String, SimpleValueWrap?>? getUpdatedValuesForSimpleCriteria({
    required FILTER_INPUT filterInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called immediately after
  /// calling [callApiLoadMultiOptCriterionXData]
  /// methods if there are no errors.
  ///
  /// ```
  ///  MyFilterCriteria toFilterCriteriaObject({
  ///     required Map<String, dynamic> criteriaMap,
  ///  }) {
  ///      return MyFilterCriteria(
  ///         company: criteriaMap["company"],
  ///         department: criteriaMap["department"],
  ///      );
  ///  }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  FILTER_CRITERIA toFilterCriteriaObject({
    required Map<String, dynamic> criteriaMap,
  });

  XFilterCriteria<FILTER_CRITERIA> _toXFilterCriteria({
    required Map<String, dynamic> criteriaMap,
  }) {
    FILTER_CRITERIA filterCriteria = toFilterCriteriaObject(
      criteriaMap: criteriaMap,
    );
    return XFilterCriteria(
      filterCriteria: filterCriteria,
      filterCriteriaMap: criteriaMap,
    );
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

  void __registerCriteriaStructure() {
    try {
      _filterModelStructure = registerCriteriaStructure();
      _filterModelStructure.filterModel = this;
    } on DuplicateFilterCriterionXError catch (e) {
      String message =
          "Duplicate criterion '${e.criterionNameX}' in ${getClassName(this)}";
      throw _createFatalAppError(message);
    } catch (e, stackTrace) {
      print(stackTrace);
      String message = "Unknown Error $e in ${getClassName(this)}";
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

  dynamic getCriterionValue(String criterionNameX) {
    return _filterModelStructure._getCurrentCriterionValue(
      criterionNameX: criterionNameX,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? getMultiOptCriterionXData(String multiOptCriterionNameX) {
    return _filterModelStructure._getMultiOptCriterionXData(
      multiOptCriterionNameX,
    );
  }

  dynamic getMultiOptCriterionData(String multiOptCriterionNameX) {
    XData? multiOptCriterionXData = getMultiOptCriterionXData(
      multiOptCriterionNameX,
    );
    //
    dynamic data = multiOptCriterionXData?.data;
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
    }
    final Map<String, dynamic> formKeyInstantValues =
        _formKey.currentState?.instantValue ?? {};
    //
    if (this is! _DefaultFilterModel) {
      masterFlowItem._addLineFlowItem(
        codeId: "#31020",
        shortDesc:
            "Calling <b>_filterModelStructure._initTemporaryForNewActivity()</b>..",
        lineFlowType: LineFlowType.nonControllableCalling,
      );
    }
    _filterModelStructure._initTemporaryForNewActivity(
      activityType: activityType,
      formKeyInstantValues: formKeyInstantValues,
      filterInput: filterInput,
    );
    //
    // Load OptProp Data:
    //
    try {
      for (MultiOptFilterCriterionModel multiOptCriterion
          in _filterModelStructure._rootOptCriterionModels) {
        masterFlowItem._addLineFlowItem(
          codeId: "#31040",
          shortDesc:
              "Calling ${debugObjHtml(this)}._loadMultiOptCriterionDataCascade() method "
              "to load data for ${debugObjHtml(multiOptCriterion)} and its descendants.",
          parameters: {
            "activityType": activityType,
            "filterInput": filterInput,
            "parentMultiOptCriterionValue": null,
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
          parentMultiOptCriterionValue: null,
          multiOptCriterion: multiOptCriterion,
          formKeyInstantValues: formKeyInstantValues,
          activityType: activityType,
        );
      }
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "callApiLoadMultiOptCriterionXData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.filterModelCallApiLoadMultiOptCriterionXData,
      );
      masterFlowItem._addLineFlowItem(
        codeId: "#31080",
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
            getUpdatedValuesForSimpleCriteria(
                  filterInput: filterInput,
                ) ??
                {};
        for (String criterionNameX in updatedSimpleCriterionValues.keys) {
          // Check and throw error if 'criterionNameX' is not a SimpleFilterCriterion:
          __throwErrorIfNotASimpleCriterionName(
            criterionNameX: criterionNameX,
            filterErrorMethod:
                FilterErrorMethod.getUpdatedValuesForSimpleCriteria,
          );
          SimpleValueWrap? valueWrap =
              updatedSimpleCriterionValues[criterionNameX];
          // SAME-AS: #0012 (formModel)
          if (valueWrap != null) {
            _filterModelStructure._setTempSimpleCriterionValue(
              criterionNameX: criterionNameX,
              value: valueWrap.value,
            );
          }
        }
      } catch (e, stackTrace) {
        final ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: "getUpdatedValuesForSimpleCriteria",
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
                  "Calling ${debugObjHtml(this)}.specifyDefaultValuesForSimpleCriteria() method "
                  "to get default values for <b>simple criteria</b>.",
              lineFlowType: LineFlowType.controllableCalling,
            );
          }
          final Map<String, dynamic> defaultSimpleCriterionValues =
              specifyDefaultValuesForSimpleCriteria() ?? {};

          for (String criterionNameX in defaultSimpleCriterionValues.keys) {
            // Check and throw error if 'criterionNameX' is not a SimpleFilterCriterion:
            __throwErrorIfNotASimpleCriterionName(
              criterionNameX: criterionNameX,
              filterErrorMethod:
                  FilterErrorMethod.specifyDefaultValuesForSimpleCriteria,
            );
            //
            dynamic value = defaultSimpleCriterionValues[criterionNameX];
            _filterModelStructure._setTempSimpleCriterionValue(
              criterionNameX: criterionNameX,
              value: value,
            );
          }
        }
      } catch (e, stackTrace) {
        final ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: "specifyDefaultValuesForSimpleCriteria",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: null,
        );
        masterFlowItem._addLineFlowItem(
          codeId: "#31380",
          shortDesc:
              "The ${debugObjHtml(this)}.specifyDefaultValuesForSimpleCriteria() method was called with an error.",
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
              "Calling ${debugObjHtml(this)}.toFilterCriteriaObject() method "
              "to convert criteria in type of Map to a Dart object.",
          parameters: {
            "dataMap": _filterModelStructure._tempCriteriaValues,
          },
          lineFlowType: LineFlowType.controllableCalling,
          tipDocument: TipDocument.filterCriteria,
        );
      }
      //
      final Map<String, dynamic> newCriteriaMap = {
        ..._filterModelStructure._tempCriteriaValues
      };
      // Convert Map Data to FilterCriteria Object.
      final XFilterCriteria<FILTER_CRITERIA> newCriteriaCouple =
          _toXFilterCriteria(
        criteriaMap: newCriteriaMap,
      );
      // _filterCriteria = newCriteria; // has moved down.
      //
      if (this is! _DefaultFilterModel) {
        masterFlowItem._addLineFlowItem(
          codeId: "#31460",
          shortDesc:
              "Got an instance of ${debugObjHtml(newCriteriaCouple)} (Dart object).\n"
              "This object will be passed to the <b>@filterCriteria</b> parameter "
              "of the <b>Block.query()</b> or <b>Scalar.query</b> method.",
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
      __initiatedAtLeastOnce = true;
      _filterModelStructure._setFilterDataState(DataState.ready);
      //
      _xFilterCriteria = newCriteriaCouple;
      return _xFilterCriteria;
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "toFilterCriteriaObject",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      _filterModelStructure._setFilterDataState(DataState.error);
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
            "The ${debugObjHtml(this)}.toFilterCriteriaObject() method was called with an error!",
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
    required Object? parentMultiOptCriterionValue,
    required MultiOptFilterCriterionModel multiOptCriterion,
    required Map<String, dynamic> formKeyInstantValues,
    required FilterActivityType activityType,
  }) async {
    final String multiOptCriterionNameX = multiOptCriterion.criterionNameX;
    final SelectionType selectionType = multiOptCriterion.selectionType;

    masterFlowItem._addLineFlowItem(
      codeId: "#82000",
      shortDesc:
          "Begin of ${debugObjHtml(this)}._loadMultiOptCriterionDataCascade() method.",
      parameters: {
        "filterInput": filterInput,
        "parentMultiOptCriterionValue": parentMultiOptCriterionValue,
        "multiOptCriterion": multiOptCriterion,
        "activityType": activityType,
      },
      lineFlowType: LineFlowType.debug,
    );

    final MultiOptFilterCriterionModel? multiOptCriterionParent =
        multiOptCriterion.parent;

    // Get current OptCriterion data:
    XData? tempMultiOptCriterionXData =
        _filterModelStructure._getTempMultiOptCriterionXData(
      multiOptCriterionNameX,
    );
    final dynamic tempCurrentMultiOptValue = _filterModelStructure
        ._getTempCurrentCriterionValue(criterionNameX: multiOptCriterionNameX);

    //
    dynamic newSelectedValue =
        _filterModelStructure._getTempCurrentCriterionValue(
      criterionNameX: multiOptCriterionNameX,
    );
    if (activityType == FilterActivityType.updateFromFilterPanel) {
      if (formKeyInstantValues.containsKey(multiOptCriterionNameX)) {
        newSelectedValue = formKeyInstantValues[multiOptCriterionNameX];
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
    //
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
        multiOptCriterionParent.criterionNameX,
      );
      //
      if (tempMultiOptXDataParent != null) {
        // Item or Item List (Multi Selection):
        Object? parentOptCriterionValueOLD =
            _filterModelStructure._getCurrentCriterionValue(
          criterionNameX: multiOptCriterionParent.criterionNameX,
        );
        // Parent Value change?
        bool isSame = tempMultiOptXDataParent.isSameItemOrItemList(
          itemOrItemList1: parentOptCriterionValueOLD,
          itemOrItemList2: parentMultiOptCriterionValue,
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
        multiOptCriterionNameX: multiOptCriterionNameX,
        multiOptXData: null,
      );
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterModelStructure._updateCriteriaTempValues({
        multiOptCriterionNameX: null,
      });
    }

    if (tempMultiOptCriterionXData == null) {
      // Always increase "_loadCount" value regardless of error.
      multiOptCriterion._loadCount++;
      //
      try {
        masterFlowItem._addLineFlowItem(
          codeId: "#82300",
          shortDesc:
              "Calling ${debugObjHtml(this)}.callApiLoadMultiOptCriterionXData():",
          parameters: {
            "filterInput": filterInput,
            "parentMultiOptCriterionValue": parentMultiOptCriterionValue,
            "multiOptCriterionNameX": multiOptCriterionNameX,
            "selectionType": selectionType,
          },
          lineFlowType: LineFlowType.debug,
        );
        // May throw AppError, ApiError or others.
        //
        // Load OptCriterion data from Rest API.
        // May throw ApiError.
        //
        tempMultiOptCriterionXData = await callApiLoadMultiOptCriterionXData(
          filterInput: filterInput,
          parentMultiOptCriterionValue: parentMultiOptCriterionValue,
          multiOptCriterionName: "@@XXX@@",
          multiOptCriterionNameX: multiOptCriterionNameX,
          selectionType: selectionType,
        );
      } catch (e, stackTrace) {
        // TODO: Test Case??
        throw FilterTempError(
          propName: multiOptCriterionNameX,
          filterErrorMethod:
              FilterErrorMethod.callApiLoadMultiOptCriterionXData,
          error: e, // May be AppError, ApiError or others.
          stackTrace: stackTrace,
        );
      }
    }
    masterFlowItem._addLineFlowItem(
      codeId: "#82400",
      shortDesc: "Debug. Return value: ",
      parameters: {
        "tempMultiOptCriterionXData": tempMultiOptCriterionXData,
      },
      lineFlowType: LineFlowType.debug,
    );
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
        inputValueWrap = __getUpdatedValueForMultiOptCriterion(
          filterInput: filterInput,
          parentMultiOptCriterionValue: parentMultiOptCriterionValue,
          multiOptCriterionXData: tempMultiOptCriterionXData,
          multiOptCriterionName: "@@XXX@@",
          multiOptCriterionNameX: multiOptCriterionNameX,
          selectionType: selectionType,
        );
      } else {
        if (!__initiatedAtLeastOnce) {
          masterFlowItem._addLineFlowItem(
            codeId: "#82460",
            shortDesc:
                "Calling ${debugObjHtml(this)}.__specifyDefaultValueForMultiOptCriterion():",
            parameters: {
              "parentMultiOptCriterionValue": parentMultiOptCriterionValue,
              "multiOptCriterionNameX": multiOptCriterionNameX,
              "selectionType": selectionType,
            },
            lineFlowType: LineFlowType.nonControllableCalling,
          );

          inputValueWrap = __specifyDefaultValueForMultiOptCriterion(
            multiOptCriterionName: "@@XXX@@",
            parentMultiOptCriterionValue: parentMultiOptCriterionValue,
            multiOptCriterionXData: tempMultiOptCriterionXData,
            multiOptCriterionNameX: multiOptCriterionNameX,
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
        criterionNameX: multiOptCriterionNameX,
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
        "multiOptCriterionNameX": multiOptCriterionNameX,
        "multiOptXData": tempMultiOptCriterionXData,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    _filterModelStructure._setTempMultiOptCriterionXData(
      multiOptCriterionNameX: multiOptCriterionNameX,
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
          multiOptCriterionNameX: candidateSelectedItem,
        });
      } else {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _filterModelStructure._updateCriteriaTempValues({
          multiOptCriterionNameX: candidateSelectedItems,
        });
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterModelStructure._updateCriteriaTempValues({
        multiOptCriterionNameX: null,
      });
    }
    //
    Object? tempSelectedCriterionValue =
        _filterModelStructure._getTempCurrentCriterionValue(
      criterionNameX: multiOptCriterionNameX,
    );
    masterFlowItem._addLineFlowItem(
      codeId: "#82800",
      shortDesc: "Debug:",
      parameters: {
        "criterionNameX": multiOptCriterionNameX,
        "tempSelectedCriterionValue": tempSelectedCriterionValue,
      },
      lineFlowType: LineFlowType.debug,
    );

    if (tempSelectedCriterionValue != null) {
      for (MultiOptFilterCriterionModel child in multiOptCriterion.children) {
        await _loadMultiOptCriterionDataCascade(
          masterFlowItem: masterFlowItem,
          filterInput: filterInput,
          parentMultiOptCriterionValue: tempSelectedCriterionValue,
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
    required String multiOptCriterionNameX,
  }) {
    MultiOptFilterCriterionModel? multiOptCriterion = _filterModelStructure
        ._getMultiOptFilterCriterion(multiOptCriterionNameX);
    if (multiOptCriterion == null) {
      throw "The '$multiOptCriterionNameX' is not $MultiOptFilterCriterionModel";
    }
    String message =
        "The ${getClassName(this)}.$methodName() method must return a non-null $OptValueWrap for the multiOptCriterionNameX '$multiOptCriterionNameX'. ";
    if (multiOptCriterion.selectionType == SelectionType.single) {
      message += "$OptValueWrap.single(null) or $OptValueWrap.single(value). ";
    } else {
      message +=
          "$OptValueWrap.multi([null]) or $OptValueWrap.multi([value]). ";
    }
    message +=
        "And return null for not $MultiOptFilterCriterionModel. See the specification of this method for more information.";
    // throw AppError(errorMessage: message);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __throwErrorIfNotASimpleCriterionName({
    required String criterionNameX,
    required FilterErrorMethod filterErrorMethod,
  }) {
    if (_filterModelStructure._isMultiOptFilterCriterion(criterionNameX)) {
      throw DevError(
        errorMessage:
            '$criterionNameX is not a ${getTypeNameWithoutGenerics(SimpleFilterCriterionModel)}',
        errorDetails: [
          "See ${getClassNameWithoutGenerics(this)}.${getClassNameWithoutGenerics(filterErrorMethod)}() method."
        ],
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  OptValueWrap? __getUpdatedValueForMultiOptCriterion({
    required String multiOptCriterionName,
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required FILTER_INPUT filterInput,
    required Object? parentMultiOptCriterionValue,
  }) {
    OptValueWrap? valueWrap = getUpdatedValueForMultiOptCriterion(
      filterInput: filterInput,
      parentMultiOptCriterionValue: parentMultiOptCriterionValue,
      multiOptCriterionXData: multiOptCriterionXData,
      multiOptCriterionName: multiOptCriterionName,
      multiOptCriterionNameX: multiOptCriterionNameX,
      selectionType: selectionType,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppError(
        methodName: "getUpdatedValueForMultiOptCriterion",
        multiOptCriterionNameX: multiOptCriterionNameX,
      );
      return null;
    }
    List? value = valueWrap.values;
    return OptValueWrap.multi(
      multiOptCriterionXData._findInternalItemsByDynamics(
        dynamicValues: value,
        addToInternalIfNotFound: false,
        removeCurrentNotFoundItems: true,
      ),
    );
  }

  OptValueWrap? __specifyDefaultValueForMultiOptCriterion({
    required String multiOptCriterionName,
    required String multiOptCriterionNameX,
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    OptValueWrap? valueWrap = specifyDefaultValueForMultiOptCriterion(
      multiOptCriterionName: multiOptCriterionName,
      multiOptCriterionNameX: multiOptCriterionNameX,
      parentMultiOptCriterionValue: parentMultiOptCriterionValue,
      multiOptCriterionXData: multiOptCriterionXData,
      selectionType: selectionType,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppError(
        methodName: "specifyDefaultValueForMultiOptCriterion",
        multiOptCriterionNameX: multiOptCriterionNameX,
      );
    }
    List? value = valueWrap?.values ?? [];
    return OptValueWrap.multi(
      multiOptCriterionXData._findInternalItemsByDynamics(
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
    await DebugFilterModelViewerDialog.open(
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
    await DebugFilterCriteriaViewerDialog.showFilterCriteriaViewerDialog(
      context: context,
      filterModel: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0009 (form)
  MultiOptFilterCriterionModel? findMultiOptFilterCriterion({
    required String multiOptCriterionNameX,
  }) {
    return _filterModelStructure._findMultiOptFilterCriterion(
      multiOptCriterionNameX,
    );
  }

  // SAME-AS: #0008 (formModel.debugGetMultiOptPropLoadCount())
  int debugGetMultiOptCriteriaLoadCount(String multiOptCriterionNameX) {
    return _filterModelStructure._debugGetMultiOptCriterionLoadCount(
      multiOptCriterionNameX: multiOptCriterionNameX,
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
