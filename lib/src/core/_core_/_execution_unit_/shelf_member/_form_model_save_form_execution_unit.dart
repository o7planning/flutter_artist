part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormModelSaveFormAnnotation()
class _FormModelSaveFormExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<BlockFormSaveResult> {
  final XFormModel xFormModel;

  @override
  final FormModelSaveIntent executionIntent;

  _FormModelSaveFormExecutionUnit({
    required this.xFormModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelSaveForm,
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
