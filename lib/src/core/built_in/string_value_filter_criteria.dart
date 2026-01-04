import '../_core_/core.dart';

class StringValueFilterCriteria extends FilterCriteria {
  final String? stringValue;

  StringValueFilterCriteria({required this.stringValue})
      // TODO: Xem lai.
      : super(
            conditionStructure: ConditionStructureDetail.empty(), criteria: []);

  @override
  List<String> getDebugCriterionInfos() {
    return ["stringValue: $stringValue"];
  }
}
