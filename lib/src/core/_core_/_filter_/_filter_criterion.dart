part of '../core.dart';

class FilterCriterion<V> extends Equatable {
  final String criterionName;
  final String? jsonCriterionName;
  final V? value;

  const FilterCriterion({
    required this.criterionName,
    required this.jsonCriterionName,
    required this.value,
  });

  @override
  List<Object?> get props => [value];
}

class JsonFilterCriterionValue extends Equatable {
  final dynamic value;

  const JsonFilterCriterionValue.ofString(String? this.value);

  const JsonFilterCriterionValue.ofDouble(double? this.value);

  const JsonFilterCriterionValue.ofInt(int? this.value);

  const JsonFilterCriterionValue.ofBool(bool? this.value);

  @override
  List<Object?> get props => [value];
}

class JsonFilterCriterion extends Equatable {
  final String jsonCriterionName;
  final JsonFilterCriterionValue value;

  const JsonFilterCriterion({
    required this.jsonCriterionName,
    required this.value,
  });

  @override
  List<Object?> get props => [jsonCriterionName, value];
}

// *****************************************************************************
// *****************************************************************************

class JsonFilterCriteria extends Equatable {
  final ConditionStructure condition;
  final List<JsonFilterCriterion> criteria;

  const JsonFilterCriteria({
    required this.condition,
    required this.criteria,
  });

  // TODO:
  @override
  List<Object?> get props => criteria;
}
