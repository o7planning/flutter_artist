part of '../flutter_artist.dart';

class FilterCriteriaStructure {
  final Map<String, Criterion> _allCriteriaMap = {};
  final List<OptCriterion> _rootOptCriteria;
  final List<SimpleCriterion> _simpleCriteria = [];

  //
  final Map<String, dynamic> _tempCurrentFormData = {};

  FilterCriteriaStructure({
    required List<String> simpleCriteria,
    required List<OptCriterion> optCriteria,
  }) : _rootOptCriteria = [...optCriteria] {
    final List<String> simpleCriterionList = [...simpleCriteria];
    //
    for (OptCriterion rootOptCriterion in optCriteria) {
      __standardizeCascade(rootOptCriterion, null);
    }
    for (Criterion criterion in _allCriteriaMap.values) {
      simpleCriterionList.remove(criterion.criterionName);
      if (criterion is OptCriterion) {
        criterion._checkCycleError();
      }
    }
    for (String propName in simpleCriterionList) {
      _createAndAddNewCommomCriterion(
        criterionName: propName,
        dirty: false,
      );
    }
  }

  void __standardizeCascade(
    OptCriterion optCriterion,
    OptCriterion? parent,
  ) {
    optCriterion.parent = parent;
    _allCriteriaMap[optCriterion.criterionName] = optCriterion;
    //
    for (OptCriterion child in optCriterion.children) {
      __standardizeCascade(child, optCriterion);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _isOptCriterion(String propName) {
    Criterion? prop = _allCriteriaMap[propName];
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
    for (Criterion prop in _allCriteriaMap.values) {
      prop._resetForNewTransaction();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _applyAllTempDataToReal() {
    for (Criterion prop in _allCriteriaMap.values) {
      prop._applyTempDataToReal();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempCurrentCriterionValue({required String criterionName}) {
    return _tempCurrentFormData[criterionName];
  }

  // ***************************************************************************
  // ***************************************************************************

  XOptionedData? _getTempOptCriterionData(String propName) {
    Criterion? prop = _allCriteriaMap[propName];
    if (prop == null) {
      return null;
    }
    if (prop is OptCriterion) {
      return prop._tempXOptionedData;
    }
    return null;
  }

  XOptionedData? _getOptCriterionData(String propName) {
    Criterion? prop = _allCriteriaMap[propName];
    if (prop == null) {
      return null;
    }
    if (prop is OptCriterion) {
      return prop._xOptionedData;
    }
    return null;
  }

  OptPropType? _getOptCriterionType(String propName) {
    Criterion? prop = _allCriteriaMap[propName];
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
    for (Criterion prop in _allCriteriaMap.values) {
      prop.candidateUpdateValue = null;
      prop._valueUpdated = false;
      prop._dirty = false;
    }
    //
    for (String propName in candidateUpdateValues.keys) {
      Criterion? prop = _allCriteriaMap[propName];
      if (prop != null) {
        prop._dirty = true;
      } else {
        _createAndAddNewCommomCriterion(
          criterionName: propName,
          dirty: true,
        );
      }
    }
    //
    for (OptCriterion rootCriterion in _rootOptCriteria) {
      rootCriterion._updateTempValueCascade(
        tempCurrentFormData: _tempCurrentFormData,
        updateValues: candidateUpdateValues,
      );
    }
    for (SimpleCriterion simpleCriterion in _simpleCriteria) {
      simpleCriterion._updateTempValue(
        tempCurrentFormData: _tempCurrentFormData,
        updateValues: candidateUpdateValues,
      );
    }
    // Apply to all dirty Criterion:
    for (Criterion prop in _allCriteriaMap.values) {
      if (prop._dirty) {
        _tempCurrentFormData[prop.criterionName] = prop.candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndAddNewCommomCriterion({
    required String criterionName,
    required bool dirty,
  }) {
    if (_allCriteriaMap.containsKey(criterionName)) {
      return;
    }
    SimpleCriterion? newSimpleCriterion = SimpleCriterion(
      criterionName: criterionName,
    );
    newSimpleCriterion._dirty = dirty;
    _allCriteriaMap[criterionName] = newSimpleCriterion;
    _simpleCriteria.add(newSimpleCriterion);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempOptCriterionData({
    required String criterionName,
    required XOptionedData? optionedData,
  }) {
    Criterion? prop = _allCriteriaMap[criterionName];
    if (prop == null) {
      throw AppException(message: 'No Criterion $criterionName');
    }
    if (prop is OptCriterion) {
      prop._tempXOptionedData = optionedData;
    } else {
      throw AppException(
          message: 'Invalid Criterion $criterionName, it must be $OptCriterion');
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _setTempSimpleCriterionData({
    required String criterionName,
    required Object? value,
  }) {
    _tempCurrentFormData[criterionName] = value;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addSimpleCriterion(SimpleCriterion prop) {
    if (!_allCriteriaMap.containsKey(prop.criterionName)) {
      _allCriteriaMap[prop.criterionName] = prop;
      _simpleCriteria.add(prop);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printTemporaryInfo(String prefix) {
    print("\n\n--------------------------------------------------------------");
    print(" ---> $prefix");
    for (OptCriterion rootItem in _rootOptCriteria) {
      rootItem._printTempInfoCascade(indentFactor: 1);
    }
    print("tempCurrentFormData: $_tempCurrentFormData");
    print("--------------------------------------------------------------");
  }
}
