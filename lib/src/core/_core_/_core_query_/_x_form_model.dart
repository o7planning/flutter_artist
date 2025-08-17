part of '../core.dart';

class _XFormModel {
  _XShelf get xShelf => xBlock.xShelf;

  final FormModel formModel;
  late final _XBlock xBlock;
  final ExtraFormInput? extraFormInput;

  int get xShelfId => xShelf.xShelfId;

  String get name => xBlock.name;

  //
  bool queried = false;
  ForceType forceTypeForForm = ForceType.decidedAtRuntime;
  bool lazy = false;

  _XFormModel({
    required this.formModel,
    required this.extraFormInput,
  });

  void printInfo() {
    print(toString());
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(formModel)} - lazy: $lazy - needQuery: $forceTypeForForm)";
  }
}
