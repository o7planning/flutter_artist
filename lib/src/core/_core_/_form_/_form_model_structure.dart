part of '../core.dart';

class FormModelStructure {
  //
  // Prop Defs:
  //
  final List<SimpleFormPropDef> __simplePropDefs;
  final List<MultiOptFormPropDef> __rootMultiOptPropDefs;

  final Map<String, FormPropDef> __allPropDefMap = {};
  final Map<String, SimpleFormPropDef> __simplePropDefMap = {};
  final Map<String, MultiOptFormPropDef> __multiOptPropDefMap = {};

  //
  // FormPropModels:
  //
  final Map<String, FormPropModel> _allPropModelMapX = {};
  final List<MultiOptFormPropModel> _rootOptPropModels = [];
  final List<SimpleFormPropModel> _simplePropModels = [];
  final List<CalculatedFormPropModel> _calculatedPropModels = [];

  //

  bool __manualDirty = false;

  bool __isTempMode = false;

  bool get isTempMode => __isTempMode;

  late final FormModel formModel;

  bool _justInitialized = false;

  bool _formInitialDataReady = false;

  FormMode _formMode = FormMode.none;

  FormMode get formMode => _formMode;

  DataState _formDataState = DataState.none;

  DataState get formDataState => _formDataState;

  FormErrorInfo? __formErrorInfo;

  bool get isNew => _formMode == FormMode.creation;

  FormModelStructure({
    required List<SimpleFormPropDef> simplePropDefs,
    required List<MultiOptFormPropDef> multiOptPropDefs,
  })  : __simplePropDefs = [...simplePropDefs],
        __rootMultiOptPropDefs = [...multiOptPropDefs] {
    for (SimpleFormPropDef simplePropDef in simplePropDefs) {
      __initSimplePropDef(simplePropDef: simplePropDef);
    }
    //
    for (MultiOptFormPropDef multiOptPropDef in multiOptPropDefs) {
      __initMultiOptPropDefCascade(
        multiOptPropDef: multiOptPropDef,
        parent: null,
      );
    }
    //
    // Create Prop Models:
    //
    for (SimpleFormPropDef propDef in __simplePropDefs) {
      __createSimpleFormPropModel(
        simplePropDef: propDef,
      );
    }
    for (MultiOptFormPropDef rootOptDef in __rootMultiOptPropDefs) {
      __createMultiOptFormPropModelCascade(
        optPropDef: rootOptDef,
        parentOptModel: null,
      );
    }
  }

  // ***************************************************************************

  void __initSimplePropDef({
    required SimpleFormPropDef simplePropDef,
  }) {
    if (__allPropDefMap.containsKey(simplePropDef.propName)) {
      throw DuplicateFormPropError(
        propName: simplePropDef.propName,
      );
    }
    __allPropDefMap[simplePropDef.propName] = simplePropDef;
    __simplePropDefMap[simplePropDef.propName] = simplePropDef;
  }

  // ***************************************************************************

  void __initMultiOptPropDefCascade({
    required MultiOptFormPropDef multiOptPropDef,
    required MultiOptFormPropDef? parent,
  }) {
    if (__allPropDefMap.containsKey(multiOptPropDef.propName)) {
      throw DuplicateFormPropError(
        propName: multiOptPropDef.propName,
      );
    }
    // Init LAZY Property.
    multiOptPropDef.parent = parent;
    __allPropDefMap[multiOptPropDef.propName] = multiOptPropDef;
    __multiOptPropDefMap[multiOptPropDef.propName] = multiOptPropDef;
    //
    for (MultiOptFormPropDef child in multiOptPropDef._children) {
      __initMultiOptPropDefCascade(
        multiOptPropDef: child,
        parent: multiOptPropDef,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __createSimpleFormPropModel({
    required SimpleFormPropDef simplePropDef,
  }) {
    final model = simplePropDef.createModel(
      propName: simplePropDef.propName,
    );
    _simplePropModels.add(model);
    _allPropModelMapX[simplePropDef.propName] = model;
  }

  // ***************************************************************************

  void __createMultiOptFormPropModelCascade({
    required MultiOptFormPropDef optPropDef,
    required MultiOptFormPropModel? parentOptModel,
  }) {
    final model = optPropDef.createModel(
      propName: optPropDef.propName,
      parent: parentOptModel,
    );
    if (parentOptModel == null) {
      _rootOptPropModels.add(model);
    }
    parentOptModel?._children.add(model);
    //
    _allPropModelMapX[optPropDef.propName] = model;
    for (MultiOptFormPropDef childDef in optPropDef._children) {
      __createMultiOptFormPropModelCascade(
        optPropDef: childDef,
        parentOptModel: model,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  FormErrorInfo? get formErrorInfo {
    for (String propName in _allPropModelMapX.keys) {
      FormPropModel prop = _allPropModelMapX[propName]!;
      if (prop._formErrorInfo != null) {
        return prop._formErrorInfo;
      }
    }
    return __formErrorInfo;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearFormError() {
    for (String propName in _allPropModelMapX.keys) {
      FormPropModel prop = _allPropModelMapX[propName]!;
      prop._formErrorInfo = null;
    }
    __formErrorInfo = null;
  }

  void _setFormError(FormErrorInfo formErrorInfo) {
    if (formErrorInfo.propName == null) {
      __formErrorInfo = formErrorInfo;
    } else {
      FormPropModel? prop = _allPropModelMapX[formErrorInfo.propName!];
      prop?._formErrorInfo = formErrorInfo;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0007 (filterModelStructure.allMultiOptCriteria)
  List<MultiOptFormPropModel> get allMultiOptProps {
    return _allPropModelMapX.values
        .whereType<MultiOptFormPropModel>()
        .cast<MultiOptFormPropModel>()
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _triggerFilterCriteriaChanged() {
    for (var rootMultiOptProp in _rootOptPropModels) {
      if (rootMultiOptProp.reloadCondition ==
          MultiOptPropReload.ifCriteriaChanged) {
        rootMultiOptProp._markToReload = true;
      }
    }
  }

  void _triggerItemIdChanged() {
    for (var rootMultiOptProp in _rootOptPropModels) {
      if (rootMultiOptProp.reloadCondition ==
          MultiOptPropReload.ifItemIdChanged) {
        rootMultiOptProp._markToReload = true;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setFormMode(FormMode formMode) {
    _formMode = formMode;
  }

  void _setFormDataState({
    required DataState formDataState,
    required dynamic error,
  }) {
    _formDataState = formDataState;
  }

  // TODO: Xem lai, xoa di?
  void _setFormMode_TODO_DELETE({
    required FormMode formMode,
    required DataState formDataState,
  }) {
    _formMode = formMode;
    _formDataState = formDataState;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setManualDirty(bool manualDirty) {
    __manualDirty = manualDirty;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isDirty() {
    if (__manualDirty) {
      return true;
    }
    for (FormPropModel prop in _allPropModelMapX.values) {
      bool dirty = prop.isDirty();
      if (dirty) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// For the first load of an Item, update "Initial Form Data".
  /// IMPORTANT:
  /// - Other Initial [MultiOptFormPropModel] data will be update later...
  ///
  void _setInitialFormDataForItemFirstLoad() {
    for (FormPropModel prop in _allPropModelMapX.values) {
      prop._initialValue = prop._currentValue;
      prop._initialXData = prop._currentXData;
    }
  }

  ///
  /// After save successful, update "Initial Form Data".
  ///
  void _updateInitialFormDataAfterSaveSuccess() {
    for (FormPropModel prop in _allPropModelMapX.values) {
      prop._initialValue = prop._currentValue;
      prop._initialXData = prop._currentXData;
    }
  }

  void _updateTempToReal() {
    for (FormPropModel prop in _allPropModelMapX.values) {
      prop._currentValue = prop._tempCurrentValue;
      prop._currentXData = prop._tempCurrentXData;
    }
  }

  ///
  /// Reset Form Data:
  ///
  void _resetFormData() {
    __manualDirty = false;
    for (FormPropModel prop in _allPropModelMapX.values) {
      prop._currentValue = prop._initialValue;
      prop._currentXData = prop._initialXData;
    }
  }

  void _clearFormDataWithState({required DataState formDataState}) {
    _justInitialized = true;
    _formDataState = formDataState;
    _formMode = FormMode.none;
    __manualDirty = false;
    //
    for (FormPropModel prop in _allPropModelMapX.values) {
      prop._currentValue = null;
      prop._initialValue = null;
      if (prop is MultiOptFormPropModel) {
        if (prop._markToReload) {
          prop._initialXData = null;
          prop._currentXData = null;
        }
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setCurrentPropValue({
    required String propName,
    required dynamic value,
  }) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop != null) {
      prop._currentValue = value;
    }
  }

  dynamic _getCurrentPropValue({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop != null) {
      return prop._currentValue;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: DELETE?
  Map<String, dynamic> get initial0FormData {
    return {};
  }

  Map<String, dynamic> get initialFormData {
    return _allPropModelMapX.map((k, v) => MapEntry(k, v._initialValue));
  }

  Map<String, dynamic> get currentFormData {
    return _allPropModelMapX.map((k, v) => MapEntry(k, v._currentValue));
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFormPropModel? _getMultiOptFormProp(String multiOptPropName) {
    FormPropModel? prop = _allPropModelMapX[multiOptPropName];
    if (prop is MultiOptFormPropModel) {
      return prop;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  SimpleFormPropModel? _getSimpleFormProp(String propName) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop is SimpleFormPropModel) {
      return prop;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isMultiOptFormProp(String propName) {
    return _getMultiOptFormProp(propName) != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setupTemporaryStateForNewActivity({
    required FormActivityType activityType,
    required Map<String, dynamic> formKeyInstantValues,
  }) {
    __isTempMode = true;
    __addPropsIfNeed(
      propNames: formKeyInstantValues.keys.toList(),
    );
    //
    for (FormPropModel prop in _allPropModelMapX.values) {
      switch (activityType) {
        case FormActivityType.startCreatingOrEditing:
          _formInitialDataReady = false;
          if (prop is SimpleFormPropModel) {
            prop._tempCurrentValue = null;
            prop._tempCurrentXData = null;
            prop._tempInitialValue = null;
            prop._tempInitialXData = null;
          } else if (prop is MultiOptFormPropModel) {
            if (prop._markToReload && prop.parent == null) {
              prop._tempCurrentValue = null;
              prop._tempCurrentXData = null;
              prop._tempInitialValue = null;
              prop._tempInitialXData = null;
            } else {
              prop._tempInitialXData = prop._initialXData;
              prop._tempCurrentXData = prop._currentXData;
              if (_formMode == FormMode.edit) {
                prop._tempInitialValue = prop._initialValue;
                prop._tempCurrentValue = prop._currentValue;
              } else {
                prop._tempInitialValue = null;
                prop._tempCurrentValue = null;
              }
            }
          } else {
            // Never throw.
            throw UnimplementedError();
          }
        case FormActivityType.updateFromFormView:
          prop._tempCurrentValue = prop._currentValue;
          prop._tempCurrentXData = prop._currentXData;
          prop._tempInitialValue = prop._initialValue;
          prop._tempInitialXData = prop._initialXData;
          //
          if (formKeyInstantValues.containsKey(prop.propName)) {
            if (prop is SimpleFormPropModel) {
              prop._tempCurrentValue = formKeyInstantValues[prop.propName];
            }
          }
        case FormActivityType.patchFormFields:
          prop._tempCurrentValue = prop._currentValue;
          prop._tempCurrentXData = prop._currentXData;
          prop._tempInitialValue = prop._initialValue;
          prop._tempInitialXData = prop._initialXData;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempCurrentPropValue({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    return prop?._tempCurrentValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempInitialPropValue({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    return prop?._tempInitialValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getInitialPropValue({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    return prop?._initialValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getTempMultiOptPropXData({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop is MultiOptFormPropModel) {
      return prop._tempCurrentXData;
    }
    return null;
  }

  XData? _getCurrentMultiOptPropXData({required String propName}) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop is MultiOptFormPropModel) {
      return prop._currentXData;
    }
    return null;
  }

  dynamic _getCurrentMultiOptPropData({required String propName}) {
    XData? multiOptPropXData = _getCurrentMultiOptPropXData(propName: propName);
    return multiOptPropXData?.data;
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFormPropModel? _findMultiOptFormProp(String multiOptPropName) {
    FormPropModel? prop = _allPropModelMapX[multiOptPropName];
    if (prop is MultiOptFormPropModel) {
      return prop;
    }
    return null;
  }

  int _debugGetMultiOptPropLoadCount({
    required String multiOptPropName,
  }) {
    MultiOptFormPropModel? prop = _findMultiOptFormProp(multiOptPropName);
    return prop?._loadCount ?? 0;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateChildrenMultiOptValueToNullCascade({
    required MultiOptFormPropModel multiOptProp,
  }) {
    for (MultiOptFormPropModel child in multiOptProp._children) {
      child._tempCurrentValue = null;
      child._tempCurrentXData = null;
      //
      _updateChildrenMultiOptValueToNullCascade(multiOptProp: child);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updatePropsTempValues(Map<String, dynamic> propValues) {
    __addPropsIfNeed(
      propNames: propValues.keys.toList(),
    );
    //
    final candidateUpdateValues = {...propValues};
    //
    // IMPORTANT:
    // Update data for FormPropsStructure. From ROOTs to LEAVES.
    // (***):
    // And Update children-OptProp data to null if parent-Value is null or not selected.
    //
    for (FormPropModel prop in _allPropModelMapX.values) {
      prop._candidateUpdateValue = null;
      prop._valueUpdated = false;
      prop._markTempDirty = false;
    }
    //
    for (String propName in candidateUpdateValues.keys) {
      FormPropModel? prop = _allPropModelMapX[propName];
      if (prop != null) {
        prop._markTempDirty = true;
      }
    }
    //
    for (MultiOptFormPropModel rootProp in _rootOptPropModels) {
      rootProp._updateTempValueCascade(
        updateValues: candidateUpdateValues,
      );
    }
    for (SimpleFormPropModel commonItem in _simplePropModels) {
      commonItem._updateTempValue(
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all _markTempDirty Prop:
    for (FormPropModel prop in _allPropModelMapX.values) {
      if (prop._markTempDirty) {
        prop._tempCurrentValue = prop._candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __addPropsIfNeed({required List<String> propNames}) {
    for (String propName in propNames) {
      FormPropModel? prop = _allPropModelMapX[propName];
      if (prop == null) {
        print("""\n
            ****************************************************************************************************
            *** WARNING ***: You should declare prop '$propName' explicitly in ${getClassName(formModel)}.
            ****************************************************************************************************
            """);
        //
        __createAndAddNewSimpleProp(
          propName: propName,
          markTempDirty: false,
        );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __createAndAddNewSimpleProp({
    required String propName,
    required bool markTempDirty,
  }) {
    if (_allPropModelMapX.containsKey(propName)) {
      return;
    }
    SimpleFormPropModel newSimpleProp = SimpleFormPropModel(
      propName: propName,
    );
    __initSimpleProp(
      newSimpleProp: newSimpleProp,
      markTempDirty: markTempDirty,
    );
  }

  void __initSimpleProp({
    required SimpleFormPropModel newSimpleProp,
    required bool markTempDirty,
  }) {
    newSimpleProp._structure = this;
    newSimpleProp._markTempDirty = markTempDirty;
    _allPropModelMapX[newSimpleProp.propName] = newSimpleProp;
    _simplePropModels.add(newSimpleProp);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __initCalculatedProp({
    required CalculatedFormPropModel newCalculatedProp,
    required bool markTempDirty,
  }) {
    newCalculatedProp._structure = this;
    newCalculatedProp._markTempDirty = markTempDirty;
    _allPropModelMapX[newCalculatedProp.propName] = newCalculatedProp;
    _calculatedPropModels.add(newCalculatedProp);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempMultiOptPropXData({
    required String multiOptPropName,
    required XData? multiOptPropXData,
  }) {
    FormPropModel? prop = _allPropModelMapX[multiOptPropName];
    if (prop == null) {
      throw AppError(errorMessage: 'No Prop "$multiOptPropName"');
    }
    if (prop is MultiOptFormPropModel) {
      prop._tempCurrentXData = multiOptPropXData;
    } else {
      throw AppError(
        errorMessage:
            'Invalid Prop "$multiOptPropName", it must be $MultiOptFormPropModel',
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempSimplePropValue({
    required String propName,
    required Object? value,
    required bool setForInitial,
  }) {
    FormPropModel? prop = _allPropModelMapX[propName];
    if (prop == null) {
      throw AppError(
        errorMessage: 'No propName "$propName"',
        errorDetails: null,
      );
    } else if (prop is! SimpleFormPropModel) {
      throw AppError(
        errorMessage: '"$propName" is not $SimpleFormPropModel',
        errorDetails: null,
      );
    }
    prop._tempCurrentValue = value;
    if (setForInitial) {
      prop._tempInitialValue = value;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  List<MultiOptFormPropModel> get debugRootOptProps => _rootOptPropModels;

  @DebugMethodAnnotation()
  List<SimpleFormPropModel> get simpleProps => _simplePropModels;

  // ***************************************************************************
  // ***************************************************************************

  void _printTemporaryInfo(String prefix) {
    if (true) {
      print(
          "\n\n--------------------------------------------------------------");
      print(" ---> $prefix");
      for (MultiOptFormPropModel rootItem in _rootOptPropModels) {
        rootItem._printTempInfoCascade(indentFactor: 1);
      }
      print("--------------------------------------------------------------");
    }
  }
}
