part of '../flutter_artist.dart';

class _XBlockForm {
  bool needQuery = false;
  final BlockForm blockForm;
  late final _XBlock xBlock;

  _XBlockForm({
    required this.blockForm,
  });

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(blockForm)} - needQuery: $needQuery)";
  }
}
