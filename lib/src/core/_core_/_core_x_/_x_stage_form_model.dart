part of '../core.dart';

class XStageFormModel<
STAGE_ENUM extends StageEnum,
INIT_DATA extends StageInitData,
RESULT_DATA extends StageResultData,
PROZESS_CONTEXT_DATA extends ProzessContextData,
FORM_INPUT extends FormInput,
FORM_OUTPUT extends FormOutput> {
  XActivity get xActivity => xStage.xProzess.xActivity;

  final StageFormModel formModel;
  late final XStage<StageEnum,
      INIT_DATA,
      RESULT_DATA,
      ProzessContextData,
      FORM_INPUT,
      FORM_OUTPUT> xStage;

  final FormInput? formInput;

  int get xModuleId => xActivity.xModuleId;

  String get name => xStage.name;

  bool loaded = false;
  FormLoadHint _formLoadHint = FormLoadHint.auto;

  FormLoadHint get formLoadHint => _formLoadHint;

  FormModelExecutionIntent? _stashedIntent;

  FormModelExecutionIntent? _executionIntent;

  ///
  /// IMPORTANT: To create new XStageFormModel, use 'formModel._createXStageFormModel' method
  /// to have the same Generics Parameters with the formModel.
  ///
  XStageFormModel._({
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
    // 1. Restore the stashed intent if the current intent is null
    if (_executionIntent == null && _stashedIntent != null) {
      _executionIntent = _stashedIntent;
      _stashedIntent = null;
    }

    final input = StageFormNextUnitInput(
      dataState: formModel.dataState,
      currentIntent: _executionIntent,
      formLoadHint: _formLoadHint,
      isVisible: formModel.ui.hasVisibleViews(),
      stageName: formModel.stage.name,
    );

    final output = StageFormExecutionCalculator.calculate(input);

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
      case StageFormExecutionAction.loadData:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageFormModelLoadDataExecutionUnit(
            xStageFormModel: this,
            executionIntent: _executionIntent as FormModelDataLoadIntent,
          ),
          info: finalDebugInfo,
        );
      case StageFormExecutionAction.viewChange:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageFormViewChangeExecutionUnit(
            xStageFormModel: this,
            executionIntent: _executionIntent as FormModelViewChangeIntent,
          ),
          info: finalDebugInfo,
        );
      case StageFormExecutionAction.patchFormFields:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageFormModelPatchFormFieldsExecutionUnit(
            xStageFormModel: this,
            executionIntent: _executionIntent as FormModelPatchFormFieldsIntent,
          ),
          info: finalDebugInfo,
        );
      case StageFormExecutionAction.none:
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
