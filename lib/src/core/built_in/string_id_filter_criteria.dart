import '../_core_/core.dart';

class StringIdFilterCriteria extends FilterCriteria {
  final String? idValue;

  StringIdFilterCriteria({
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
