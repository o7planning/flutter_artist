import '../_core_/core.dart';

class StringValueFilterCriteria extends FilterCriteria {
  final String? stringValue;

  StringValueFilterCriteria({
    required this.stringValue,
  });

  @override
  List<Criterionable> registerSupportedCriteria() {
    return [
      Criterionable<String>(
        criterionBaseName: 'string',
        jsonCriterionName: 'string',
        converter: (String? baseValue) {
          return SimpleVal.ofString(baseValue);
        },
      ),
    ];
  }
}
