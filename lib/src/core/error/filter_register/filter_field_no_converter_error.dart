import 'filter_criterion_register_error.dart';

class FilterFieldNoConverterError extends FilterCriterionRegisterError {
  final String criterionBaseName;
  final Type dataType;

  FilterFieldNoConverterError({
    required this.criterionBaseName,
    required this.dataType,
  });
}
