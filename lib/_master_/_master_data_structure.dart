part of '../flutter_artist.dart';

class MasterDataStructure {
  final Map<String, MasterProp> _allMasterPropMap = {};
  final List<OptionedMasterProp> _rootOptionedMasterProps;
  final List<CommonMasterProp> _commonMasterProps = [];

  //
  final Map<String, MasterProp> _temporaryAllMasterPropMap = {};
  final Map<String, dynamic> _temporaryFormData = {};

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

  void _setMasterPropDataXList({
    required String propName,
    required XList? xList,
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
      masterProp._xList = xList;
    } else {
      throw AppException(
          message:
              'Invalid MasterProp $propName, it must be $OptionedMasterProp');
    }
  }

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

  void _addCommonMasterProp(CommonMasterProp masterProp) {
    if (!_allMasterPropMap.containsKey(masterProp.propName)) {
      _allMasterPropMap[masterProp.propName] = masterProp;
      _commonMasterProps.add(masterProp);
    }
  }

  void updateMasterPropValuesToLeaves({
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> updateValues,
  }) {
    //
    for (MasterProp masterProp in _allMasterPropMap.values) {
      masterProp.candidateUpdateValue = null;
      masterProp._valueUpdated = false;
      masterProp._dirty = false;
    }
    //
    for (String propName in updateValues.keys) {
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
        updateValues: updateValues,
      );
    }
    for (CommonMasterProp commonItem in _commonMasterProps) {
      commonItem._updateValue(
        currentValues: currentValues,
        updateValues: updateValues,
      );
    }
  }

  void printInfo() {
    print("\n\n--------------------------------------------------------------");
    for (OptionedMasterProp rootItem in _rootOptionedMasterProps) {
      rootItem._printInfoCascade(indentFactor: 1);
    }
    print("--------------------------------------------------------------");
  }
}
