part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormViewChangeAnnotation()
class _FormViewChangeExecutionUnit extends _ShelfMemberExecutionUnit {
  XBlockFormModel xBlockFormModel;

  @override
  final FormModelViewChangeIntent executionIntent;

  _FormViewChangeExecutionUnit({
    required this.xBlockFormModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelFormViewChanged,
          executionIntent: executionIntent,
        );

  @override
  XShelf get xShelf => xBlockFormModel.xShelf;

  @override
  int get xShelfId => xBlockFormModel.xShelfId;

  @override
  Shelf get shelf => xBlockFormModel.formModel.shelf;

  @override
  BlockFormModel get owner => xBlockFormModel.formModel;

  @override
  String getObjectName() {
    return xBlockFormModel.formModel.block.name;
  }
}
