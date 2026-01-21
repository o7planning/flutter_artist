import '../_core_/core.dart';

class StringValueFilterCriteria extends FilterCriteria {
  final String? stringValue;

  StringValueFilterCriteria({
    required this.stringValue,
  });

  @override
  List<Criterionable<Object>> registerSupportedCriteria() {
    return [];
  }

  @override
  List<String> getDebugCriterionInfos() {
    return ["stringValue: $stringValue"];
  }

  @override
  List<Object?> get props => [stringValue];
}
