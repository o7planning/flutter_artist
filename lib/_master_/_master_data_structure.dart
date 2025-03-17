part of '../flutter_artist.dart';

class MasterDataStructure {
  final Map<String, MasterProp> _allMasterPropMap = {};
  final List<OptionedMasterProp> _rootOptionedMasterProps;
  final List<CommonMasterProp> _commonMasterProps = [];

  //
  final Map<String, MasterProp> _tempAllMasterPropMap = {};
  final Map<String, dynamic> _tempCurrentFormData = {};

  MasterDataStructure({
    required List<OptionedMasterProp> optionedMasterProps,
  }) : _rootOptionedMasterProps = [...optionedMasterProps] {
    for (OptionedMasterProp rootMasterProperty in optionedMasterProps) {
      __standardizeCascade(rootMasterProperty, null);
    }
    for (MasterProp xProperty in _allMasterPropMap.values) {
      if (xProperty is OptionedMasterProp) {
        xProperty._checkCycleError();
      }
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
    required Map<String, dynamic> currentFormData,
  }) {
    _tempAllMasterPropMap
      ..clear()
      ..addAll(_allMasterPropMap);
    //
    _tempCurrentFormData
      ..clear()
      ..addAll(currentFormData);
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
        return masterProp._object;
      } else {
        return null;
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

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
    //
    // IMPORTANT:
    // Update data for MasterDataStructure. From ROOTs to LEAVES.
    // (***):
    // And Update children-OptionedMasterProp data to null if parent-Value is null or not selected.
    //
    updateMasterPropValuesToLeaves(
      currentValues: _tempCurrentFormData,
      candidateUpdateValues: {...updateData},
    );
    // Apply to all dirty MasterProp:
    for (MasterProp masterProp in _tempAllMasterPropMap.values) {
      if (masterProp._dirty) {
        _tempCurrentFormData[masterProp.propName] =
            masterProp.candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempMasterPropDataXList({
    required String propName,
    required XList? xList,
  }) {
    MasterProp? masterProp = _tempAllMasterPropMap[propName];
    if (masterProp == null) {
      throw AppException(message: 'No MasterProp $propName');
    }
    if (masterProp is OptionedMasterProp) {
      if (masterProp.type != OptionedMasterPropType.listable) {
        throw AppException(
            message: 'Invalid MasterProp Data for type ${masterProp.type}');
      }
      masterProp._xList = xList;
    } else {
      throw AppException(
          message:
              'Invalid MasterProp $propName, it must be $OptionedMasterProp');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setMasterPropDataCustom({
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
      masterProp._object = object;
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

  void updateMasterPropValuesToLeaves({
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> candidateUpdateValues,
  }) {
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
        CommonMasterProp? newCommonProperty = CommonMasterProp(
          propName: propName,
        );
        newCommonProperty._dirty = true;
        _allMasterPropMap[propName] = newCommonProperty;
        _commonMasterProps.add(newCommonProperty);
      }
    }
    //
    for (OptionedMasterProp rootItem in _rootOptionedMasterProps) {
      rootItem._updateValueCascade(
        currentValues: currentValues,
        updateValues: candidateUpdateValues,
      );
    }
    for (CommonMasterProp commonItem in _commonMasterProps) {
      commonItem._updateValue(
        currentValues: currentValues,
        updateValues: candidateUpdateValues,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void printInfo() {
    print("\n\n--------------------------------------------------------------");
    for (OptionedMasterProp rootItem in _rootOptionedMasterProps) {
      rootItem._printInfoCascade(indentFactor: 1);
    }
    print("--------------------------------------------------------------");
  }
}
