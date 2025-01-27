part of '../flutter_artist.dart';

class _XScalar {
  bool _suggestedQuery = false;
  final Scalar scalar;
  final _XDataFilter xDataFilter;

  _XScalar({
    required this.scalar,
    required this.xDataFilter,
  });

  String get name => scalar.name;

  bool get needQuery {
    return _suggestedQuery;
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(scalar)} - needQuery: $needQuery)";
  }
}
