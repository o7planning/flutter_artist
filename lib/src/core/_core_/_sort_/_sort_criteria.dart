part of '../core.dart';

class SortCriteria extends Equatable {
  final List<SortableCriterion> _criteria;

  SortCriteria._(List<SortableCriterion> criteria)
      : _criteria = List.unmodifiable(criteria);

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
  /// {"categoryName": "asc", "price": "desc"}
  /// ```
  ///
  Map<String, String> toCriteriaMap() {
    return {
      for (var e in _criteria) e.tildeCriterionName: e.direction.sqlKeyword
    };
  }

  ///
  /// Return JSON String. For example:
  ///
  /// ```json
  /// {
  ///    "categoryName": "asc"
  ///    "productName": "desc",
  ///    "price": "desc"
  /// }
  /// ```
  ///
  String toCriteriaJsonString() {
    Map<String, String> m = toCriteriaMap();
    return json.encode(m);
  }

  @override
  List<Object?> get props => List.unmodifiable(_criteria);
}
