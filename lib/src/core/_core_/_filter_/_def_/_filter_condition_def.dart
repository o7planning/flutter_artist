part of '../../core.dart';

class FilterConditionDef implements FilterGroupMemberDef {
  final bool criterionable;
  final CriterionPlus _criterionPlus;
  final CriterionOperator operator;
  late final List<CriterionOperator> _supportedOperators;

  List<CriterionOperator> get supportedOperators =>
      List.unmodifiable(_supportedOperators);

  late final FilterCriteriaGroupDef group;

  String get criterionNamePlus => _criterionPlus.criterionNamePlus;

  String get criterionName => _criterionPlus.criterionName;

  String? get suffix => _criterionPlus.suffix;

  FilterConditionDef({
    required String criterionNamePlus,
    required this.operator,
    List<CriterionOperator>? supportedOperators,
  })  : criterionable = true,
        _criterionPlus = CriterionPlus.parse(
          criterionNamePlus: criterionNamePlus,
        ) {
    _supportedOperators = supportedOperators == null
        ? [operator]
        : {...supportedOperators, operator}.toList();
  }
}
