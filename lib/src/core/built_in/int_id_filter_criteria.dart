import '../_core_/core.dart';

class IntIdFilterCriteria extends FilterCriteria {
  final int? idValue;

  IntIdFilterCriteria({
    required this.idValue,
  });

  @override
  List<Criterionable> registerSupportedCriteria() {
    return [
      Criterionable<int>(
        criterionBaseName: 'id',
        jsonCriterionName: 'id',
        converter: (int? baseValue) {
          return SimpleVal.ofInt(baseValue);
        },
      ),
    ];
  }
}
