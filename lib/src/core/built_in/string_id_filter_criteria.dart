import '../_core_/core.dart';

class StringIdFilterCriteria extends FilterCriteria {
  final String? idValue;

  StringIdFilterCriteria({
    required this.idValue,
  });

  @override
  List<Criterionable> registerSupportedCriteria() {
    return [
      Criterionable<String>(
        criterionBaseName: 'id',
        jsonCriterionName: 'id',
        converter: (String? baseValue) {
          return SimpleVal.ofString(baseValue);
        },
      ),
    ];
  }
}
