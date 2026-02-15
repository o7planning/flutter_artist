part of '../core.dart';

class FilterConditionStructure {
  final FilterConnector connector;
  final List<FilterConditionDef> conditionDefs;

  FilterConditionStructure({
    required this.connector,
    required this.conditionDefs,
  });
}
