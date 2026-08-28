part of '../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormModelSaveFormAnnotation()
class _FormModelSaveFormExecutionUnit extends _ResultedSExecutionUnit<FormSaveResult> {
  XFormModel xFormModel;

  _FormModelSaveFormExecutionUnit({
    required this.xFormModel,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelSaveForm,
          taskResult: FormSaveResult(precheck: null),
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
