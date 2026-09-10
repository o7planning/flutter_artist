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

  FormModelExecutionIntent? _executionIntent;
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

  FormModelSaveIntent _createAndSetFormModelExecutionIntentSave() {
    final executionIntent = FormModelSaveIntent();
    _formProcessHint = FormProcessHint.force;
    _executionIntent = executionIntent;
    return executionIntent;
  }

  // ***************************************************************************

  FormModelViewChangeIntent _createAndSetFormModelExecutionIntentViewChange({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) {
    final executionIntent = FormModelViewChangeIntent(
      formKeyInstantValuesInUI: formKeyInstantValuesInUI,
    );
    _formProcessHint = FormProcessHint.force;
    _executionIntent = executionIntent;
    return executionIntent;
  }

  // ***************************************************************************

  FormModelDataLoadIntent _createAndSetFormModelExecutionIntentLoad() {
    final executionIntent = FormModelDataLoadIntent();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  // ***************************************************************************

  FormModelPatchFormFieldsIntent
  _createAndSetFormModelExecutionIntentPatchFormFields<
  FORM_INPUT extends FormInput>({
    required FORM_INPUT formInput,
  }) {
    final executionIntent =
    FormModelPatchFormFieldsIntent(formInput: formInput);
    _executionIntent = executionIntent;
    return executionIntent;
  }

  // ***************************************************************************

  FormModelDoneIntent _createAndSetFormModelExecutionIntentDone() {
    final executionIntent = FormModelDoneIntent();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  // ***************************************************************************

  NxtExecutionUnit _getNextExecutionUnit({required bool debug}) {
    final formModelDataState = formModel.dataState;
    final bool visibleX = formModel.ui.hasActiveUiComponent();
    if (_executionIntent == null) {
      // [IN: _executionIntent: null] - dataState: None.
      if (formModelDataState.isNone) {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "FormModel (1.1) (${formModel.block
              .name}), _executionIntent: $_executionIntent, dataState: $formModelDataState. ",
        );
      }
      // [IN: _executionIntent: null] - dataState: Pending.
      else if (formModelDataState.isPending) {
        if (__forceTypeForForm == ForceType.force || visibleX) {
          _createAndSetFormModelExecutionIntentLoad();
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormModelLoadDataExecutionUnit(
              xFormModel: this,
              executionIntent: _executionIntent as FormModelDataLoadIntent,
            ),
            info:
            "FormModel (1.2.1) (${formModel.block
                .name}), _executionIntent: $_executionIntent, dataState: $formModelDataState. "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "FormModel (1.2.2) (${formModel.block
                .name}), _executionIntent: $_executionIntent, dataState: $formModelDataState. "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        }
      }
      // [IN: _executionIntent: null] - dataState: FatalError.
      else if (formModelDataState.isFatalError) {
        if (__forceTypeForForm == ForceType.force || visibleX) {
          _createAndSetFormModelExecutionIntentLoad();
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormModelLoadDataExecutionUnit(
              xFormModel: this,
              executionIntent: _executionIntent as FormModelDataLoadIntent,
            ),
            info:
            "FormModel (1.3.1) (${formModel.block
                .name}), _executionIntent: $_executionIntent, dataState: $formModelDataState. "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "FormModel (1.3.2) (${formModel.block
                .name}), _executionIntent: $_executionIntent, dataState: $formModelDataState. "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        }
      }
      // [IN: _executionIntent: null] - dataState: Stale.
      else if (formModelDataState.isStale) {
        if (__forceTypeForForm == ForceType.force || visibleX) {
          _createAndSetFormModelExecutionIntentLoad();
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormModelLoadDataExecutionUnit(
              xFormModel: this,
              executionIntent: _executionIntent as FormModelDataLoadIntent,
            ),
            info:
            "FormModel (1.4.1) (${formModel.block
                .name}), _executionIntent: $_executionIntent, dataState: $formModelDataState. "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "FormModel (1.4.2) (${formModel.block
                .name}), _executionIntent: $_executionIntent, dataState: $formModelDataState. "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        }
      }
      // [IN: _executionIntent: null] - dataState: Fresh.
      else if (formModelDataState.isFresh) {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "FormModel (1.5.1) (${formModel.block
              .name}), _executionIntent: $_executionIntent, dataState: $formModelDataState. "
              "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
        );
      }
      // [IN: _executionIntent: null] - dataState: OTHERS.
      else {
        throw UnimplementedError("Never Run (XFormModel)");
      }
    }
    //
    // _executionIntent != null.
    //
    final executionIntent = _executionIntent!;
    //
    if (executionIntent is FormModelDoneIntent) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
        "FormModel (2) ${formModel.block
            .name}, _executionIntent: $_executionIntent. "
            "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
      );
    }
    // FormModelDoneIntent
    if (executionIntent is FormModelDoneIntent) {
      throw UnimplementedError("Never run, see above!");
    }
    // FormModelViewChangeIntent
    else if (executionIntent is FormModelViewChangeIntent) {
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit: _FormViewChangeExecutionUnit(
          xFormModel: this,
          executionIntent: executionIntent,
        ),
        info:
        "FormModel (3) ${formModel.block
            .name}, _executionIntent: $_executionIntent. "
            "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
      );
    }
    // FormModelLoadIntent
    else if (executionIntent is FormModelDataLoadIntent) {
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit: _FormModelLoadDataExecutionUnit(
          xFormModel: this,
          executionIntent: executionIntent,
        ),
        info:
        "FormModel (4) ${formModel.block
            .name}, _executionIntent: $_executionIntent. "
            "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
      );
    }
    // FormModelSaveIntent
    else if (executionIntent is FormModelSaveIntent) {
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit: _FormModelSaveFormExecutionUnit(
          xFormModel: this,
          executionIntent: executionIntent,
        ),
        info:
        "FormModel (5) ${formModel.block
            .name}, _executionIntent: $_executionIntent. "
            "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
      );
    }
    return NxtExecutionUnit.no(
      debug: debug,
      info:
      "FormModel (6) ${formModel.block
          .name}, _executionIntent: $_executionIntent, OTHER CASE. "
          "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
    );
  }

  // ***************************************************************************

  void printInfo() {
    print(toString());
  }

  @override
  String toString() {
    return "${getClassName(
        formModel)} - lazy: $lazy - needQuery: $forceTypeForForm";
  }
}
