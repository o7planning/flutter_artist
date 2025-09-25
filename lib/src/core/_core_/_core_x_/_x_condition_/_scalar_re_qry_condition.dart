part of '../../core.dart';

class _ScalarReQryCon extends Equatable {
  final String? parentScalarValueId;
  final FilterCriteria? filterCriteria;

  const _ScalarReQryCon({
    required this.parentScalarValueId,
    required this.filterCriteria,
  });

  @override
  List<Object?> get props => [parentScalarValueId, filterCriteria];

  @override
  String toString() {
    return "parentScalarValueId: $parentScalarValueId, filterCriteria: ${filterCriteria == null ? 'null' : 'OK'}";
  }
}
