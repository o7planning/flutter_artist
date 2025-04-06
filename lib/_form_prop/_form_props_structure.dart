part of '../flutter_artist.dart';

class FormPropsStructure {
  final Map<String, Prop> _allPropMap = {};
  final List<OptProp> _rootOptProps;
  final List<SimpleProp> _simpleProps = [];

  bool _justInitialized = false;
  DataState _formDataState = DataState.none;
  FormMode _formMode = FormMode.none;

  DataState get formDataState => _formDataState;
  FormMode get formMode => _formMode;

  bool get isNew => _formMode == FormMode.creation;
  //
  final Map<String, dynamic> _tempCurrentFormData = {};

  FormPropsStructure({
    required List<String> simpleProps,
    required List<OptProp> optProps,
  }) : _rootOptProps = [...optProps] {
    final List<String> simplePropList = [...simpleProps];
    //
    for (OptProp rootOptProp in optProps) {
      __standardizeCascade(rootOptProp, null);
    }
    for (Prop prop in _allPropMap.values) {
      simplePropList.remove(prop.propName);
      if (prop is OptProp) {
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

  void _setFormMode_TODO_DELETE({
    required FormMode formMode,
    required DataState formDataState,
  }) {
    _formMode = formMode;
    _formDataState = formDataState;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isFormDirty()  {
    for(Prop prop in _allPropMap.values)  {
      bool dirty = prop.isDirty();
      if(dirty) {
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
  /// - Other Initial [OptProp] data will be update later...
  ///
  void _setInitialFormDataForItemFirstLoad() {
    for (Prop prop in _allPropMap.values) {
      prop._initialValue = prop._currentValue;
      prop._initialData = prop._currentXData;
    }
  }

  ///
  /// After save successful, update "Initial Form Data".
  ///
  void _updateInitialFormDataAfterSaveSuccess() {
    for (Prop prop in _allPropMap.values) {
      prop._initialValue = prop._currentValue;
      prop._initialData = prop._currentXData;
    }
  }

  void _updateTempToReal()  {
    for (Prop prop in _allPropMap.values) {
      prop._currentValue = prop._tempCurrentValue;
      prop._currentXData = prop._tempCurrentXData;
    }
  }

  // @Deprecated("Xoa di, khong su dung nua.")
  // void _applyAllTempDataToReal() {
  //   for (Prop prop in _allPropMap.values) {
  //     prop._applyTempDataToReal();
  //   }
  // }

  ///
  /// Reset Form Data:
  ///
  void _resetFormData() {
    for (Prop prop in _allPropMap.values) {
      prop._currentValue = prop._initialValue;
      prop._currentXData = prop._initialData;
    }
  }

  void _clearFormDataWithState({required DataState formDataState}) {
    _justInitialized = true;
    _formDataState = formDataState;
    _formMode = FormMode.none;
    //
    for (Prop prop in _allPropMap.values) {
      prop._currentValue = null;
      prop._currentXData = null;
    }
  }



  // ***************************************************************************
  // ***************************************************************************

  void _setCurrentPropValue({required String propName,required dynamic value,}) {
    Prop? prop = _allPropMap[propName];
    if(prop!= null) {
      prop._currentValue = value;
    }
  }


  dynamic _getCurrentPropValue({required String propName})  {
    Prop? prop = _allPropMap[propName];
    if(prop!= null) {
      return prop?._currentValue;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: DELTE?
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
    OptProp optProp,
    OptProp? parent,
  ) {
    optProp.parent = parent;
    _allPropMap[optProp.propName] = optProp;
    //
    for (OptProp child in optProp.children) {
      __standardizeCascade(child, optProp);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isOptProp(String propName) {
    Prop? prop = _allPropMap[propName];
    if (prop == null) {
      return false;
    }
    if (prop is OptProp) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _initTemporaryForNewTransaction({
    required Map<String, dynamic>? currentFormData,
  }) {
    _tempCurrentFormData
      ..updateAll((k, v) => null)
      ..addAll(currentFormData ?? {});
    //
    for (Prop prop in _allPropMap.values) {
      prop._resetForNewTransaction();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempCurrentPropValue({required String propName}) {
    return _tempCurrentFormData[propName];
  }

  // ***************************************************************************
  // ***************************************************************************

  XOptionedData? _getTempOptPropData(String propName) {
    Prop? prop = _allPropMap[propName];
    if (prop == null) {
      return null;
    }
    if (prop is OptProp) {
      return prop._tempCurrentXData;
    }
    return null;
  }

  XOptionedData? _getOptPropData(String propName) {
    Prop? prop = _allPropMap[propName];
    if (prop == null) {
      return null;
    }
    if (prop is OptProp) {
      return prop._currentXData;
    }
    return null;
  }

  OptPropType? _getOptPropType(String propName) {
    Prop? prop = _allPropMap[propName];
    if (prop == null) {
      return null;
    }
    if (prop is OptProp) {
      return prop.type;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateTempData(Map<String, dynamic> updateData) {
    final candidateUpdateValues = {...updateData};
    //
    // IMPORTANT:
    // Update data for MasterDataStructure. From ROOTs to LEAVES.
    // (***):
    // And Update children-OptProp data to null if parent-Value is null or not selected.
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
      } else {
        _createAndAddNewSimpleProp(
          propName: propName,
          markTempDirty: true,
        );
      }
    }
    //
    for (OptProp rootProp in _rootOptProps) {
      rootProp._updateTempValueCascade(
        tempCurrentFormData: _tempCurrentFormData,
        updateValues: candidateUpdateValues,
      );
    }
    for (SimpleProp commonItem in _simpleProps) {
      commonItem._updateTempValue(
        tempCurrentFormData: _tempCurrentFormData,
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all dirty Prop:
    for (Prop prop in _allPropMap.values) {
      if (prop._markTempDirty) {
        _tempCurrentFormData[prop.propName] = prop.candidateUpdateValue;
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

  void _setTempOptPropData({
    required String propName,
    required XOptionedData? optionedData,
  }) {
    Prop? prop = _allPropMap[propName];
    if (prop == null) {
      throw AppException(message: 'No Prop $propName');
    }
    if (prop is OptProp) {
      prop._tempCurrentXData = optionedData;
    } else {
      throw AppException(
          message: 'Invalid Prop $propName, it must be $OptProp');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempSimplePropData({
    required String propName,
    required Object? value,
  }) {
    Prop? prop = _allPropMap[propName];
    if (prop == null) {
      throw AppException(message: "No propName $propName", details: null);
    } else if (prop is! SimpleProp) {
      throw AppException(
          message: "$propName is not Simple prop", details: null);
    }
    _tempCurrentFormData[propName] = value;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addSimpleProp(SimpleProp prop) {
    if (!_allPropMap.containsKey(prop.propName)) {
      _allPropMap[prop.propName] = prop;
      _simpleProps.add(prop);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printTemporaryInfo(String prefix) {
    if (true) return;
    print("\n\n--------------------------------------------------------------");
    print(" ---> $prefix");
    for (OptProp rootItem in _rootOptProps) {
      rootItem._printTempInfoCascade(indentFactor: 1);
    }
    print("tempCurrentFormData: $_tempCurrentFormData");
    print("--------------------------------------------------------------");
  }
}
