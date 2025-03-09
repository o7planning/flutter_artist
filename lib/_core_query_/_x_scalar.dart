part of '../flutter_artist.dart';

class _XScalar {
  bool __forceQuery = false;
  bool affectByFilterInput = false;
  final Scalar scalar;
  final _XFilterModel xFilterModel;

  String get name => scalar.name;

  // ***************************************************************************
  // ***************************************************************************

  _XScalar({
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
