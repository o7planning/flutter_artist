part of '../core.dart';

class SortCriterionDef {
  final String criterionName;
  final String text;
  final String? translationKey;
  final SortDirection? serverDirection;
  final SortDirection? clientDirection;

  SortCriterionDef({
    required this.criterionName,
    required this.text,
    this.translationKey,
    required this.serverDirection,
    this.clientDirection,
  });
}
