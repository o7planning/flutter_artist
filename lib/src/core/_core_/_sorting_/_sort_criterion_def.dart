part of '../core.dart';

class SortCriterionDef {
  final String criterionName;
  final String text;
  final String? translationKey;
  final bool severSideAcceptNonDirection;
  final bool clientSideAcceptNonDirection;
  final SortDirection? initialServerSideSortingDirection;
  final SortDirection? initialClientSideSortingDirection;

  SortCriterionDef({
    required this.criterionName,
    required this.text,
    this.translationKey,
    this.severSideAcceptNonDirection = true,
    this.clientSideAcceptNonDirection = true,
    required this.initialServerSideSortingDirection,
    this.initialClientSideSortingDirection,
  });
}
