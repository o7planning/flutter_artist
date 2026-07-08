part of '../core.dart';

class _ScalarRequeryCondition extends Equatable {
  final String? parentScalarValueId;
  final FilterCriteria? filterCriteria;

  const _ScalarRequeryCondition({
    required this.parentScalarValueId,
    required this.filterCriteria,
  });

  @override
  List<Object?> get props => [parentScalarValueId, filterCriteria];

  @override
  String toString() {
    return "parentScalarValueId: $parentScalarValueId, filterCriteria: ${filterCriteria ==
        null ? 'null' : 'OK'}";
  }
}
