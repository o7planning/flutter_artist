import '../_core_/core.dart';
import '../enums/_selection_type.dart';

class StringValueFilterCriteria extends FilterCriteria {
  final String? stringValue;

  const StringValueFilterCriteria({required this.stringValue});

  @override
  List<String> getDebugInfos() {
    return ["stringValue: $stringValue"];
  }

  @override
  List<Object?> get props => [stringValue];
}
