import '../_core_/core.dart';

// No subclasses allowed.
class EmptyFilterCriteria extends FilterCriteria {
  EmptyFilterCriteria._();

  factory EmptyFilterCriteria() => EmptyFilterCriteria._();

  @override
  List<String> getDebugCriterionInfos() {
    return [];
  }

  @override
  List<Criterionable> registerSupportedCriteria() {
    return [];
  }

  @override
  List<Object?> get props => [];
}
