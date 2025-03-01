part of '../flutter_artist.dart';

class _XBlockForm {
  bool needQuery = false; // ForceForm.
  bool queried = false;
  final BlockForm blockForm;
  final ExtraFormInput? extraFormInput;

  late final _XBlock xBlock;

  _XBlockForm({
    required this.blockForm,
    required this.extraFormInput,
  });

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(blockForm)} - needQuery: $needQuery)";
  }
}
