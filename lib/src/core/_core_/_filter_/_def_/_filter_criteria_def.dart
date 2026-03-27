part of '../../core.dart';

class FilterCriterion<RAW_VALUE extends Object> {
  final String filterCriterionName;
  final String filterFieldName;

  final Converter<RAW_VALUE> __converter;

  Type get rawDataType {
    return RAW_VALUE;
  }

  String get rawDataTypeName {
    return getTypeNameWithoutGenerics(RAW_VALUE);
  }

  FilterCriterion({
    required this.filterCriterionName,
    required this.filterFieldName,
    required Converter<RAW_VALUE> converter,
  }) : __converter = converter;

  Object? _convert(RAW_VALUE? rawValue) {
    try {
      return __converter(rawValue).value;
    } catch (e, stackTrace) {
      print(stackTrace);
      throw AppError(
          errorMessage:
              "The ${getTypeNameWithoutGenerics(FilterCriterion)}.convert() "
              "method of criterionBaseName('$filterCriterionName') was called with error. $e");
    }
  }
}
