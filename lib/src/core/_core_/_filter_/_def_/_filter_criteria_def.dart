part of '../../core.dart';

class SimpleVal extends Equatable {
  final dynamic value;

  const SimpleVal.ofString(String? this.value);

  const SimpleVal.ofDouble(double? this.value);

  const SimpleVal.ofInt(int? this.value);

  const SimpleVal.ofBool(bool? this.value);

  @override
  List<Object?> get props => [value];
}

typedef Converter<BASE_VALUE> = SimpleVal Function(BASE_VALUE? baseValue);

class Criterionable<BASE_VALUE extends Object> {
  final String criterionBaseName;
  final String jsonCriterionName;

  final Converter<BASE_VALUE> __converter;

  Type get baseDataType {
    return BASE_VALUE;
  }

  String get baseDataTypeName {
    return getTypeNameWithoutGenerics(BASE_VALUE);
  }

  Criterionable({
    required this.criterionBaseName,
    required this.jsonCriterionName,
    required Converter<BASE_VALUE> converter,
  }) : __converter = converter;

  Object? _convert(BASE_VALUE? baseValue) {
    try {
      return __converter(baseValue).value;
    } catch (e, stackTrace) {
      print(stackTrace);
      throw AppError(
          errorMessage:
              "The ${getTypeNameWithoutGenerics(Criterionable)}.convert() "
              "method of criterionBaseName('$criterionBaseName') was called with error. $e");
    }
  }
}
