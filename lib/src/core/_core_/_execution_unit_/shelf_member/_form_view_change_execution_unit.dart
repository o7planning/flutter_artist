part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormViewChangeAnnotation()
class _FormViewChangeExecutionUnit extends _ShelfMemberExecutionUnit {
  XFormModel xFormModel;
  final Map<String, dynamic> formKeyInstantValuesInUI;

  _FormViewChangeExecutionUnit({
    required this.xFormModel,
    required this.formKeyInstantValuesInUI,
  }) : super(executionUnitType: ExecutionUnitType.formModelFormViewChanged);

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
