part of '../core.dart';

@immutable
abstract class FilterCriteria extends Equatable {
  const FilterCriteria();

  List<String> getDebugInfos();
}

class XFilterCriteria<FILTER_CRITERIA extends FilterCriteria>
    extends Equatable {
  final FILTER_CRITERIA filterCriteria;
  final Map<String, dynamic> filterCriteriaMap;

  const XFilterCriteria({
    required this.filterCriteria,
    required this.filterCriteriaMap,
  });

  @override
  List<Object?> get props => [filterCriteria];
}
