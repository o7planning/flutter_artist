part of '../core.dart';

class SortCriterionModel {
  final String criterionName;
  final String text;
  final String? translationKey;
  final bool serverSideSkipNonDirectionWhileSelecting;
  final bool clientSideSkipNonDirectionWhileSelecting;
  final SortDirection? initialServerSideSortingDirection;
  final SortDirection? initialClientSideSortingDirection;

  SortCriterionModel({
    required this.criterionName,
    required this.text,
    this.translationKey,
    this.serverSideSkipNonDirectionWhileSelecting = false,
    this.clientSideSkipNonDirectionWhileSelecting = false,
    required this.initialServerSideSortingDirection,
    this.initialClientSideSortingDirection,
  });
}
