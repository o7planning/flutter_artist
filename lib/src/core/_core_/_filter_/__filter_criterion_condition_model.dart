part of '../core.dart';

class FilterCriterionConditionModel implements FilterConditionModel {
  late final FilterCriteriaGroupModel? parent;
  final FilterConditionDef filterConditionDef;
  late final FilterModelStructure structure;

  //
  String get criterionNamePlus => filterConditionDef.criterionNamePlus;

  String get criterionName => filterConditionDef.criterionName;

  CriterionOperator get operator => filterConditionDef.operator;

  List<CriterionOperator> get supportedOperators =>
      filterConditionDef.supportedOperators;

  //
  late final FilterCriterionModel criterionModel;

  FilterCriterionConditionModel({
    required this.structure,
    required this.filterConditionDef,
    required this.parent,
  }) {
    criterionModel = structure._findOrInitFilterCriterionModel(
      filterConditionDef: filterConditionDef,
    );
  }

  @override
  Map<String, dynamic> toConditionMap() {
    final Map<String, dynamic> map = {
      "criterionNamePlus": criterionNamePlus,
      "value": criterionModel.currentValue,
      "operator": operator.text,
    };
    //
    return map;
  }
}

abstract class FilterCriterionModel<V> {
  final String criterionNamePlus;
  late final String criterionName;
  late final String? suffixName;

  final String? description;

  // IMPORTANT: Do not change type (dynamic).
  dynamic _candidateUpdateValue;
  bool _valueUpdated = false;
  bool _markTempDirty = false;

  //
  // IMPORTANT: Do not change type (dynamic).
  dynamic _tempCurrentValue;
  XData? _tempCurrentXData;

  // IMPORTANT: Do not change type (dynamic).
  dynamic _tempInitialValue;
  XData? _tempInitialXData;

  // IMPORTANT: Do not change type (dynamic).
  dynamic _currentValue;
  XData? _currentXData;

  // IMPORTANT: Do not change type (dynamic).
  dynamic _initialValue;
  XData? _initialXData;

  //

  XData? get currentXData => _currentXData;

  // IMPORTANT: Do not change type (dynamic).
  dynamic get currentValue => _currentValue;

  XData? get initialXData => _initialXData;

  // IMPORTANT: Do not change type (dynamic).
  dynamic get initialValue => _initialValue;

  Type get dataType => V;

  FilterCriterionModel({
    required this.criterionNamePlus,
    required this.description,
  }) {
    final criterionPlus = CriterionPlus.parse(
      criterionNamePlus: criterionNamePlus,
    );
    criterionName = criterionPlus.criterionName;
    suffixName = criterionPlus.suffix;
  }

  FilterCriterion<V> toFilterCriterion() {
    return FilterCriterion<V>(
      criterionName: criterionNamePlus,
      jsonCriterionName: null,
      value: _currentValue,
    );
  }

  bool isDirty() {
    return !ComparisonUtils.compareDynamicAndDynamic(
      _currentValue,
      _initialValue,
    );
  }
}
