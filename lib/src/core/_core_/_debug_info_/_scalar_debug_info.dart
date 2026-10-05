part of '../core.dart';

class _ScalarDebugInfo {
  final Scalar _scalar;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  int _performQueryCount = 0;

  int get performQueryCount => _performQueryCount;

  int get filterCriteriaChangeCount => _scalar._filterCriteriaChangeCount;

  String get classDefinition {
    return "${getClassName(_scalar)}$classParametersDefinition";
  }

  String get classParametersDefinition {
    return "<${_scalar.getFilterInputType()}, ${_scalar.getValueType()}, ${_scalar.getFilterCriteriaType()}>";
  }

  _ScalarDebugInfo({required Scalar scalar}) : _scalar = scalar;
}
