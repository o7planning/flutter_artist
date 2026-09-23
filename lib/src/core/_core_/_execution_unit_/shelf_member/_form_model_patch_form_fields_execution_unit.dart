part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormModelPatchFormFieldsAnnotation()
class _FormModelPatchFormFieldsExecutionUnit<FORM_INPUT extends FormInput>
    extends _ShelfMemberResultedExecutionUnit {
  final XBlockFormModel xBlockFormModel;

  @override
  final FormModelPatchFormFieldsIntent executionIntent;

  _FormModelPatchFormFieldsExecutionUnit({
    required this.xBlockFormModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelPatchFormFields,
          executionIntent: executionIntent,
        );

  @override
  XShelf get xShelf => xBlockFormModel.xShelf;

  @override
  int get xShelfId => xBlockFormModel.xShelfId;

  @override
  Shelf get shelf => xBlockFormModel.formModel.block.shelf;

  @override
  BlockFormModel get owner => xBlockFormModel.formModel;

  @override
  String getObjectName() {
    return xBlockFormModel.formModel.block.name;
  }
}
