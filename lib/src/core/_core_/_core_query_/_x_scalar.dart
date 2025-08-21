part of '../core.dart';

class XScalar {
  XShelf get xShelf => xFilterModel.xShelf;

  final Scalar scalar;
  final XFilterModel xFilterModel;

  bool _processed = false;

  //

  QryHint __qryHint = QryHint.none;

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
