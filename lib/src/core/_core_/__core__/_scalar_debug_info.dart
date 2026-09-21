part of '../core.dart';

class _ScalarDebugInfo {
  final Scalar _scalar;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  int __performQueryCount = 0;

  int get performQueryCount => __performQueryCount;

  int get filterCriteriaChangeCount =>
      _scalar.__scalarData._filterCriteriaChangeCount;

  String get classDefinition {
    return "${getClassName(this)}$classParametersDefinition";
  }

  String get classParametersDefinition {
    return "<${_scalar.getFilterInputType()}, ${_scalar.getValueType()}, ${_scalar.getFilterCriteriaType()}>";
  }

  _ScalarDebugInfo({required Scalar scalar}) : _scalar = scalar;
}
