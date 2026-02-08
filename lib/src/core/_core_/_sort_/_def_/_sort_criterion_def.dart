part of '../../core.dart';

class SortCriterionDef {
  final String criterionName;
  final String text;
  final String? translationKey;

  final SortCriterionConfig serverSideConfig;
  final SortCriterionConfig clientSideConfig;

  SortCriterionDef({
    required this.criterionName,
    required this.text,
    this.translationKey,
    this.serverSideConfig = const SortCriterionConfig(),
    this.clientSideConfig = const SortCriterionConfig(),
  });
}

class SortCriterionConfig {
  final SortDirection? initialSortDirection;
  final bool directionalSelectionOnly;

  const SortCriterionConfig({
    this.initialSortDirection,
    this.directionalSelectionOnly = false,
  });
}
