part of '../core.dart';

class _QScalar {
  _QShelf get xShelf => xFilterModel.xShelf;

  final Scalar scalar;
  final _QFilterModel xFilterModel;

  bool _processed = false;

  //

  bool __forceQuery = false;
  bool affectByFilterInput = false;

  String get name => scalar.name;

  int get xShelfId => xShelf.xShelfId;

  final ScalarQueryResult queryResult = ScalarQueryResult(precheck: null);

  _QScalar({
    required this.scalar,
    required this.xFilterModel,
  });

  // TODO: Rename?
  bool get needQuery {
    return __forceQuery;
  }

  void setForceQuery() {
    __forceQuery = true;
  }

  void printInfo() {
    bool hasActiveUI = scalar.ui.hasActiveUIComponent();
    String msg =
        "${getClassName(this)}(${getClassName(scalar)} - UIActive: $hasActiveUI - needQuery: $needQuery)";
    print(msg);
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(scalar)} - needQuery: $needQuery)";
  }
}
