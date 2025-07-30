part of '../core.dart';

class _XScalar {
  final _XShelf xShelf;
  bool __forceQuery = false;
  bool affectByFilterInput = false;
  final Scalar scalar;
  final _XFilterModel xFilterModel;

  String get name => scalar.name;

  int get xShelfId => xShelf.xShelfId;

  final ScalarQueryResult queryResult = ScalarQueryResult(precheck: null);

  // ***************************************************************************
  // ***************************************************************************

  _XScalar({
    required this.xShelf,
    required this.scalar,
    required this.xFilterModel,
  });

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Doi ten?
  bool get needQuery {
    return __forceQuery;
  }

  void setForceQuery() {
    __forceQuery = true;
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(scalar)} - needQuery: $needQuery)";
  }
}
