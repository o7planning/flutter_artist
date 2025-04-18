part of '../flutter_artist.dart';

class FormPropsStructure {
  final Map<String, Prop> _allPropMap = {};
  final List<MultiOptProp> _rootOptProps;
  final List<SimpleProp> _simpleProps = [];

  bool __manualDirty = false;

  late final FormModel formModel;

  bool _justInitialized = false;
  DataState _formDataState = DataState.none;
  FormMode _formMode = FormMode.none;

  DataState get formDataState => _formDataState;

  FormMode get formMode => _formMode;

  bool get isNew => _formMode == FormMode.creation;

  FormPropsStructure({
    required List<String> simpleProps,
    required List<MultiOptProp> multiOptProps,
  }) : _rootOptProps = [...multiOptProps] {
    final List<String> simplePropList = [...simpleProps];
    //
    for (MultiOptProp rootOptProp in multiOptProps) {
      __standardizeCascade(rootOptProp, null);
    }
    for (Prop prop in _allPropMap.values) {
      simplePropList.remove(prop.propName);
      if (prop is MultiOptProp) {
        prop._checkCycleError();
      }
    }
    for (String propName in simplePropList) {
      _createAndAddNewSimpleProp(
        propName: propName,
        markTempDirty: false,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setFormMode(FormMode formMode) {
    _formMode = formMode;
  }

  void _setFormDataState(DataState formDataState) {
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
      prop._currentXData = null;
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

  void __standardizeCascade(
    MultiOptProp optProp,
    MultiOptProp? parent,
  ) {
    optProp.parent = parent;
    _allPropMap[optProp.propName] = optProp;
    //
    for (MultiOptProp child in optProp.children) {
      __standardizeCascade(child, optProp);
    }
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
    required Map<String, dynamic>? newCurrentFormData,
  }) {
    __addPropsIfNeed(
      propNames: newCurrentFormData?.keys.toList() ?? [],
    );
    //
    for (Prop prop in _allPropMap.values) {
      dynamic newValue = newCurrentFormData?[prop.propName];
      prop._tempCurrentValue = newValue;
      prop._tempCurrentXData = null;
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

  dynamic _getInitialPropValue({required String propName}) {
    Prop? prop = _allPropMap[propName];
    return prop?._initialValue;
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? _getTempOptPropData(String propName) {
    Prop? prop = _allPropMap[propName];
    if (prop == null) {
      return null;
    }
    if (prop is MultiOptProp) {
      return prop._tempCurrentXData;
    }
    return null;
  }

  XData? _getMultiOptPropXData(String propName) {
    Prop? prop = _allPropMap[propName];
    if (prop == null) {
      return null;
    }
    if (prop is MultiOptProp) {
      return prop._currentXData;
    }
    return null;
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
      prop.candidateUpdateValue = null;
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
        prop._tempCurrentValue = prop.candidateUpdateValue;
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
            *** WARNING ***: You should declare prop '$prop' explicitly in ${getClassName(formModel)}.
            ****************************************************************************************************
            """);
        //
        _createAndAddNewSimpleProp(
          propName: propName,
          markTempDirty: false,
        );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndAddNewSimpleProp({
    required String propName,
    required bool markTempDirty,
  }) {
    if (_allPropMap.containsKey(propName)) {
      return;
    }
    SimpleProp? newSimpleProp = SimpleProp(
      propName: propName,
    );
    newSimpleProp._markTempDirty = markTempDirty;
    _allPropMap[propName] = newSimpleProp;
    _simpleProps.add(newSimpleProp);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempMultiOptPropXData({
    required String multiOptPropName,
    required XData? multiOptPropXData,
  }) {
    Prop? prop = _allPropMap[multiOptPropName];
    if (prop == null) {
      throw AppException(message: 'No Prop "$multiOptPropName"');
    }
    if (prop is MultiOptProp) {
      prop._tempCurrentXData = multiOptPropXData;
    } else {
      throw AppException(
        message: 'Invalid Prop "$multiOptPropName", it must be $MultiOptProp',
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempSimplePropValue({
    required String propName,
    required Object? value,
  }) {
    Prop? prop = _allPropMap[propName];
    if (prop == null) {
      throw AppException(
        message: 'No propName "$propName"',
        details: null,
      );
    } else if (prop is! SimpleProp) {
      throw AppException(
        message: '"$propName" is not $SimpleProp',
        details: null,
      );
    }
    prop._tempCurrentValue = value;
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
