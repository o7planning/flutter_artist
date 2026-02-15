part of '../../core.dart';

typedef Converter<RAW_VALUE> = SimpleVal Function(RAW_VALUE? rawValue);

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
