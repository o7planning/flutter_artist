part of '../core.dart';

class SortCriterionDef {
  final String criterionName;
  final String text;
  final String? translationKey;
  final bool severSideAcceptNoneDirection;
  final bool clientSideAcceptNoneDirection;
  final SortDirection? initialServerSideSortingDirection;
  final SortDirection? initialClientSideSortingDirection;

  SortCriterionDef({
    required this.criterionName,
    required this.text,
    this.translationKey,
    this.severSideAcceptNoneDirection = true,
    this.clientSideAcceptNoneDirection = true,
    required this.initialServerSideSortingDirection,
    this.initialClientSideSortingDirection,
  });
}
