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
  ForceType __forceTypeForForm = ForceType.decidedAtRuntime;

  ForceType get forceTypeForForm => __forceTypeForForm;
  bool lazy = false;

  ///
  /// IMPORTANT: To create new XFormModel, use 'formModel._createXFormModel' method
  /// to have the same Generics Parameters with the formModel.
  ///
  XFormModel._({
    required this.formModel,
    required this.extraFormInput,
  });

  void setForceType(ForceType forceType) {
    __forceTypeForForm = forceType;
  }

  void printInfo() {
    print(toString());
  }

  @override
  String toString() {
    return "${getClassName(formModel)} - lazy: $lazy - needQuery: $forceTypeForForm";
  }
}
