part of '../core.dart';

/// Represents an immutable criteria snapshot produced by the FilterModel evaluation pipeline.
sealed class FilterCriteriaSnapshot<FILTER_CRITERIA extends FilterCriteria>
    extends Equatable {
  const FilterCriteriaSnapshot();

  bool get isSuccess => this is FilterCriteriaSnapshotSuccess<FILTER_CRITERIA>;

  bool get isError => this is FilterCriteriaSnapshotError<FILTER_CRITERIA>;

  FILTER_CRITERIA? get criteriaOrNull => switch (this) {
        FilterCriteriaSnapshotSuccess(:final filterCriteria) => filterCriteria,
        _ => null,
      };

  ErrorInfo? get errorInfoOrNull => switch (this) {
        FilterCriteriaSnapshotError(:final errorInfo) => errorInfo,
        _ => null,
      };
}

/// A fully resolved, valid criteria snapshot ready for consumption.
final class FilterCriteriaSnapshotSuccess<
        FILTER_CRITERIA extends FilterCriteria>
    extends FilterCriteriaSnapshot<FILTER_CRITERIA> {
  final FILTER_CRITERIA filterCriteria;
  final Map<String, dynamic> filterCriteriaMap;

  const FilterCriteriaSnapshotSuccess({
    required this.filterCriteria,
    required this.filterCriteriaMap,
  });

  @override
  List<Object?> get props => [filterCriteria];
}

/// A failed criteria snapshot carrying diagnostic error metadata.
final class FilterCriteriaSnapshotError<FILTER_CRITERIA extends FilterCriteria>
    extends FilterCriteriaSnapshot<FILTER_CRITERIA> {
  final ErrorInfo errorInfo;

  const FilterCriteriaSnapshotError({
    required this.errorInfo,
  });

  @override
  List<Object?> get props => [errorInfo];
}
