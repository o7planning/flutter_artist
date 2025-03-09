part of '../flutter_artist.dart';

class _XFormModel {
  bool forceForm = false; // ForceForm.
  bool queried = false;
  final FormModel formModel;
  final ExtraFormInput? extraFormInput;

  late final _XBlock xBlock;

  _XFormModel({
    required this.formModel,
    required this.extraFormInput,
  });

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(formModel)} - needQuery: $forceForm)";
  }
}
