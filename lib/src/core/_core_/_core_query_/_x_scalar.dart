part of '../core.dart';

class XScalar<VALUE extends Object, FILTER_INPUT extends FilterInput> {
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

  XScalar({
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
