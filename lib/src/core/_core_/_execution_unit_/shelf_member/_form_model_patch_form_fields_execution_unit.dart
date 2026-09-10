part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormModelPatchFormFieldsAnnotation()
class _FormModelPatchFormFieldsExecutionUnit<FORM_INPUT extends FormInput>
    extends _ShelfMemberResultedExecutionUnit {
  final XFormModel xFormModel;

  @override
  final FormModelPatchFormFieldsIntent executionIntent;

  _FormModelPatchFormFieldsExecutionUnit({
    required this.xFormModel,
    required this.executionIntent,
  }) : super(
    executionUnitType: ExecutionUnitType.formModelPatchFormFields,
    executionIntent: executionIntent,
  );

  @override
  XShelf get xShelf => xFormModel.xShelf;

  @override
  int get xShelfId => xFormModel.xShelfId;

  @override
  Shelf get shelf => xFormModel.formModel.block.shelf;

  @override
  FormModel get owner => xFormModel.formModel;

  @override
  String getObjectName() {
    return xFormModel.formModel.block.name;
  }
}
