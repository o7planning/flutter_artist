part of '../core.dart';

class _XScalar {
  _XShelf get xShelf => xFilterModel.xShelf;

  final Scalar scalar;
  final _XFilterModel xFilterModel;

  bool _processed = false;

  //

  QryHint __qryHint = QryHint.none;
  bool affectByFilterInput = false;

  String get name => scalar.name;

  int get xShelfId => xShelf.xShelfId;

  final ScalarQueryResult queryResult = ScalarQueryResult(precheck: null);

  _XScalar({
    required this.scalar,
    required this.xFilterModel,
  });

  QryHint get queryHint {
    return __qryHint;
  }

  void setForceHint(QryHint qryHint) {
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
