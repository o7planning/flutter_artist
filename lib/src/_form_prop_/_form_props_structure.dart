part of '../../flutter_artist.dart';

class FormPropsStructure {
  final Map<String, Prop> _allPropMap = {};
  final List<MultiOptProp> _rootOptProps;
  final List<SimpleProp> _simpleProps = [];
  final List<CalculatedProp> _calculatedProps = [];

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

  FormPropsStructure({
    required List<SimpleProp> simpleProps,
    required List<MultiOptProp> multiOptProps,
    List<CalculatedProp> calculatedProps = const [],
  }) : _rootOptProps = [...multiOptProps] {
    for (MultiOptProp rootOptProp in multiOptProps) {
      __standardizeCascade(rootOptProp, null);
    }
    for (SimpleProp sp in simpleProps) {
      if (_allPropMap.containsKey(sp.propName)) {
        throw _DuplicateFormPropError(
          propName: sp.propName,
        );
      }
      __initSimpleProp(
        newSimpleProp: sp,
        markTempDirty: false,
      );
    }
    for (CalculatedProp cp in calculatedProps) {
      if (_allPropMap.containsKey(cp.propName)) {
        throw _DuplicateFormPropError(
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
    MultiOptProp optProp,
    MultiOptProp? parent,
  ) {
    optProp.parent = parent;
    optProp._structure = this;
    //
    if (_allPropMap.containsKey(optProp.propName)) {
      throw _DuplicateFormPropError(
        propName: optProp.propName,
      );
    }
    _allPropMap[optProp.propName] = optProp;
    //
    for (MultiOptProp child in optProp._children) {
      __standardizeCascade(child, optProp);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  FormErrorInfo? get formErrorInfo {
    for (String propName in _allPropMap.keys) {
      Prop prop = _allPropMap[propName]!;
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
      Prop prop = _allPropMap[propName]!;
      prop._formErrorInfo = null;
    }
    __formErrorInfo = null;
  }

  void _setFormError(FormErrorInfo formErrorInfo) {
    if (formErrorInfo.propName == null) {
      __formErrorInfo = formErrorInfo;
    } else {
      Prop? prop = _allPropMap[formErrorInfo.propName!];
      prop?._formErrorInfo = formErrorInfo;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  List<MultiOptProp> get allMultiOptProps {
    return _allPropMap.values
        .where((p) => p is MultiOptProp)
        .cast<MultiOptProp>()
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
    for (Prop prop in _allPropMap.values) {
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
  /// - Other Initial [MultiOptProp] data will be update later...
  ///
  void _setInitialFormDataForItemFirstLoad() {
    for (Prop prop in _allPropMap.values) {
      prop._initialValue = prop._currentValue;
      prop._initialXData = prop._currentXData;
    }
  }

  ///
  /// After save successful, update "Initial Form Data".
  ///
  void _updateInitialFormDataAfterSaveSuccess() {
    for (Prop prop in _allPropMap.values) {
      prop._initialValue = prop._currentValue;
      prop._initialXData = prop._currentXData;
    }
  }

  void _updateTempToReal() {
    for (Prop prop in _allPropMap.values) {
      prop._currentValue = prop._tempCurrentValue;
      prop._currentXData = prop._tempCurrentXData;
    }
  }

  ///
  /// Reset Form Data:
  ///
  void _resetFormData() {
    __manualDirty = false;
    for (Prop prop in _allPropMap.values) {
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
    for (Prop prop in _allPropMap.values) {
      prop._currentValue = null;
      prop._initialValue = null;
      if (prop is MultiOptProp) {
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
    Prop? prop = _allPropMap[propName];
    if (prop != null) {
      prop._currentValue = value;
    }
  }

  dynamic _getCurrentPropValue({required String propName}) {
    Prop? prop = _allPropMap[propName];
    if (prop != null) {
      return prop?._currentValue;
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

  MultiOptProp? _getMultiOptProp(String multiOptPropName) {
    Prop? prop = _allPropMap[multiOptPropName];
    if (prop is MultiOptProp) {
      return prop;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  SimpleProp? _getSimpleProp(String propName) {
    Prop? prop = _allPropMap[propName];
    if (prop is SimpleProp) {
      return prop;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isOptProp(String propName) {
    return _getMultiOptProp(propName) != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _initTemporaryForNewTransaction({
    required FormActivityType activityType,
    required Map<String, dynamic> formKeyInstantValues,
  }) {
    __isTempMode = true;
    __addPropsIfNeed(
      propNames: formKeyInstantValues.keys.toList(),
    );
    //
    for (Prop prop in _allPropMap.values) {
      switch (activityType) {
        case FormActivityType.itemFirstLoad:
          _formInitialDataReady = false;
          if (prop is SimpleProp) {
            prop._tempCurrentValue = null;
            prop._tempCurrentXData = null;
            prop._tempInitialValue = null;
            prop._tempInitialXData = null;
          } else if (prop is MultiOptProp) {
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
            if (prop is SimpleProp) {
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
    Prop? prop = _allPropMap[propName];
    return prop?._tempCurrentValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempInitialPropValue({required String propName}) {
    Prop? prop = _allPropMap[propName];
    return prop?._tempInitialValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getInitialPropValue({required String propName}) {
    Prop? prop = _allPropMap[propName];
    return prop?._initialValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getTempMultiOptPropXData({required String propName}) {
    Prop? prop = _allPropMap[propName];
    if (prop is MultiOptProp) {
      return prop._tempCurrentXData;
    }
    return null;
  }

  XData? _getCurrentMultiOptPropXData({required String propName}) {
    Prop? prop = _allPropMap[propName];
    if (prop is MultiOptProp) {
      return prop._currentXData;
    }
    return null;
  }

  dynamic _getCurrentMultiOptPropData({required String propName}) {
    XData? multiOptPropXData = _getCurrentMultiOptPropXData(propName: propName);
    return multiOptPropXData?.data;
  }

  int _getMultiOptPropLoadCount({required String propName}) {
    Prop? prop = _allPropMap[propName];
    if (prop is MultiOptProp) {
      return prop._loadCount;
    }
    return 0;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateChildrenMultiOptValueToNullCascade({
    required MultiOptProp multiOptProp,
  }) {
    for (MultiOptProp child in multiOptProp._children) {
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
    for (Prop prop in _allPropMap.values) {
      prop._candidateUpdateValue = null;
      prop._valueUpdated = false;
      prop._markTempDirty = false;
    }
    //
    for (String propName in candidateUpdateValues.keys) {
      Prop? prop = _allPropMap[propName];
      if (prop != null) {
        prop._markTempDirty = true;
      }
    }
    //
    for (MultiOptProp rootProp in _rootOptProps) {
      rootProp._updateTempValueCascade(
        updateValues: candidateUpdateValues,
      );
    }
    for (SimpleProp commonItem in _simpleProps) {
      commonItem._updateTempValue(
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all _markTempDirty Prop:
    for (Prop prop in _allPropMap.values) {
      if (prop._markTempDirty) {
        prop._tempCurrentValue = prop._candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __addPropsIfNeed({required List<String> propNames}) {
    for (String propName in propNames) {
      Prop? prop = _allPropMap[propName];
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
    SimpleProp newSimpleProp = SimpleProp(
      propName: propName,
    );
    __initSimpleProp(
      newSimpleProp: newSimpleProp,
      markTempDirty: markTempDirty,
    );
  }

  void __initSimpleProp({
    required SimpleProp newSimpleProp,
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
    required CalculatedProp newCalculatedProp,
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
    Prop? prop = _allPropMap[multiOptPropName];
    if (prop == null) {
      throw AppError(errorMessage: 'No Prop "$multiOptPropName"');
    }
    if (prop is MultiOptProp) {
      prop._tempCurrentXData = multiOptPropXData;
    } else {
      throw AppError(
        errorMessage:
            'Invalid Prop "$multiOptPropName", it must be $MultiOptProp',
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
    Prop? prop = _allPropMap[propName];
    if (prop == null) {
      throw AppError(
        errorMessage: 'No propName "$propName"',
        errorDetails: null,
      );
    } else if (prop is! SimpleProp) {
      throw AppError(
        errorMessage: '"$propName" is not $SimpleProp',
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

  void _printTemporaryInfo(String prefix) {
    if (true) {
      print(
          "\n\n--------------------------------------------------------------");
      print(" ---> $prefix");
      for (MultiOptProp rootItem in _rootOptProps) {
        rootItem._printTempInfoCascade(indentFactor: 1);
      }
      print("--------------------------------------------------------------");
    }
  }
}
