part of '../flutter_artist.dart';

class MasterDataStructure {
  final Map<String, Prop> _allPropMap = {};
  final List<OptProp> _rootOptProps;
  final List<CommonProp> _commonProps = [];

  //
  final Map<String, dynamic> _tempCurrentFormData = {};

  MasterDataStructure({
    required List<String> allPropNames,
    required List<OptProp> optProps,
  }) : _rootOptProps = [...optProps] {
    final List<String> commonPropNames = {...allPropNames}.toList();
    //
    for (OptProp rootOptProp in optProps) {
      __standardizeCascade(rootOptProp, null);
    }
    for (Prop masterProp in _allPropMap.values) {
      commonPropNames.remove(masterProp.propName);
      if (masterProp is OptProp) {
        masterProp._checkCycleError();
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

  void _resetTemporaryForNewTransaction({
    required Map<String, dynamic>? currentFormData,
  }) {
    _tempCurrentFormData
      ..updateAll((k, v) => null)
      ..addAll(currentFormData ?? {});
    //
    for (Prop masterProp in _allPropMap.values) {
      masterProp._resetForNewTransaction();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _applyAllTempDataToReal() {
    for (Prop masterProp in _allPropMap.values) {
      masterProp._applyTempDataToReal();
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
    Prop? masterProp = _allPropMap[propName];
    if (masterProp == null) {
      return null;
    }
    if (masterProp is OptProp) {
      return masterProp._tempXOptionedData;
    }
    return null;
  }

  XOptionedData? _getOptPropData(String propName) {
    Prop? masterProp = _allPropMap[propName];
    if (masterProp == null) {
      return null;
    }
    if (masterProp is OptProp) {
      return masterProp._xOptionedData;
    }
    return null;
  }

  OptPropType? _getOptPropType(String propName) {
    Prop? masterProp = _allPropMap[propName];
    if (masterProp == null) {
      return null;
    }
    if (masterProp is OptProp) {
      return masterProp.type;
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
    for (Prop masterProp in _allPropMap.values) {
      masterProp.candidateUpdateValue = null;
      masterProp._valueUpdated = false;
      masterProp._dirty = false;
    }
    //
    for (String propName in candidateUpdateValues.keys) {
      Prop? masterProp = _allPropMap[propName];
      if (masterProp != null) {
        masterProp._dirty = true;
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
    required XOptionedData? tempXList,
  }) {
    Prop? masterProp = _allPropMap[propName];
    if (masterProp == null) {
      throw AppException(message: 'No Prop $propName');
    }
    if (masterProp is OptProp) {
      masterProp._tempXOptionedData = tempXList;
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

  void _printTemporaryInfo() {
    print("\n\n--------------------------------------------------------------");
    for (OptProp rootItem in _rootOptProps) {
      rootItem._printTempInfoCascade(indentFactor: 1);
    }
    print("tempCurrentFromData: $_tempCurrentFormData");
    print("--------------------------------------------------------------");
  }
}
