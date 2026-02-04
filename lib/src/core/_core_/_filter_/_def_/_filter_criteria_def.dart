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

typedef Converter<BASE_VALUE> = SimpleVal Function(BASE_VALUE? baseValue);

class FilterCriterion<BASE_VALUE extends Object> {
  final String filterCriterionName;
  final String filterFieldName;

  final Converter<BASE_VALUE> __converter;

  Type get baseDataType {
    return BASE_VALUE;
  }

  String get baseDataTypeName {
    return getTypeNameWithoutGenerics(BASE_VALUE);
  }

  FilterCriterion({
    required this.filterCriterionName,
    required this.filterFieldName,
    required Converter<BASE_VALUE> converter,
  }) : __converter = converter;

  Object? _convert(BASE_VALUE? baseValue) {
    try {
      return __converter(baseValue).value;
    } catch (e, stackTrace) {
      print(stackTrace);
      throw AppError(
          errorMessage:
              "The ${getTypeNameWithoutGenerics(FilterCriterion)}.convert() "
              "method of criterionBaseName('$filterCriterionName') was called with error. $e");
    }
  }
}
