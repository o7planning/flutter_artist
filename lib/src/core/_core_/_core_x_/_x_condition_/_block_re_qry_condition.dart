part of '../../core.dart';

class _BlockReQryCon extends Equatable {
  final Object? parentItemId;
  final FilterCriteria? filterCriteria;

  const _BlockReQryCon({
    required this.parentItemId,
    required this.filterCriteria,
  });

  @override
  List<Object?> get props => [parentItemId, filterCriteria];

  @override
  String toString() {
    return "parentItemId: $parentItemId, filterCriteria: ${filterCriteria == null ? 'null' : 'OK'}";
  }
}
