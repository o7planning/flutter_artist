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

  FILTER_CRITERIA? _filterCriteria;

  FILTER_CRITERIA? get filterCriteria => _filterCriteria;

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

  late final FilterCriteriaStructure _filterCriteriaStructure;

  FilterCriteriaStructure get filterCriteriaStructure =>
      _filterCriteriaStructure;

  DataState get dataState => _filterCriteriaStructure._filterDataState;

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
  ///         criterionName: "company",
  ///         children: [
  ///           // Multi Options Multi Selections Criterion:
  ///           MultiOptMsCriterion(
  ///              criterionName: "department",
  ///           ),
  ///         ],
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  FilterCriteriaStructure registerCriteriaStructure();

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  @_AbstractMethodAnnotation()
  Future<XData?> callApiLoadMultiOptCriterionXData({
    required String multiOptCriterionName,
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
  ///     required String multiOptCriterionName,
  ///     required SelectionType selectionType,
  ///     required ExampleFilterInput filterInput,
  ///     required XData multiOptCriterionXData,
  ///     required Object? parentMultiOptCriterionValue,
  /// }) {
  ///    if(multiOptCriterionName == "company") {
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
  ///     required Map<String, dynamic> dataMap,
  ///  }) {
  ///      return MyFilterCriteria(
  ///         company: dataMap["company"],
  ///         department: dataMap["department"],
  ///      );
  ///  }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  FILTER_CRITERIA toFilterCriteriaObject({
    required Map<String, dynamic> dataMap,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FilterModelLoadDataAnnotation()
  Future<bool> _unitLoadFilterData({
    required MasterFlowItem? masterFlowItem,
    required TaskType taskType,
    required XFilterModel thisXFilterModel,
    required FilterModelDataLoadResult taskResult,
  }) async {
    __assertThisXFilterModel(thisXFilterModel);
    //
    masterFlowItem?._addLineFlowItem(
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
        _filterCriteria = await _startNewFilterActivity(
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
    required MasterFlowItem? masterFlowItem,
    required TaskType taskType,
    required XFilterModel xFilterModel,
  }) async {
    __assertThisXFilterModel(xFilterModel);
    //
    masterFlowItem?._addLineFlowItem(
      codeId: "#30000",
      shortDesc:
          "${_debugObjHtml(this)} -> Begin ${taskType.asDebugTaskUnit()}.",
      lineFlowType: LineFlowType.debug,
    );
    //
    _filterCriteriaStructure._setFilterDataState(DataState.pending);
    //
    FILTER_CRITERIA? filterCriteria = await _startNewFilterActivity(
      masterFlowItem: masterFlowItem,
      activityType: FilterActivityType.updateFromFilterPanel,
      filterInput: null,
    );
    return filterCriteria != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __registerCriteriaStructure() {
    try {
      _filterCriteriaStructure = registerCriteriaStructure();
      _filterCriteriaStructure.filterModel = this;
    } on DuplicateFilterCriterionError catch (e) {
      String message =
          "Duplicate criterion '${e.criterionName}' in ${getClassName(this)}";
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
    return _filterCriteriaStructure._initialCriteriaValues;
  }

  // TODO: Rename?
  Map<String, dynamic> get criteriaValues {
    return _filterCriteriaStructure._currentCriteriaValues;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isDirty() {
    return _filterCriteriaStructure._isDirty();
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getCriterionValue(String criterionName) {
    return _filterCriteriaStructure._getCurrentCriterionValue(
      criterionName: criterionName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? getMultiOptCriterionXData(String multiOptCriterionName) {
    return _filterCriteriaStructure._getMultiOptCriterionXData(
      multiOptCriterionName,
    );
  }

  dynamic getMultiOptCriterionData(String multiOptCriterionName) {
    XData? multiOptCriterionXData = getMultiOptCriterionXData(
      multiOptCriterionName,
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
    _filterCriteriaStructure._printTemporaryInfo(prefix);
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
  Future<FILTER_CRITERIA?> _startNewFilterActivity({
    required MasterFlowItem? masterFlowItem,
    required FILTER_INPUT? filterInput,
    required FilterActivityType activityType,
  }) async {
    __filterActivityCount++;
    //
    // if (this is! _DefaultFilterModel) {
    //   masterFlowItem?._addLineFlowItem(
    //     codeId: "#31000",
    //     shortDesc:
    //         "Calling ${_debugObjHtml(this)}._startNewFilterActivity() with parameters:",
    //     lineFlowType: LineFlowType.calling,
    //     isLibCall: true,
    //   );
    // }
    //
    if (activityType == FilterActivityType.newFilt) {
      __loadCount++;
    }
    final Map<String, dynamic> formKeyInstantValues =
        _formKey.currentState?.instantValue ?? {};
    //
    if (this is! _DefaultFilterModel) {
      masterFlowItem?._addLineFlowItem(
        codeId: "#31020",
        shortDesc:
            "Calling <b>_filterCriteriaStructure._initTemporaryForNewActivity()</b>..",
        lineFlowType: LineFlowType.nonControllableCalling,
      );
    }
    _filterCriteriaStructure._initTemporaryForNewActivity(
      activityType: activityType,
      formKeyInstantValues: formKeyInstantValues,
      filterInput: filterInput,
    );
    //
    // Load OptProp Data:
    //
    try {
      for (MultiOptFilterCriterion multiOptCriterion
          in _filterCriteriaStructure._rootOptCriteria) {
        masterFlowItem?._addLineFlowItem(
          codeId: "#31040",
          shortDesc:
              "Calling ${_debugObjHtml(this)}._loadMultiOptCriterionDataCascade() method "
              "to load data for ${_debugObjHtml(multiOptCriterion)} and its descendants.",
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
          filterInput: filterInput,
          parentMultiOptCriterionValue: null,
          multiOptCriterion: multiOptCriterion,
          formKeyInstantValues: formKeyInstantValues,
          activityType: activityType,
        );
      }
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "callApiLoadMultiOptCriterionXData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      masterFlowItem?._addLineFlowItem(
        codeId: "#31080",
        shortDesc:
            "The ${_debugObjHtml(this)}._loadMultiOptCriterionDataCascade() was called with an error.",
        errorInfo: errorInfo,
      );
      //
      _filterCriteriaStructure._setFilterDataState(DataState.error);
      _filterCriteria = null;
      return _filterCriteria;
    }
    //
    if (filterInput != null) {
      try {
        masterFlowItem?._addLineFlowItem(
          codeId: "#31140",
          shortDesc:
              "Calling ${_debugObjHtml(this)}.updatedSimpleCriterionValues() method "
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
        for (String criterionName in updatedSimpleCriterionValues.keys) {
          // Check and throw error if 'criterionName' is not a SimpleFilterCriterion:
          __throwErrorIfNotASimpleCriterionName(
            criterionName: criterionName,
            filterErrorMethod:
                FilterErrorMethod.getUpdatedValuesForSimpleCriteria,
          );
          SimpleValueWrap? valueWrap =
              updatedSimpleCriterionValues[criterionName];
          // SAME-AS: #0012 (formModel)
          if (valueWrap != null) {
            _filterCriteriaStructure._setTempSimpleCriterionValue(
              criterionName: criterionName,
              value: valueWrap.value,
            );
          }
        }
      } catch (e, stackTrace) {
        ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: "getUpdatedValuesForSimpleCriteria",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        //
        masterFlowItem?._addLineFlowItem(
          codeId: "#31200",
          shortDesc:
              "The ${_debugObjHtml(this)}.updatedSimpleCriterionValues() method was called with an error.",
          errorInfo: errorInfo,
        );
        //
        _filterCriteriaStructure._setFilterDataState(DataState.error);
        _filterCriteria = null;
        return _filterCriteria;
      }
    }
    // filterInput is null
    else {
      try {
        if (!__initiatedAtLeastOnce) {
          if (this is! _DefaultFilterModel) {
            masterFlowItem?._addLineFlowItem(
              codeId: "#31300",
              shortDesc:
                  "Calling ${_debugObjHtml(this)}.specifyDefaultValuesForSimpleCriteria() method "
                  "to get default values for <b>simple criteria</b>.",
              lineFlowType: LineFlowType.controllableCalling,
            );
          }
          final Map<String, dynamic> defaultSimpleCriterionValues =
              specifyDefaultValuesForSimpleCriteria() ?? {};

          for (String criterionName in defaultSimpleCriterionValues.keys) {
            // Check and throw error if 'criterionName' is not a SimpleFilterCriterion:
            __throwErrorIfNotASimpleCriterionName(
              criterionName: criterionName,
              filterErrorMethod:
                  FilterErrorMethod.specifyDefaultValuesForSimpleCriteria,
            );
            //
            dynamic value = defaultSimpleCriterionValues[criterionName];
            _filterCriteriaStructure._setTempSimpleCriterionValue(
              criterionName: criterionName,
              value: value,
            );
          }
        }
      } catch (e, stackTrace) {
        ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: "specifyDefaultValuesForSimpleCriteria",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        masterFlowItem?._addLineFlowItem(
          codeId: "#31380",
          shortDesc:
              "The ${_debugObjHtml(this)}.specifyDefaultValuesForSimpleCriteria() method was called with an error.",
          errorInfo: errorInfo,
        );
        //
        _filterCriteriaStructure._setFilterDataState(DataState.error);
        _filterCriteria = null;
        return _filterCriteria;
      }
    }
    //
    try {
      if (this is! _DefaultFilterModel) {
        masterFlowItem?._addLineFlowItem(
          codeId: "#31420",
          shortDesc:
              "Calling ${_debugObjHtml(this)}.toFilterCriteriaObject() method "
              "to convert criteria in type of Map to a Dart object.",
          parameters: {
            "dataMap": _filterCriteriaStructure._tempCriteriaValues,
          },
          lineFlowType: LineFlowType.controllableCalling,
          tipDocument: TipDocument.filterCriteria,
        );
      }
      // Convert Map Data to FilterCriteria Object.
      FILTER_CRITERIA newCriteria = toFilterCriteriaObject(
        dataMap: _filterCriteriaStructure._tempCriteriaValues,
      );
      // _filterCriteria = newCriteria; // has moved down.
      //
      if (this is! _DefaultFilterModel) {
        masterFlowItem?._addLineFlowItem(
          codeId: "#31460",
          shortDesc:
              "Got an instance of ${_debugObjHtml(newCriteria)} (Dart object).\n"
              "This object will be passed to the <b>@filterCriteria</b> parameter "
              "of the <b>Block.query()</b> or <b>Scalar.query</b> method.",
          tipDocument: TipDocument.filterCriteria,
        );
      }
      //
      // Update Real FromData from Temporary FormData:
      //
      _filterCriteriaStructure._updateTempToReal();
      //
      // IMPORTANT:
      //
      _formKeyPatchValue(
        newCurrentValue: _filterCriteriaStructure._currentCriteriaValues,
      );
      //
      __initiatedAtLeastOnce = true;
      _filterCriteriaStructure._setFilterDataState(DataState.ready);
      //
      _filterCriteria = newCriteria;
      return _filterCriteria;
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "toFilterCriteriaObject",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      _filterCriteriaStructure._setFilterDataState(DataState.error);
      //
      // IMPORTANT:
      //
      _formKeyPatchValue(
        newCurrentValue: _filterCriteriaStructure._currentCriteriaValues,
      );
      //
      _filterCriteria = null;
      masterFlowItem?._addLineFlowItem(
        codeId: "#31500",
        shortDesc:
            "The ${_debugObjHtml(this)}.toFilterCriteriaObject() method was called with an error!",
        errorInfo: errorInfo,
      );
      return _filterCriteria;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadMultiOptCriterionDataCascade({
    required FILTER_INPUT? filterInput,
    required Object? parentMultiOptCriterionValue,
    required MultiOptFilterCriterion multiOptCriterion,
    required Map<String, dynamic> formKeyInstantValues,
    required FilterActivityType activityType,
  }) async {
    final String multiOptCriterionName = multiOptCriterion.criterionName;
    final SelectionType selectionType = multiOptCriterion.selectionType;

    final MultiOptFilterCriterion? multiOptCriterionParent =
        multiOptCriterion.parent;

    // Get current OptCriterion data:
    XData? tempMultiOptCriterionXData =
        _filterCriteriaStructure._getTempMultiOptCriterionXData(
      multiOptCriterionName,
    );
    final dynamic tempCurrentMultiOptValue = _filterCriteriaStructure
        ._getTempCurrentCriterionValue(criterionName: multiOptCriterionName);

    //
    dynamic newSelectedValue =
        _filterCriteriaStructure._getTempCurrentCriterionValue(
      criterionName: multiOptCriterionName,
    );
    if (activityType == FilterActivityType.updateFromFilterPanel) {
      if (formKeyInstantValues.containsKey(multiOptCriterionName)) {
        newSelectedValue = formKeyInstantValues[multiOptCriterionName];
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
    //
    multiOptCriterion._tempCurrentValue = newSelectedValue;
    //
    if (valueChanged) {
      _filterCriteriaStructure._updateChildrenMultiOptValueToNullCascade(
        multiOptCriterion: multiOptCriterion,
      );
    }
    //
    if (multiOptCriterionParent != null) {
      XData? tempMultiOptXDataParent =
          _filterCriteriaStructure._getTempMultiOptCriterionXData(
        multiOptCriterionParent.criterionName,
      );
      //
      if (tempMultiOptXDataParent != null) {
        // Item or Item List (Multi Selection):
        Object? parentOptCriterionValueOLD =
            _filterCriteriaStructure._getCurrentCriterionValue(
          criterionName: multiOptCriterionParent.criterionName,
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
      _filterCriteriaStructure._setTempMultiOptCriterionXData(
        multiOptCriterionName: multiOptCriterionName,
        multiOptXData: null,
      );
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterCriteriaStructure._updateCriteriaTempValues({
        multiOptCriterionName: null,
      });
    }

    if (tempMultiOptCriterionXData == null) {
      // Always increase "_loadCount" value regardless of error.
      multiOptCriterion._loadCount++;
      //
      try {
        // May throw AppError, ApiError or others.
        //
        // Load OptCriterion data from Rest API.
        // May throw ApiError.
        //
        tempMultiOptCriterionXData = await callApiLoadMultiOptCriterionXData(
          filterInput: filterInput,
          parentMultiOptCriterionValue: parentMultiOptCriterionValue,
          multiOptCriterionName: multiOptCriterionName,
          selectionType: selectionType,
        );
      } catch (e, stackTrace) {
        // TODO: Test Case??
        throw FilterTempError(
          propName: multiOptCriterionName,
          filterErrorMethod:
              FilterErrorMethod.callApiLoadMultiOptCriterionXData,
          error: e, // May be AppError, ApiError or others.
          stackTrace: stackTrace,
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
        inputValueWrap = __getUpdatedValueForMultiOptCriterion(
          filterInput: filterInput,
          parentMultiOptCriterionValue: parentMultiOptCriterionValue,
          multiOptCriterionXData: tempMultiOptCriterionXData,
          multiOptCriterionName: multiOptCriterionName,
          selectionType: selectionType,
        );
      } else {
        if (!__initiatedAtLeastOnce) {
          inputValueWrap = __specifyDefaultValueForMultiOptCriterion(
            parentMultiOptCriterionValue: parentMultiOptCriterionValue,
            multiOptCriterionXData: tempMultiOptCriterionXData,
            multiOptCriterionName: multiOptCriterionName,
            selectionType: selectionType,
          );
        }
      }
      //
      // Current selected value:
      // It can be a single value or a List.
      //
      final dynamic tempCurrentValue =
          _filterCriteriaStructure._getTempCurrentCriterionValue(
        criterionName: multiOptCriterionName,
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
    _filterCriteriaStructure._setTempMultiOptCriterionXData(
      multiOptCriterionName: multiOptCriterionName,
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
        _filterCriteriaStructure._updateCriteriaTempValues({
          multiOptCriterionName: candidateSelectedItem,
        });
      } else {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _filterCriteriaStructure._updateCriteriaTempValues({
          multiOptCriterionName: candidateSelectedItems,
        });
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterCriteriaStructure._updateCriteriaTempValues({
        multiOptCriterionName: null,
      });
    }
    //
    Object? tempSelectedCriterionValue =
        _filterCriteriaStructure._getTempCurrentCriterionValue(
      criterionName: multiOptCriterionName,
    );

    if (tempSelectedCriterionValue != null) {
      for (MultiOptFilterCriterion child in multiOptCriterion.children) {
        await _loadMultiOptCriterionDataCascade(
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
    required String multiOptCriterionName,
  }) {
    MultiOptFilterCriterion? multiOptCriterion = _filterCriteriaStructure
        ._getMultiOptFilterCriterion(multiOptCriterionName);
    if (multiOptCriterion == null) {
      throw "The '$multiOptCriterionName' is not $MultiOptFilterCriterion";
    }
    String message =
        "The ${getClassName(this)}.$methodName() method must return a non-null $OptValueWrap for the multiOptCriterionName '$multiOptCriterionName'. ";
    if (multiOptCriterion.selectionType == SelectionType.single) {
      message += "$OptValueWrap.single(null) or $OptValueWrap.single(value). ";
    } else {
      message +=
          "$OptValueWrap.multi([null]) or $OptValueWrap.multi([value]). ";
    }
    message +=
        "And return null for not $MultiOptFilterCriterion. See the specification of this method for more information.";
    // throw AppError(errorMessage: message);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __throwErrorIfNotASimpleCriterionName({
    required String criterionName,
    required FilterErrorMethod filterErrorMethod,
  }) {
    if (_filterCriteriaStructure._isMultiOptFilterCriterion(criterionName)) {
      throw DevError(
        errorMessage:
            '$criterionName is not a ${getTypeNameWithoutGenerics(SimpleFilterCriterion)}',
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
      selectionType: selectionType,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppError(
        methodName: "getUpdatedValueForMultiOptCriterion",
        multiOptCriterionName: multiOptCriterionName,
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
    required SelectionType selectionType,
    required XData multiOptCriterionXData,
    required Object? parentMultiOptCriterionValue,
  }) {
    OptValueWrap? valueWrap = specifyDefaultValueForMultiOptCriterion(
      parentMultiOptCriterionValue: parentMultiOptCriterionValue,
      multiOptCriterionXData: multiOptCriterionXData,
      multiOptCriterionName: multiOptCriterionName,
      selectionType: selectionType,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppError(
        methodName: "specifyDefaultValueForMultiOptCriterion",
        multiOptCriterionName: multiOptCriterionName,
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
    return _filterCriteriaStructure._currentCriteriaValues;
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
      shortDesc: "Calling ${_debugObjHtml(xShelf)}._initQueryTaskUnits()..",
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

  Future<void> showFilterModelDebugDialog() async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    //
    await FilterModelInfoDialog.showFilterModelInfoDialog(
      context: context,
      locationInfo: "locationInfo", // TODO: Remove.
      filterModel: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void showFilterCriteriaDialog() {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    //
    FilterCriteriaDialog.showFilterCriteriaDialog(
      context: context,
      filterModel: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0009 (form)
  MultiOptFilterCriterion? findMultiOptFilterCriterion({
    required String multiOptCriterionName,
  }) {
    return _filterCriteriaStructure._findMultiOptFilterCriterion(
      multiOptCriterionName,
    );
  }

  // SAME-AS: #0008 (formModel.debugGetMultiOptPropLoadCount())
  int debugGetMultiOptCriteriaLoadCount(String multiOptCriterionName) {
    return _filterCriteriaStructure._debugGetMultiOptCriterionLoadCount(
      multiOptCriterionName: multiOptCriterionName,
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
