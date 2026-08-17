part of '../core.dart';

class FilterCriteriaMappedValue<FILTER_CRITERIA extends FilterCriteria>
    extends Equatable {
  final FILTER_CRITERIA filterCriteria;
  final Map<String, dynamic> filterCriteriaMap;

  const FilterCriteriaMappedValue({
    required this.filterCriteria,
    required this.filterCriteriaMap,
  });

  @override
  List<Object?> get props => [filterCriteria];
}
