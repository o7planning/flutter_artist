part of '../flutter_artist.dart';

class _XScalar {
  final _XShelf xShelf;
  bool __forceQuery = false;
  bool affectByFilterInput = false;
  final Scalar scalar;
  final _XFilterModel xFilterModel;

  String get name => scalar.name;

  int get xShelfId => xShelf.xShelfId;

  // ***************************************************************************
  // ***************************************************************************

  _XScalar({
    required this.xShelf,
    required this.scalar,
    required this.xFilterModel,
  });

  // ***************************************************************************
  // ***************************************************************************

  var queryResult = ScalarQueryResult();

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
