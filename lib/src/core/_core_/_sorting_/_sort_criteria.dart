part of '../core.dart';

class SortCriteria extends Equatable {
  final List<SortCriterion> _criteria;

  SortCriteria._(List<SortCriterion> criteria) : _criteria = [...criteria];

  List<SortCriterion> _getNondirectionalCriteria() {
    return _criteria.where((c) => c.direction != null).toList();
  }

  ///
  /// Return a String. For example: "+categoryName,productName,-price".
  ///
  String toCriteriaString({
    bool ignoreNondirectional = true,
    String separator = ",",
  }) {
    List<SortCriterion> list;
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
    List<SortCriterion> list;
    if (ignoreNondirectional) {
      list = _getNondirectionalCriteria();
    } else {
      list = _criteria;
    }
    return {
      for (var e in list)
        e.criterionName: e.direction == null ? "" : e.direction!.sign
    };
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
