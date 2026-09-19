part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormModelLoadDataAnnotation()
class _FormModelLoadDataExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<FormModelDataLoadResult> {
  final XFormModel xFormModel;

  @override
  final FormModelDataLoadIntent executionIntent;

  _FormModelLoadDataExecutionUnit({
    required this.xFormModel,
    required this.executionIntent,
  }) : super(
    executionUnitType: ExecutionUnitType.formModelLoadData,
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
