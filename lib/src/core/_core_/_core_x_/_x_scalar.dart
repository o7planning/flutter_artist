part of '../core.dart';

class XScalar<VALUE extends Object> {
  XShelf get xShelf => xFilterModel.xShelf;

  QueryType __queryType = QueryType.realQuery;

  QueryType get queryType => __queryType;

  final Scalar<VALUE, FilterInput, FilterCriteria> scalar;

  final XFilterModel xFilterModel;

  XScalar get rootXScalar {
    if (parentXScalar == null) {
      return this;
    }
    return parentXScalar!.rootXScalar;
  }

  late final XScalar? parentXScalar;
  final List<XScalar> childXScalars = [];

  //

  QryHint __qryHint = QryHint.none;

  bool isRoot() {
    return parentXScalar == null;
  }

  bool isVipBranch() {
    return rootXScalar == xShelf.rootVipXScalar;
  }

  void setReQueryDone() {
    __qryHint = QryHint.none;
  }

  bool isReQueryDone() {
    return __qryHint == QryHint.none;
  }

  bool affectByFilterInput = false;

  String get name => scalar.name;

  int get xShelfId => xShelf.xShelfId;

  final ScalarQueryResult queryResult = ScalarQueryResult(precheck: null);

  // ***************************************************************************
  // ***************************************************************************

  _ScalarReQryCon? _scalarReQryCon;

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// IMPORTANT: To create new XScalar, use 'scalar._createXScalar' method
  /// to have the same Generics Parameters with the scalar.
  ///
  XScalar._({
    required this.scalar,
    required this.xFilterModel,
  }) {
    _scalarReQryCon = scalar._scalarReQryCondition;
    scalar._scalarReQryCondition = null;
  }

  QryHint get queryHint {
    return __qryHint;
  }

  void setQueryHint(QryHint qryHint) {
    __qryHint = qryHint;
  }

  void setQueryHintToGreater(QryHint qryHint) {
    if (__qryHint.isLessThan(qryHint)) {
      __qryHint = qryHint;
    }
  }

  void setOptions({
    required QueryType queryType,
  }) {
    __queryType = queryType;
  }

  void printInfo() {
    bool hasActiveUI = scalar.ui.hasActiveUiComponent();
    String msg =
        "${getClassName(this)}(${getClassName(
        scalar)} - UiActive: $hasActiveUI - needQuery: $queryHint)";
    print(msg);
  }

  String toDebugHtmlString() {
    return " - <b>XScalar (${getClassName(scalar)})</b>"
        "\n    - <b>needQuery</b>: $queryHint"
        "\n    - <b>scalarReQryCondition</b>: $_scalarReQryCon";
  }

  @override
  String toString() {
    return "XScalar (${getClassName(scalar)}) \n"
        "            - needQuery: $queryHint) / scalarReQryCon: $_scalarReQryCon";
  }
}
