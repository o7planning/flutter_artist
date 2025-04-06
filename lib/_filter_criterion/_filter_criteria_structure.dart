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
    for (String criterionName in simpleCriterionList) {
      _createAndAddNewSimpleCriterion(
        criterionName: criterionName,
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

  bool _isOptCriterion(String criterionName) {
    Criterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      return false;
    }
    if (criterion is OptCriterion) {
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
    for (Criterion criterion in _allCriteriaMap.values) {
      criterion._resetForNewTransaction();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _applyAllTempDataToReal() {
    for (Criterion criterion in _allCriteriaMap.values) {
      criterion._applyTempDataToReal();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic _getTempCurrentCriterionValue({required String criterionName}) {
    return _tempCurrentFormData[criterionName];
  }

  // ***************************************************************************
  // ***************************************************************************

  XOptionedData? _getTempOptCriterionData(String criterionName) {
    Criterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is OptCriterion) {
      return criterion._tempXOptionedData;
    }
    return null;
  }

  XOptionedData? _getOptCriterionData(String criterionName) {
    Criterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is OptCriterion) {
      return criterion._xOptionedData;
    }
    return null;
  }

  OptPropType? _getOptCriterionType(String criterionName) {
    Criterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      return null;
    }
    if (criterion is OptCriterion) {
      return criterion.type;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateTempData(Map<String, dynamic> updateData) {
    final candidateUpdateValues = {...updateData};
    //
    // IMPORTANT:
    // Update data for FilterCriteriaStructure. From ROOTs to LEAVES.
    // (***):
    // And Update children-OptCriterion data to null if parent-Value is null or not selected.
    //
    for (Criterion criterion in _allCriteriaMap.values) {
      criterion.candidateUpdateValue = null;
      criterion._valueUpdated = false;
      criterion._dirty = false;
    }
    //
    for (String criterionName in candidateUpdateValues.keys) {
      Criterion? criterion = _allCriteriaMap[criterionName];
      if (criterion != null) {
        criterion._dirty = true;
      } else {
        _createAndAddNewSimpleCriterion(
          criterionName: criterionName,
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
    for (Criterion criterion in _allCriteriaMap.values) {
      if (criterion._dirty) {
        _tempCurrentFormData[criterion.criterionName] =
            criterion.candidateUpdateValue;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndAddNewSimpleCriterion({
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
    Criterion? criterion = _allCriteriaMap[criterionName];
    if (criterion == null) {
      throw AppException(message: 'No Criterion $criterionName');
    }
    if (criterion is OptCriterion) {
      criterion._tempXOptionedData = optionedData;
    } else {
      throw AppException(
          message:
              'Invalid Criterion $criterionName, it must be $OptCriterion');
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

  void _addSimpleCriterion(SimpleCriterion criterion) {
    if (!_allCriteriaMap.containsKey(criterion.criterionName)) {
      _allCriteriaMap[criterion.criterionName] = criterion;
      _simpleCriteria.add(criterion);
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
    print("--------------------------------------------------------------\n\n");
  }
}
