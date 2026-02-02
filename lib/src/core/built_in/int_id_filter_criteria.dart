import '../_core_/core.dart';

class IntIdFilterCriteria extends FilterCriteria {
  final int? idValue;

  IntIdFilterCriteria({
    required this.idValue,
  });

  @override
  List<FilterCriterion> registerSupportedCriteria() {
    return [
      FilterCriterion<int>(
        filterCriterionName: 'id',
        filterFieldName: 'id',
        converter: (int? baseValue) {
          return SimpleVal.ofInt(baseValue);
        },
      ),
    ];
  }
}
