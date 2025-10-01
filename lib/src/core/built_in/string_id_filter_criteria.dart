import '../_core_/core.dart';

class StringIdFilterCriteria extends FilterCriteria {
  final String? idValue;

  const StringIdFilterCriteria({required this.idValue});

  @override
  List<String> getDebugInfos() {
    return ["idValue: $idValue"];
  }

  @override
  List<Object?> get props => [idValue];
}
