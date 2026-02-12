part of '../../core.dart';

class SimpleVal extends Equatable {
  final dynamic value;

  const SimpleVal.ofString(String? this.value);

  const SimpleVal.ofDouble(double? this.value);

  const SimpleVal.ofInt(int? this.value);

  const SimpleVal.ofBool(bool? this.value);

  static bool isSimpleValue(Object? baseValue) {
    if (baseValue is String? ||
        baseValue is double? ||
        baseValue is int? ||
        baseValue is bool?) {
      return true;
    }
    return false;
  }

  static bool isSimpleDataType(Type dataType) {
    if (dataType == String ||
        dataType == double ||
        dataType == int ||
        dataType == bool) {
      return true;
    }
    return false;
  }

  @override
  List<Object?> get props => [value];
}

typedef Converter<RAW_VALUE> = SimpleVal Function(RAW_VALUE? rawValue);

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
