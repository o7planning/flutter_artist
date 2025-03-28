part of '../flutter_artist.dart';

class FormPropsStructure {
  final Map<String, Prop> _allPropMap = {};
  final List<OptProp> _rootOptProps;
  final List<CommonProp> _commonProps = [];

  //
  final Map<String, dynamic> _tempCurrentFormData = {};

  FormPropsStructure({
    required List<String> allPropNames,
    required List<OptProp> optProps,
  }) : _rootOptProps = [...optProps] {
    final List<String> commonPropNames = {...allPropNames}.toList();
    //
    for (OptProp rootOptProp in optProps) {
      __standardizeCascade(rootOptProp, null);
    }
    for (Prop prop in _allPropMap.values) {
      commonPropNames.remove(prop.propName);
      if (prop is OptProp) {
        prop._checkCycleError();
      }
    }
    for (String propName in commonPropNames) {
      _createAndAddNewCommomProp(
        propName: propName,
        dirty: false,
      );
    }
  }

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

  void _applyAllTempDataToReal() {
    for (Prop prop in _allPropMap.values) {
      prop._applyTempDataToReal();
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
      return prop._tempXOptionedData;
    }
    return null;
  }

  XOptionedData? _getOptPropData(String propName) {
    Prop? prop = _allPropMap[propName];
    if (prop == null) {
      return null;
    }
    if (prop is OptProp) {
      return prop._xOptionedData;
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
      prop._dirty = false;
    }
    //
    for (String propName in candidateUpdateValues.keys) {
      Prop? prop = _allPropMap[propName];
      if (prop != null) {
        prop._dirty = true;
      } else {
        _createAndAddNewCommomProp(
          propName: propName,
          dirty: true,
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
    for (CommonProp commonItem in _commonProps) {
      commonItem._updateTempValue(
        tempCurrentFormData: _tempCurrentFormData,
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all dirty Prop:
    for (Prop prop in _allPropMap.values) {
      if (prop._dirty) {
        _tempCurrentFormData[prop.propName] = prop.candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndAddNewCommomProp({
    required String propName,
    required bool dirty,
  }) {
    if (_allPropMap.containsKey(propName)) {
      return;
    }
    CommonProp? newCommonProp = CommonProp(
      propName: propName,
    );
    newCommonProp._dirty = dirty;
    _allPropMap[propName] = newCommonProp;
    _commonProps.add(newCommonProp);
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
      prop._tempXOptionedData = optionedData;
    } else {
      throw AppException(
          message: 'Invalid Prop $propName, it must be $OptProp');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempPropDataCommon({
    required String propName,
    required Object? value,
  }) {
    Prop? prop = _allPropMap[propName];
    if (prop == null) {
      throw AppException(message: "No propName $propName", details: null);
    } else if (prop is! CommonProp) {
      throw AppException(
          message: "$propName is not Common prop", details: null);
    }
    _tempCurrentFormData[propName] = value;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addCommonProp(CommonProp prop) {
    if (!_allPropMap.containsKey(prop.propName)) {
      _allPropMap[prop.propName] = prop;
      _commonProps.add(prop);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printTemporaryInfo(String prefix) {
    print("\n\n--------------------------------------------------------------");
    print(" ---> $prefix");
    for (OptProp rootItem in _rootOptProps) {
      rootItem._printTempInfoCascade(indentFactor: 1);
    }
    print("tempCurrentFormData: $_tempCurrentFormData");
    print("--------------------------------------------------------------");
  }
}
