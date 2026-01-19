part of '../core.dart';

class SortCriterionDef {
  final String criterionName;
  final String text;
  final String? translationKey;
  final bool serverSideSkipNonDirectionWhileSelecting;
  final bool clientSideSkipNonDirectionWhileSelecting;
  final SortDirection? initialServerSideSortingDirection;
  final SortDirection? initialClientSideSortingDirection;

  SortCriterionDef({
    required this.criterionName,
    required this.text,
    this.translationKey,
    this.serverSideSkipNonDirectionWhileSelecting = false,
    this.clientSideSkipNonDirectionWhileSelecting = false,
    required this.initialServerSideSortingDirection,
    this.initialClientSideSortingDirection,
  });
}
