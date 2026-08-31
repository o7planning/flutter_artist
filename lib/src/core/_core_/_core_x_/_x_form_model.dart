part of '../core.dart';

class XFormModel<
    ID extends Comparable, //
    ITEM_DETAIL extends Identifiable<ID>> {
  XShelf get xShelf => xBlock.xShelf;

  final FormModel formModel;
  late final XBlock<ID, Identifiable<ID>, ITEM_DETAIL> xBlock;
  final FormInput? formInput;

  int get xShelfId => xShelf.xShelfId;

  String get name => xBlock.name;

  //
  bool queried = false;
  ForceType __forceTypeForForm = ForceType.decidedAtRuntime;

  ForceType get forceTypeForForm => __forceTypeForForm;
  bool lazy = false;

  FormModelTodo? _formModelTodo;
  FormProcessHint _formProcessHint = FormProcessHint.auto;

  ///
  /// IMPORTANT: To create new XFormModel, use 'formModel._createXFormModel' method
  /// to have the same Generics Parameters with the formModel.
  ///
  XFormModel._({
    required this.formModel,
    required this.formInput,
  });

  void setForceType(ForceType forceType) {
    __forceTypeForForm = forceType;
  }

  // ***************************************************************************

  FormModelTodoSave _createAndSetFormModelTodoSave() {
    final formModelTodo = FormModelTodoSave();
    _formProcessHint = FormProcessHint.force;
    _formModelTodo = formModelTodo;
    return formModelTodo;
  }

  // ***************************************************************************

  FormModelTodoViewChange _createAndSetFormModelTodoViewChange({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) {
    final formModelTodo = FormModelTodoViewChange(
      formKeyInstantValuesInUI: formKeyInstantValuesInUI,
    );
    _formProcessHint = FormProcessHint.force;
    _formModelTodo = formModelTodo;
    return formModelTodo;
  }

  // ***************************************************************************

  FormModelTodoLoad _createAndSetFormModelTodoLoad() {
    final formModelTodo = FormModelTodoLoad();
    _formModelTodo = formModelTodo;

    print(
        "~~~~~~~~~~~ XFormModel._createAndSetFormModelTodoLoad _formModelTodo: $_formModelTodo");
    return formModelTodo;
  }

  // ***************************************************************************

  FormModelTodoDone _createAndSetFormModelTodoDone() {
    final formModelTodo = FormModelTodoDone();
    _formModelTodo = formModelTodo;
    return formModelTodo;
  }

  // ***************************************************************************

  NextExecutionUnit _getNextExecutionUnit({required bool debug}) {
    final formModelDataState = formModel.dataState;
    final bool visibleX = formModel.ui.hasActiveUiComponent();
    if (_formModelTodo == null) {
      // [IN: _formModelTodo: null] - dataState: None.
      if (formModelDataState.isNone) {
        return NextExecutionUnit.no(
          debug: debug,
          info:
              "FormModel (1.1) (${formModel.block.name}), _formModelTodo: $_formModelTodo, dataState: $formModelDataState. ",
        );
      }
      // [IN: _formModelTodo: null] - dataState: Pending.
      else if (formModelDataState.isPending) {
        if (__forceTypeForForm == ForceType.force || visibleX) {
          _createAndSetFormModelTodoLoad();
          return NextExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormModelLoadDataExecutionUnit(
              xFormModel: this,
              executionTodo: _formModelTodo as FormModelTodoLoad,
            ),
            info:
                "FormModel (1.2.1) (${formModel.block.name}), _formModelTodo: $_formModelTodo, dataState: $formModelDataState. "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        } else {
          return NextExecutionUnit.no(
            debug: debug,
            info:
                "FormModel (1.2.2) (${formModel.block.name}), _formModelTodo: $_formModelTodo, dataState: $formModelDataState. "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        }
      }
      // [IN: _formModelTodo: null] - dataState: FatalError.
      else if (formModelDataState.isFatalError) {
        if (__forceTypeForForm == ForceType.force || visibleX) {
          _createAndSetFormModelTodoLoad();
          return NextExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormModelLoadDataExecutionUnit(
              xFormModel: this,
              executionTodo: _formModelTodo as FormModelTodoLoad,
            ),
            info:
                "FormModel (1.3.1) (${formModel.block.name}), _formModelTodo: $_formModelTodo, dataState: $formModelDataState. "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        } else {
          return NextExecutionUnit.no(
            debug: debug,
            info:
                "FormModel (1.3.2) (${formModel.block.name}), _formModelTodo: $_formModelTodo, dataState: $formModelDataState. "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        }
      }
      // [IN: _formModelTodo: null] - dataState: Stale.
      else if (formModelDataState.isStale) {
        if (__forceTypeForForm == ForceType.force || visibleX) {
          _createAndSetFormModelTodoLoad();
          return NextExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormModelLoadDataExecutionUnit(
              xFormModel: this,
              executionTodo: _formModelTodo as FormModelTodoLoad,
            ),
            info:
                "FormModel (1.4.1) (${formModel.block.name}), _formModelTodo: $_formModelTodo, dataState: $formModelDataState. "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        } else {
          return NextExecutionUnit.no(
            debug: debug,
            info:
                "FormModel (1.4.2) (${formModel.block.name}), _formModelTodo: $_formModelTodo, dataState: $formModelDataState. "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        }
      }
      // [IN: _formModelTodo: null] - dataState: Fresh.
      else if (formModelDataState.isFresh) {
        return NextExecutionUnit.no(
          debug: debug,
          info:
              "FormModel (1.5.1) (${formModel.block.name}), _formModelTodo: $_formModelTodo, dataState: $formModelDataState. "
              "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
        );
      }
      // [IN: _formModelTodo: null] - dataState: OTHERS.
      else {
        throw UnimplementedError("Never Run (XFormModel)");
      }
    }
    //
    // _formModelTodo != null.
    //
    final formModelTodo = _formModelTodo!;
    //
    if (formModelTodo is FormModelTodoDone) {
      return NextExecutionUnit.no(
        debug: debug,
        info:
            "FormModel (2) ${formModel.block.name}, _formModelTodo: $_formModelTodo. "
            "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
      );
    }
    // FormModelTodoDone
    if (formModelTodo is FormModelTodoDone) {
      throw UnimplementedError("Never run, see above!");
    }
    // FormModelTodoViewChange
    else if (formModelTodo is FormModelTodoViewChange) {
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit: _FormViewChangeExecutionUnit(
          xFormModel: this,
          executionTodo: formModelTodo,
        ),
        info:
            "FormModel (3) ${formModel.block.name}, _formModelTodo: $_formModelTodo. "
            "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
      );
    }
    // FormModelTodoLoad
    else if (formModelTodo is FormModelTodoLoad) {
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit: _FormModelLoadDataExecutionUnit(
          xFormModel: this,
          executionTodo: formModelTodo,
        ),
        info:
            "FormModel (4) ${formModel.block.name}, _formModelTodo: $_formModelTodo. "
            "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
      );
    }
    // FormModelTodoSave
    else if (formModelTodo is FormModelTodoSave) {
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit: _FormModelSaveFormExecutionUnit(
          xFormModel: this,
          executionTodo: formModelTodo,
        ),
        info:
            "FormModel (5) ${formModel.block.name}, _formModelTodo: $_formModelTodo. "
            "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
      );
    }
    return NextExecutionUnit.no(
      debug: debug,
      info:
          "FormModel (6) ${formModel.block.name}, _formModelTodo: $_formModelTodo, OTHER CASE. "
          "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
    );
  }

  // ***************************************************************************

  void printInfo() {
    print(toString());
  }

  @override
  String toString() {
    return "${getClassName(formModel)} - lazy: $lazy - needQuery: $forceTypeForForm";
  }
}
