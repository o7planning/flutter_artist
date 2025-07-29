part of '../_fa_core.dart';

class _XFormModel {
  final _XShelf xShelf;
  ForceType forceTypeForForm = ForceType.decidedAtRuntime;
  bool queried = false;
  final FormModel formModel;
  final ExtraFormInput? extraFormInput;

  late final _XBlock xBlock;

  int get xShelfId => xShelf.xShelfId;

  _XFormModel({
    required this.xShelf,
    required this.formModel,
    required this.extraFormInput,
  });

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(formModel)} - needQuery: $forceTypeForForm)";
  }
}
