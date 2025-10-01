part of '../core.dart';

@immutable
abstract class FilterCriteria extends Equatable {
  const FilterCriteria();

  List<String> getDebugInfos();
}
