part of '../flutter_artist.dart';

class FilterCriterionsStructure {
  final Map<String, Criterion> _allCriterionMap = {};
  final List<OptCriterion> _rootOptCriterions;
  final List<SimpleCriterion> _simpleCriterions = [];

  //
  final Map<String, dynamic> _tempCurrentFormData = {};

  FilterCriterionsStructure({
    required List<String> simpleCriterions,
    required List<OptCriterion> optCriterions,
  }) : _rootOptCriterions = [...optCriterions] {
    final List<String> simpleCriterionList = [...simpleCriterions];
    //
    for (OptCriterion rootOptCriterion in optCriterions) {
      __standardizeCascade(rootOptCriterion, null);
    }
    for (Criterion prop in _allCriterionMap.values) {
      simpleCriterionList.remove(prop.propName);
      if (prop is OptCriterion) {
        prop._checkCycleError();
      }
    }
    for (String propName in simpleCriterionList) {
      _createAndAddNewCommomCriterion(
        propName: propName,
        dirty: false,
      );
    }
  }

  void __standardizeCascade(
    OptCriterion optCriterion,
    OptCriterion? parent,
  ) {
    optCriterion.parent = parent;
    _allCriterionMap[optCriterion.propName] = optCriterion;
    //
    for (OptCriterion child in optCriterion.children) {
      __standardizeCascade(child, optCriterion);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isOptCriterion(String propName) {
    Criterion? prop = _allCriterionMap[propName];
    if (prop == null) {
      return false;
    }
    if (prop is OptCriterion) {
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
    for (Criterion prop in _allCriterionMap.values) {
      prop._resetForNewTransaction();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _applyAllTempDataToReal() {
    for (Criterion prop in _allCriterionMap.values) {
      prop._applyTempDataToReal();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempCurrentCriterionValue({required String propName}) {
    return _tempCurrentFormData[propName];
  }

  // ***************************************************************************
  // ***************************************************************************

  XOptionedData? _getTempOptCriterionData(String propName) {
    Criterion? prop = _allCriterionMap[propName];
    if (prop == null) {
      return null;
    }
    if (prop is OptCriterion) {
      return prop._tempXOptionedData;
    }
    return null;
  }

  XOptionedData? _getOptCriterionData(String propName) {
    Criterion? prop = _allCriterionMap[propName];
    if (prop == null) {
      return null;
    }
    if (prop is OptCriterion) {
      return prop._xOptionedData;
    }
    return null;
  }

  OptPropType? _getOptCriterionType(String propName) {
    Criterion? prop = _allCriterionMap[propName];
    if (prop == null) {
      return null;
    }
    if (prop is OptCriterion) {
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
    // Update data for FilterCriterionsStructure. From ROOTs to LEAVES.
    // (***):
    // And Update children-OptCriterion data to null if parent-Value is null or not selected.
    //
    for (Criterion prop in _allCriterionMap.values) {
      prop.candidateUpdateValue = null;
      prop._valueUpdated = false;
      prop._dirty = false;
    }
    //
    for (String propName in candidateUpdateValues.keys) {
      Criterion? prop = _allCriterionMap[propName];
      if (prop != null) {
        prop._dirty = true;
      } else {
        _createAndAddNewCommomCriterion(
          propName: propName,
          dirty: true,
        );
      }
    }
    //
    for (OptCriterion rootCriterion in _rootOptCriterions) {
      rootCriterion._updateTempValueCascade(
        tempCurrentFormData: _tempCurrentFormData,
        updateValues: candidateUpdateValues,
      );
    }
    for (SimpleCriterion simpleCriterion in _simpleCriterions) {
      simpleCriterion._updateTempValue(
        tempCurrentFormData: _tempCurrentFormData,
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all dirty Criterion:
    for (Criterion prop in _allCriterionMap.values) {
      if (prop._dirty) {
        _tempCurrentFormData[prop.propName] = prop.candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndAddNewCommomCriterion({
    required String propName,
    required bool dirty,
  }) {
    if (_allCriterionMap.containsKey(propName)) {
      return;
    }
    SimpleCriterion? newSimpleCriterion = SimpleCriterion(
      propName: propName,
    );
    newSimpleCriterion._dirty = dirty;
    _allCriterionMap[propName] = newSimpleCriterion;
    _simpleCriterions.add(newSimpleCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempOptCriterionData({
    required String propName,
    required XOptionedData? optionedData,
  }) {
    Criterion? prop = _allCriterionMap[propName];
    if (prop == null) {
      throw AppException(message: 'No Criterion $propName');
    }
    if (prop is OptCriterion) {
      prop._tempXOptionedData = optionedData;
    } else {
      throw AppException(
          message: 'Invalid Criterion $propName, it must be $OptCriterion');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempSimpleCriterionData({
    required String propName,
    required Object? value,
  }) {
    _tempCurrentFormData[propName] = value;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addSimpleCriterion(SimpleCriterion prop) {
    if (!_allCriterionMap.containsKey(prop.propName)) {
      _allCriterionMap[prop.propName] = prop;
      _simpleCriterions.add(prop);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printTemporaryInfo(String prefix) {
    print("\n\n--------------------------------------------------------------");
    print(" ---> $prefix");
    for (OptCriterion rootItem in _rootOptCriterions) {
      rootItem._printTempInfoCascade(indentFactor: 1);
    }
    print("tempCurrentFormData: $_tempCurrentFormData");
    print("--------------------------------------------------------------");
  }
}
