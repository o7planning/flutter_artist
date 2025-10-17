part of '../core.dart';

class SortableCriteria extends Equatable {
  final List<SortableCriterion> _criteria;

  SortableCriteria._(List<SortableCriterion> criteria)
      : _criteria = [...criteria];

  ///
  /// Return a String. For example: "+categoryName,productName,-price".
  ///
  String toCriteriaString({
    String separator = ",",
  }) {
    return _criteria.map((c) => c.toCriterionString()).join(separator);
  }

  ///
  /// Return a Map<String, String>. For example:
  ///
  /// ```dart
  /// {"categoryName": "+", "price": "-"}
  /// ```
  ///
  Map<String, String> toCriteriaMap() {
    return {for (var e in _criteria) e.criterionName: e.direction.sign};
  }

  ///
  /// Return JSON String. For example:
  ///
  /// ```json
  /// {
  ///    "categoryName": "+"
  ///    "productName": "-",
  ///    "price": "-"
  /// }
  /// ```
  ///
  String toCriteriaJsonString() {
    Map<String, String> m = toCriteriaMap();
    return json.encode(m);
  }

  @override
  List<Object?> get props => [..._criteria];
}
