part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormModelSaveFormAnnotation()
class _FormModelSaveFormExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<BlockFormSaveResult> {
  final XBlockFormModel xBlockFormModel;

  @override
  final FormModelSaveIntent executionIntent;

  _FormModelSaveFormExecutionUnit({
    required this.xBlockFormModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelSaveForm,
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
