part of '../flutter_artist.dart';

class _XScalar {
  bool __forceQuery = false;
  bool affectByFilterInput = false;
  final Scalar scalar;
  final _XDataFilter xDataFilter;

  _XScalar({
    required this.scalar,
    required this.xDataFilter,
  });

  String get name => scalar.name;

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
