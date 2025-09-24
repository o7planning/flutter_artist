part of '../../core.dart';

class _ScalarReQryCon extends Equatable {
  final String? valueId;
  final FilterCriteria? filterCriteria;

  const _ScalarReQryCon({
    required this.valueId,
    required this.filterCriteria,
  });

  @override
  List<Object?> get props => [valueId, filterCriteria];
}
