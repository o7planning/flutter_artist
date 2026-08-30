part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormModelLoadDataAnnotation()
class _FormModelLoadDataExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<FormModelDataLoadResult> {
  XFormModel xFormModel;

  _FormModelLoadDataExecutionUnit({
    required this.xFormModel,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelLoadData,
          executionUnitResult: FormModelDataLoadResult(),
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
