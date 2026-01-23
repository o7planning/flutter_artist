import '../_core_/core.dart';

class IntIdFilterCriteria extends FilterCriteria {
  final int? idValue;

  IntIdFilterCriteria({
    required this.idValue,
  });

  @override
  List<Criterionable<Object>> registerSupportedCriteria() {
    return [];
  }

  @override
  List<String> getDebugCriterionInfos() {
    return ["idValue: $idValue"];
  }

  @override
  List<Object?> get props => [idValue];
}
