import '../_core_/core.dart';

// No subclasses allowed.
// @immutable
class EmptyFilterCriteria extends FilterCriteria {
  EmptyFilterCriteria._()
      : super(
            conditionStructure: ConditionStructureDetail.empty(),
            criteria: const []);

  factory EmptyFilterCriteria() => EmptyFilterCriteria._();

  @override
  List<String> getDebugCriterionInfos() {
    return [];
  }
}
