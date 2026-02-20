import '_filter_model_register_error.dart';

class FilterCriterionNoFieldValueConverterError
    extends FilterModelRegisterError {
  final String criterionBaseName;
  final Type dataType;

  FilterCriterionNoFieldValueConverterError({
    required this.criterionBaseName,
    required this.dataType,
  });
}
