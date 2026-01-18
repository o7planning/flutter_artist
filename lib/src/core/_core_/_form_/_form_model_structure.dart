part of '../core.dart';

class FormModelStructure {
  final Map<String, FormProp> _allPropMap = {};
  final List<MultiOptFormProp> _rootOptProps;
  final List<SimpleFormProp> _simpleProps = [];
  final List<CalculatedFormProp> _calculatedProps = [];

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
    required List<SimpleFormProp> simpleProps,
    required List<MultiOptFormProp> multiOptProps,
    List<CalculatedFormProp> calculatedProps = const [],
  }) : _rootOptProps = List.unmodifiable(multiOptProps) {
    for (MultiOptFormProp rootOptProp in multiOptProps) {
      __standardizeCascade(rootOptProp, null);
    }
    for (SimpleFormProp sp in simpleProps) {
      if (_allPropMap.containsKey(sp.propName)) {
        throw DuplicateFormPropError(
          propName: sp.propName,
        );
      }
      __initSimpleProp(
        newSimpleProp: sp,
        markTempDirty: false,
      );
    }
    for (CalculatedFormProp cp in calculatedProps) {
      if (_allPropMap.containsKey(cp.propName)) {
        throw DuplicateFormPropError(
          propName: cp.propName,
        );
      }
      __initCalculatedProp(
        newCalculatedProp: cp,
        markTempDirty: false,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __standardizeCascade(
    MultiOptFormProp optProp,
    MultiOptFormProp? parent,
  ) {
    optProp.parent = parent;
    optProp._structure = this;
    //
    if (_allPropMap.containsKey(optProp.propName)) {
      throw DuplicateFormPropError(
        propName: optProp.propName,
      );
    }
    _allPropMap[optProp.propName] = optProp;
    //
    for (MultiOptFormProp child in optProp._children) {
      __standardizeCascade(child, optProp);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  FormErrorInfo? get formErrorInfo {
    for (String propName in _allPropMap.keys) {
      FormProp prop = _allPropMap[propName]!;
      if (prop._formErrorInfo != null) {
        return prop._formErrorInfo;
      }
    }
    return __formErrorInfo;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _clearFormError() {
    for (String propName in _allPropMap.keys) {
      FormProp prop = _allPropMap[propName]!;
      prop._formErrorInfo = null;
    }
    __formErrorInfo = null;
  }

  void _setFormError(FormErrorInfo formErrorInfo) {
    if (formErrorInfo.propName == null) {
      __formErrorInfo = formErrorInfo;
    } else {
      FormProp? prop = _allPropMap[formErrorInfo.propName!];
      prop?._formErrorInfo = formErrorInfo;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0007 (filterCriteriaStructure.allMultiOptCriteria)
  List<MultiOptFormProp> get allMultiOptProps {
    return _allPropMap.values
        .whereType<MultiOptFormProp>()
        .cast<MultiOptFormProp>()
        .toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _triggerFilterCriteriaChanged() {
    for (var rootMultiOptProp in _rootOptProps) {
      if (rootMultiOptProp.reloadCondition ==
          MultiOptPropReload.ifCriteriaChanged) {
        rootMultiOptProp._markToReload = true;
      }
    }
  }

  void _triggerItemIdChanged() {
    for (var rootMultiOptProp in _rootOptProps) {
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
    for (FormProp prop in _allPropMap.values) {
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
  /// - Other Initial [MultiOptFormProp] data will be update later...
  ///
  void _setInitialFormDataForItemFirstLoad() {
    for (FormProp prop in _allPropMap.values) {
      prop._initialValue = prop._currentValue;
      prop._initialXData = prop._currentXData;
    }
  }

  ///
  /// After save successful, update "Initial Form Data".
  ///
  void _updateInitialFormDataAfterSaveSuccess() {
    for (FormProp prop in _allPropMap.values) {
      prop._initialValue = prop._currentValue;
      prop._initialXData = prop._currentXData;
    }
  }

  void _updateTempToReal() {
    for (FormProp prop in _allPropMap.values) {
      prop._currentValue = prop._tempCurrentValue;
      prop._currentXData = prop._tempCurrentXData;
    }
  }

  ///
  /// Reset Form Data:
  ///
  void _resetFormData() {
    __manualDirty = false;
    for (FormProp prop in _allPropMap.values) {
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
    for (FormProp prop in _allPropMap.values) {
      prop._currentValue = null;
      prop._initialValue = null;
      if (prop is MultiOptFormProp) {
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
    FormProp? prop = _allPropMap[propName];
    if (prop != null) {
      prop._currentValue = value;
    }
  }

  dynamic _getCurrentPropValue({required String propName}) {
    FormProp? prop = _allPropMap[propName];
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
    return _allPropMap.map((k, v) => MapEntry(k, v._initialValue));
  }

  Map<String, dynamic> get currentFormData {
    return _allPropMap.map((k, v) => MapEntry(k, v._currentValue));
  }

  // ***************************************************************************
  // ***************************************************************************

  MultiOptFormProp? _getMultiOptFormProp(String multiOptPropName) {
    FormProp? prop = _allPropMap[multiOptPropName];
    if (prop is MultiOptFormProp) {
      return prop;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  SimpleFormProp? _getSimpleFormProp(String propName) {
    FormProp? prop = _allPropMap[propName];
    if (prop is SimpleFormProp) {
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

  void _initTemporaryForNewActivity({
    required FormActivityType activityType,
    required Map<String, dynamic> formKeyInstantValues,
  }) {
    __isTempMode = true;
    __addPropsIfNeed(
      propNames: formKeyInstantValues.keys.toList(),
    );
    //
    for (FormProp prop in _allPropMap.values) {
      switch (activityType) {
        case FormActivityType.startCreatingOrEditing:
          _formInitialDataReady = false;
          if (prop is SimpleFormProp) {
            prop._tempCurrentValue = null;
            prop._tempCurrentXData = null;
            prop._tempInitialValue = null;
            prop._tempInitialXData = null;
          } else if (prop is MultiOptFormProp) {
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
            if (prop is SimpleFormProp) {
              prop._tempCurrentValue = formKeyInstantValues[prop.propName];
            }
          }
        case FormActivityType.autoEnterFormFields:
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
    FormProp? prop = _allPropMap[propName];
    return prop?._tempCurrentValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempInitialPropValue({required String propName}) {
    FormProp? prop = _allPropMap[propName];
    return prop?._tempInitialValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getInitialPropValue({required String propName}) {
    FormProp? prop = _allPropMap[propName];
    return prop?._initialValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getTempMultiOptPropXData({required String propName}) {
    FormProp? prop = _allPropMap[propName];
    if (prop is MultiOptFormProp) {
      return prop._tempCurrentXData;
    }
    return null;
  }

  XData? _getCurrentMultiOptPropXData({required String propName}) {
    FormProp? prop = _allPropMap[propName];
    if (prop is MultiOptFormProp) {
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

  MultiOptFormProp? _findMultiOptFormProp(String multiOptPropName) {
    FormProp? prop = _allPropMap[multiOptPropName];
    if (prop is MultiOptFormProp) {
      return prop;
    }
    return null;
  }

  int _debugGetMultiOptPropLoadCount({
    required String multiOptPropName,
  }) {
    MultiOptFormProp? prop = _findMultiOptFormProp(multiOptPropName);
    return prop?._loadCount ?? 0;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateChildrenMultiOptValueToNullCascade({
    required MultiOptFormProp multiOptProp,
  }) {
    for (MultiOptFormProp child in multiOptProp._children) {
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
    // And Update children-OptCriterion data to null if parent-Value is null or not selected.
    //
    for (FormProp prop in _allPropMap.values) {
      prop._candidateUpdateValue = null;
      prop._valueUpdated = false;
      prop._markTempDirty = false;
    }
    //
    for (String propName in candidateUpdateValues.keys) {
      FormProp? prop = _allPropMap[propName];
      if (prop != null) {
        prop._markTempDirty = true;
      }
    }
    //
    for (MultiOptFormProp rootProp in _rootOptProps) {
      rootProp._updateTempValueCascade(
        updateValues: candidateUpdateValues,
      );
    }
    for (SimpleFormProp commonItem in _simpleProps) {
      commonItem._updateTempValue(
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all _markTempDirty Prop:
    for (FormProp prop in _allPropMap.values) {
      if (prop._markTempDirty) {
        prop._tempCurrentValue = prop._candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __addPropsIfNeed({required List<String> propNames}) {
    for (String propName in propNames) {
      FormProp? prop = _allPropMap[propName];
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
    if (_allPropMap.containsKey(propName)) {
      return;
    }
    SimpleFormProp newSimpleProp = SimpleFormProp(
      propName: propName,
    );
    __initSimpleProp(
      newSimpleProp: newSimpleProp,
      markTempDirty: markTempDirty,
    );
  }

  void __initSimpleProp({
    required SimpleFormProp newSimpleProp,
    required bool markTempDirty,
  }) {
    newSimpleProp._structure = this;
    newSimpleProp._markTempDirty = markTempDirty;
    _allPropMap[newSimpleProp.propName] = newSimpleProp;
    _simpleProps.add(newSimpleProp);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __initCalculatedProp({
    required CalculatedFormProp newCalculatedProp,
    required bool markTempDirty,
  }) {
    newCalculatedProp._structure = this;
    newCalculatedProp._markTempDirty = markTempDirty;
    _allPropMap[newCalculatedProp.propName] = newCalculatedProp;
    _calculatedProps.add(newCalculatedProp);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempMultiOptPropXData({
    required String multiOptPropName,
    required XData? multiOptPropXData,
  }) {
    FormProp? prop = _allPropMap[multiOptPropName];
    if (prop == null) {
      throw AppError(errorMessage: 'No Prop "$multiOptPropName"');
    }
    if (prop is MultiOptFormProp) {
      prop._tempCurrentXData = multiOptPropXData;
    } else {
      throw AppError(
        errorMessage:
            'Invalid Prop "$multiOptPropName", it must be $MultiOptFormProp',
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
    FormProp? prop = _allPropMap[propName];
    if (prop == null) {
      throw AppError(
        errorMessage: 'No propName "$propName"',
        errorDetails: null,
      );
    } else if (prop is! SimpleFormProp) {
      throw AppError(
        errorMessage: '"$propName" is not $SimpleFormProp',
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
  List<MultiOptFormProp> get debugRootOptProps => _rootOptProps;

  @DebugMethodAnnotation()
  List<SimpleFormProp> get simpleProps => _simpleProps;

  // ***************************************************************************
  // ***************************************************************************

  void _printTemporaryInfo(String prefix) {
    if (true) {
      print(
          "\n\n--------------------------------------------------------------");
      print(" ---> $prefix");
      for (MultiOptFormProp rootItem in _rootOptProps) {
        rootItem._printTempInfoCascade(indentFactor: 1);
      }
      print("--------------------------------------------------------------");
    }
  }
}
