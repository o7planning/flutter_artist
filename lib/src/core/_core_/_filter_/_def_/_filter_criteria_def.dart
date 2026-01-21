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

class Criterionable<BASE_VALUE extends Object> {
  final String criterionBaseName;
  final String jsonCriterionName;

  final SimpleVal Function(BASE_VALUE? baseValue) converter;

  Criterionable({
    required this.criterionBaseName,
    required this.jsonCriterionName,
    required this.converter,
  });
}
