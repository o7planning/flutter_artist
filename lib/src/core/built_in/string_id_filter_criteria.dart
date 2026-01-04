import '../_core_/core.dart';

class StringIdFilterCriteria extends FilterCriteria {
  final String? idValue;

  StringIdFilterCriteria({required this.idValue})
      // TODO: Xem lai.
      : super(
            conditionStructure: ConditionStructureDetail.empty(), criteria: []);

  @override
  List<String> getDebugCriterionInfos() {
    return ["idValue: $idValue"];
  }
}
