import '../_core_/core.dart';

class IntIdFilterCriteria extends FilterCriteria {
  final int? idValue;

  IntIdFilterCriteria({required this.idValue})
      // TODO: Xem lai.
      : super(
            conditionStructure: ConditionStructureDetail.empty(), criteria: []);

  @override
  List<String> getDebugCriterionInfos() {
    return ["idValue: $idValue"];
  }
}
