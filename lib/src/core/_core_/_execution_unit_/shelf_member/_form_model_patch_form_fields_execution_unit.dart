part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormModelPatchFormFieldsAnnotation()
class _FormModelPatchFormFieldsExecutionUnit<FORM_INPUT extends FormInput>
    extends _ShelfMemberResultedExecutionUnit {
  XFormModel xFormModel;
  FORM_INPUT formInput;

  _FormModelPatchFormFieldsExecutionUnit({
    required this.xFormModel,
    required this.formInput,
    required FormModelPatchFormFieldsResult super.executionUnitResult,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelPatchFormFields,
        );

  @override
  BlockTodo? get executionTodo => null;


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
