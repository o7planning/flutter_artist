import '../_core_/core.dart';

class IntIdFilterCriteria extends FilterCriteria {
  final int? idValue;

  const IntIdFilterCriteria({required this.idValue});

  @override
  List<String> getDebugInfos() {
    return ["idValue: $idValue"];
  }

  @override
  List<Object?> get props => [idValue];
}
