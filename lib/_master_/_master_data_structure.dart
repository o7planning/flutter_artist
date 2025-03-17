part of '../flutter_artist.dart';

class MasterDataStructure {
  final Map<String, MasterProp> _allMasterPropMap = {};
  final List<OptionedMasterProp> _rootOptionedMasterProps;
  final List<CommonMasterProp> _commonMasterProps = [];

  //
  final Map<String, dynamic> _tempCurrentFormData = {};

  MasterDataStructure({
    required List<String> allPropNames,
    required List<OptionedMasterProp> optionedMasterProps,
  }) : _rootOptionedMasterProps = [...optionedMasterProps] {
    final List<String> commonPropNames = {...allPropNames}.toList();
    //
    for (OptionedMasterProp rootMasterProperty in optionedMasterProps) {
      __standardizeCascade(rootMasterProperty, null);
    }
    for (MasterProp masterProp in _allMasterPropMap.values) {
      commonPropNames.remove(masterProp.propName);
      if (masterProp is OptionedMasterProp) {
        masterProp._checkCycleError();
      }
    }
    for (String propName in commonPropNames) {
      _createAndAddNewCommomMasterProp(
        propName: propName,
        dirty: false,
      );
    }
  }

  void __standardizeCascade(
    OptionedMasterProp optionedMasterProp,
    OptionedMasterProp? parent,
  ) {
    optionedMasterProp.parent = parent;
    _allMasterPropMap[optionedMasterProp.propName] = optionedMasterProp;
    //
    for (OptionedMasterProp child in optionedMasterProp.children) {
      __standardizeCascade(child, optionedMasterProp);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _resetTemporaryForNewTransaction({
    required Map<String, dynamic>? currentFormData,
  }) {
    _tempCurrentFormData
      ..clear()
      ..addAll(currentFormData ?? {});
    //
    for (MasterProp masterProp in _allMasterPropMap.values) {
      masterProp._resetForNewTransaction();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _applyAllTempDataToReal() {
    for (MasterProp masterProp in _allMasterPropMap.values) {
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

  Object? _getMasterPropDataCustom(String propName) {
    MasterProp? masterProp = _allMasterPropMap[propName];
    if (masterProp == null) {
      return null;
    }
    if (masterProp is OptionedMasterProp) {
      if (masterProp.type == OptionedMasterPropType.custom) {
        return masterProp._xObject;
      } else {
        return null;
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  XList? _getTempMasterDataXList(String propName) {
    MasterProp? masterProp = _allMasterPropMap[propName];
    if (masterProp == null) {
      return null;
    }
    if (masterProp is OptionedMasterProp) {
      if (masterProp.type == OptionedMasterPropType.listable) {
        return masterProp._tempXList;
      } else {
        return null;
      }
    }
    return null;
  }

  XList? _getMasterDataXList(String propName) {
    MasterProp? masterProp = _allMasterPropMap[propName];
    if (masterProp == null) {
      return null;
    }
    if (masterProp is OptionedMasterProp) {
      if (masterProp.type == OptionedMasterPropType.listable) {
        return masterProp._xList;
      } else {
        return null;
      }
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
    // And Update children-OptionedMasterProp data to null if parent-Value is null or not selected.
    //
    for (MasterProp masterProp in _allMasterPropMap.values) {
      masterProp.candidateUpdateValue = null;
      masterProp._valueUpdated = false;
      masterProp._dirty = false;
    }
    //
    for (String propName in candidateUpdateValues.keys) {
      MasterProp? masterProp = _allMasterPropMap[propName];
      if (masterProp != null) {
        masterProp._dirty = true;
      } else {
        _createAndAddNewCommomMasterProp(
          propName: propName,
          dirty: true,
        );
      }
    }
    //
    for (OptionedMasterProp rootItem in _rootOptionedMasterProps) {
      rootItem._updateTempValueCascade(
        tempCurrentFormData: _tempCurrentFormData,
        updateValues: candidateUpdateValues,
      );
    }
    for (CommonMasterProp commonItem in _commonMasterProps) {
      commonItem._updateTempValue(
        tempCurrentFormData: _tempCurrentFormData,
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all dirty MasterProp:
    for (MasterProp masterProp in _allMasterPropMap.values) {
      if (masterProp._dirty) {
        _tempCurrentFormData[masterProp.propName] =
            masterProp.candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndAddNewCommomMasterProp({
    required String propName,
    required bool dirty,
  }) {
    if (_allMasterPropMap.containsKey(propName)) {
      return;
    }
    CommonMasterProp? newCommonProperty = CommonMasterProp(
      propName: propName,
    );
    newCommonProperty._dirty = dirty;
    _allMasterPropMap[propName] = newCommonProperty;
    _commonMasterProps.add(newCommonProperty);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempMasterPropDataXList({
    required String propName,
    required XList? tempXList,
  }) {
    MasterProp? masterProp = _allMasterPropMap[propName];
    if (masterProp == null) {
      throw AppException(message: 'No MasterProp $propName');
    }
    if (masterProp is OptionedMasterProp) {
      if (masterProp.type != OptionedMasterPropType.listable) {
        throw AppException(
            message: 'Invalid MasterProp Data for type ${masterProp.type}');
      }
      masterProp._tempXList = tempXList;
    } else {
      throw AppException(
          message:
              'Invalid MasterProp $propName, it must be $OptionedMasterProp');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempMasterPropDataCommon({
    required String propName,
    required Object? value,
  }) {
    _tempCurrentFormData[propName] = value;
  }

  void _setTempMasterPropDataCustom({
    required String propName,
    required Object? object,
  }) {
    MasterProp? masterProp = _allMasterPropMap[propName];
    if (masterProp == null) {
      throw AppException(message: 'No MasterProp $propName');
    }
    if (masterProp is OptionedMasterProp) {
      if (masterProp.type != OptionedMasterPropType.custom) {
        throw AppException(
            message: 'Invalid MasterProp Data for type ${masterProp.type}');
      }
      masterProp._tempXObject = object;
    } else {
      throw AppException(
          message:
              'Invalid MasterProp $propName, it must be $OptionedMasterProp');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addCommonMasterProp(CommonMasterProp masterProp) {
    if (!_allMasterPropMap.containsKey(masterProp.propName)) {
      _allMasterPropMap[masterProp.propName] = masterProp;
      _commonMasterProps.add(masterProp);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printTemporaryInfo() {
    print("\n\n--------------------------------------------------------------");
    for (OptionedMasterProp rootItem in _rootOptionedMasterProps) {
      rootItem._printTempInfoCascade(indentFactor: 1);
    }
    print("tempCurrentFromData: $_tempCurrentFormData");
    print("--------------------------------------------------------------");
  }
}
