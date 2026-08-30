part of '../core.dart';

class XScalar<ID extends Comparable, VALUE extends Identifiable<ID>> {
  XShelf get xShelf => xFilterModel.xShelf;

  QueryType __queryType = QueryType.realQuery;

  QueryType get queryType => __queryType;

  final Scalar<ID, VALUE, FilterInput, FilterCriteria> scalar;

  final XFilterModel xFilterModel;

  XScalar get rootXScalar {
    if (parentXScalar == null) {
      return this;
    }
    return parentXScalar!.rootXScalar;
  }

  late final XScalar? parentXScalar;
  final List<XScalar> childXScalars = [];

  List<XScalar> getDecendentXScalars({required bool sameFilterOnly}) {
    final List<XScalar> ret = [];
    final thisFm = scalar.registeredOrDefaultFilterModel;
    for (XScalar childXScalar in childXScalars) {
      FilterModel fmc = childXScalar.scalar.registeredOrDefaultFilterModel;
      if (!sameFilterOnly || (sameFilterOnly && fmc == thisFm)) {
        ret.add(childXScalar);
      }
      ret.addAll(
        childXScalar.getDecendentXScalars(sameFilterOnly: sameFilterOnly),
      );
    }
    return ret;
  }

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

  ///
  /// IMPORTANT: To create new XScalar, use 'scalar._createXScalar' method
  /// to have the same Generics Parameters with the scalar.
  ///
  XScalar._({
    required this.scalar,
    required this.xFilterModel,
  });

  // ***************************************************************************

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
        "${getClassName(this)}(${getClassName(scalar)} - UiActive: $hasActiveUI - needQuery: $queryHint)";
    print(msg);
  }

  String toDebugHtmlString() {
    return " - <b>XScalar (${getClassName(scalar)})</b>"
        "\n    - <b>queryHint</b>: $queryHint";
  }

  @override
  String toString() {
    return "XScalar (${getClassName(scalar)}) \n"
        "            - queryHint: $queryHint";
  }
}
