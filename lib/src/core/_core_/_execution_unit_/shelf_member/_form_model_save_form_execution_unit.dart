part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_FormModelSaveFormAnnotation()
class _FormModelSaveFormExecutionUnit
    extends _ShelfMemberResultedExecutionUnit<FormSaveResult> {
  final XFormModel xFormModel;

  @override
  final FormModelTodoSave executionTodo;

  _FormModelSaveFormExecutionUnit({
    required this.xFormModel,
    required this.executionTodo,
  }) : super(
          executionUnitType: ExecutionUnitType.formModelSaveForm,
          executionUnitResult: FormSaveResult(precheck: null),
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
