part of '../core.dart';

class _QFormModel {
  _QShelf get xShelf => xBlock.xShelf;

  final FormModel formModel;
  late final _QBlock xBlock;
  final ExtraFormInput? extraFormInput;

  int get xShelfId => xShelf.xShelfId;

  String get name => xBlock.name;

  //
  bool queried = false;
  ForceType forceTypeForForm = ForceType.decidedAtRuntime;
  bool lazy = false;

  _QFormModel({
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
