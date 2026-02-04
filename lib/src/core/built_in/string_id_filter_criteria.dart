import '../_core_/core.dart';

class StringIdFilterCriteria extends FilterCriteria {
  final String? idValue;

  StringIdFilterCriteria({
    required this.idValue,
  });

  @override
  List<FilterCriterion> registerSupportedCriteria() {
    return [
      FilterCriterion<String>(
        filterCriterionName: 'id',
        filterFieldName: 'id',
        converter: (String? baseValue) {
          return SimpleVal.ofString(baseValue);
        },
      ),
    ];
  }
}
