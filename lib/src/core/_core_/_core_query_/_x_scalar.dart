part of '../core.dart';

class XScalar<VALUE extends Object> {
  XShelf get xShelf => xFilterModel.xShelf;

  final Scalar<VALUE, FilterInput, FilterCriteria> scalar;

  final XFilterModel xFilterModel;

  //

  QryHint __qryHint = QryHint.none;

  bool isVipBranch() {
    return this == xShelf.vipXScalar;
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

  ///
  /// IMPORTANT: To create new XScalar, use 'scalar._createXScalar' method
  /// to have the same Generics Parameters with the scalar.
  ///
  XScalar._({
    required this.scalar,
    required this.xFilterModel,
  });

  QryHint get queryHint {
    return __qryHint;
  }

  void setQueryHint(QryHint qryHint) {
    __qryHint = qryHint;
  }

  void printInfo() {
    bool hasActiveUI = scalar.ui.hasActiveUIComponent();
    String msg =
        "${getClassName(this)}(${getClassName(scalar)} - UIActive: $hasActiveUI - needQuery: $queryHint)";
    print(msg);
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(scalar)} - needQuery: $queryHint)";
  }
}
