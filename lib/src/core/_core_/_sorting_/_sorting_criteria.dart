part of '../core.dart';

class SortingCriteria extends Equatable {
  final List<SortingCriterion> _criteria;

  SortingCriteria._(List<SortingCriterion> criteria)
      : _criteria = [...criteria];

  List<SortingCriterion> _getNondirectionalCriteria() {
    return _criteria
        .where((c) => c.direction != SortingDirection.none)
        .toList();
  }

  ///
  /// Return a String. For example: "+categoryName,productName,-price".
  ///
  String toCriteriaString({
    bool ignoreNondirectional = true,
    String separator = ",",
  }) {
    List<SortingCriterion> list;
    if (ignoreNondirectional) {
      list = _getNondirectionalCriteria();
    } else {
      list = _criteria;
    }
    return list.map((c) => c.toCriterionString()).join(separator);
  }

  ///
  /// Return a Map<String, String>. For example:
  ///
  /// ```dart
  /// {"categoryName": "+", "productName": "", "price": "-"}
  /// ```
  ///
  Map<String, String> toCriteriaMap({bool ignoreNondirectional = true}) {
    List<SortingCriterion> list;
    if (ignoreNondirectional) {
      list = _getNondirectionalCriteria();
    } else {
      list = _criteria;
    }
    return {for (var e in list) e.criterionName: e.direction.sign};
  }

  ///
  /// Return JSON String. For example:
  ///
  /// ```json
  /// {
  ///    "categoryName": "+"
  ///    "productName": "",
  ///    "price": "-"
  /// }
  /// ```
  ///
  String toCriteriaJsonString({bool ignoreNondirectional = true}) {
    Map<String, String> m = toCriteriaMap(
      ignoreNondirectional: ignoreNondirectional,
    );
    return json.encode(m);
  }

  @override
  List<Object?> get props => [..._criteria];
}
