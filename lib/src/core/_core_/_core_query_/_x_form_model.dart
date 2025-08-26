part of '../core.dart';

class XFormModel<
    ID extends Object, //
    ITEM_DETAIL extends Object> {
  XShelf get xShelf => xBlock.xShelf;

  final FormModel formModel;
  late final XBlock<ID, Object, ITEM_DETAIL> xBlock;
  final ExtraFormInput? extraFormInput;

  int get xShelfId => xShelf.xShelfId;

  String get name => xBlock.name;

  //
  bool queried = false;
  ForceType forceTypeForForm = ForceType.decidedAtRuntime;
  bool lazy = false;

  XFormModel({
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
