part of '../core.dart';

class XTaskFormModel<
INIT_DATA extends TaskInitData, //
RESULT_DATA extends TaskResultData> {
  XActivity get xActivity => xTask.xActivity;

  final TaskFormModel formModel;
  late final XTask<INIT_DATA, RESULT_DATA, FormInput, FormOutput> xTask;
  final FormInput? formInput;

  int get xModuleId => xActivity.xModuleId;

  String get name => xTask.name;

  bool loaded = false;
  FormLoadHint _formLoadHint = FormLoadHint.auto;

  FormLoadHint get formLoadHint => _formLoadHint;

  FormModelExecutionIntent? _stashedIntent;

  FormModelExecutionIntent? _executionIntent;

  ///
  /// IMPORTANT: To create new XTaskFormModel, use 'formModel._createXTaskFormModel' method
  /// to have the same Generics Parameters with the formModel.
  ///
  XTaskFormModel._({
    required this.formModel,
    required this.formInput,
  });

  void setForceType(FormLoadHint forceType) {
    _formLoadHint = forceType;
  }

  void setForceTypeIfLessThan(FormLoadHint forceType) {
    if (_formLoadHint.lessThan(forceType)) {
      _formLoadHint = forceType;
    }
  }

  // ***************************************************************************

  FormModelViewChangeIntent _createAndSetFormModelExecutionIntentViewChange({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) {
    final executionIntent = FormModelViewChangeIntent(
      formKeyInstantValuesInUI: formKeyInstantValuesInUI,
    );
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
    // 1. Restore the stashed intent if the current intent is empty
    if (_executionIntent == null && _stashedIntent != null) {
      _executionIntent = _stashedIntent;
      _stashedIntent = null;
    }

    final input = TaskFormNextUnitInput(
      dataState: formModel.dataState,
      currentIntent: _executionIntent,
      formLoadHint: _formLoadHint,
      isVisible: formModel.ui.hasVisibleViews(),
      isTaskStateReady: formModel.task.isStateReadyForForm(),
      taskDataState: formModel.task.dataState,
      taskName: formModel.task.name,
    );

    final output = TaskFormExecutionCalculator.calculate(input);

    // 2. Preserve the old Intent if it gets displaced
    if (output.preserveCurrentIntent) {
      _stashedIntent = _executionIntent;
    }

    String finalDebugInfo = output.debugInfo;

    // 3. Handling Side-effects: Pump Missing Intent (Load)
    if (output.missingIntent == MissingIntentType.dataLoadOrQuery) {
      final intentToUse = _createAndSetFormModelExecutionIntentLoad();
      finalDebugInfo = finalDebugInfo.replaceFirst(
          "_executionIntent: $_stashedIntent",
          "_executionIntent: $_stashedIntent --> $intentToUse");
    }

    // 4. Return to Execution Unit
    switch (output.action) {
      case TaskFormExecutionAction.loadData:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _TaskFormModelLoadDataExecutionUnit(
            xTaskFormModel: this,
            executionIntent: _executionIntent as FormModelDataLoadIntent,
          ),
          info: finalDebugInfo,
        );
      case TaskFormExecutionAction.viewChange:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _TaskFormViewChangeExecutionUnit(
            xTaskFormModel: this,
            executionIntent: _executionIntent as FormModelViewChangeIntent,
          ),
          info: finalDebugInfo,
        );
      case TaskFormExecutionAction.patchFormFields:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _TaskFormModelPatchFormFieldsExecutionUnit(
            xTaskFormModel: this,
            executionIntent: _executionIntent as FormModelPatchFormFieldsIntent,
          ),
          info: finalDebugInfo,
        );
      case TaskFormExecutionAction.none:
      default:
        return NxtExecutionUnit.no(
          debug: debug,
          info: finalDebugInfo,
        );
    }
  }

  // ***************************************************************************

  void printInfo() {
    print(toString());
  }

  @override
  String toString() {
    return "${getClassName(formModel)} - formLoadHint: $formLoadHint";
  }
}
