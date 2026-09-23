part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormModelLoadDataAnnotation()
class _FormModelLoadDataExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<FormModelDataLoadResult> {
  final XBlockFormModel xBlockFormModel;

  @override
  final FormModelDataLoadIntent executionIntent;

  _FormModelLoadDataExecutionUnit({
    required this.xBlockFormModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelLoadData,
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
