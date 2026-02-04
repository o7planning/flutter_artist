import '../_core_/core.dart';

class StringValueFilterCriteria extends FilterCriteria {
  final String? stringValue;

  StringValueFilterCriteria({
    required this.stringValue,
  });

  @override
  List<FilterCriterion> registerSupportedCriteria() {
    return [
      FilterCriterion<String>(
        filterCriterionName: 'string',
        filterFieldName: 'string',
        converter: (String? baseValue) {
          return SimpleVal.ofString(baseValue);
        },
      ),
    ];
  }
}
