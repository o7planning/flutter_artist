part of '../flutter_artist.dart';

class _XBlockForm {
  bool needQuery = false;
  bool queried = false;
  final BlockForm blockForm;
  final SuggestedFormData? suggestedFormData;

  late final _XBlock xBlock;

  _XBlockForm({
    required this.blockForm,
    required this.suggestedFormData,
  });

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(blockForm)} - needQuery: $needQuery)";
  }
}
