part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormViewChangeAnnotation()
class _FormViewChangeExecutionUnit extends _ShelfMemberExecutionUnit {
  XFormModel xFormModel;

  @override
  final FormModelViewChangeIntent executionIntent;

  _FormViewChangeExecutionUnit({
    required this.xFormModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelFormViewChanged,
          executionIntent: executionIntent,
        );

  @override
  XShelf get xShelf => xFormModel.xShelf;

  @override
  int get xShelfId => xFormModel.xShelfId;

  @override
  Shelf get shelf => xFormModel.formModel.shelf;

  @override
  FormModel get owner => xFormModel.formModel;

  @override
  String getObjectName() {
    return xFormModel.formModel.block.name;
  }
}
