part of '../core.dart';

class XBlockFormModel<
    ID extends Comparable, //
    ITEM_DETAIL extends Identifiable<ID>> {
  XShelf get xShelf => xBlockCurrentItemModel.xBlock.xShelf;

  final BlockFormModel formModel;
  late final XBlockCurrentItemModel<ID, Identifiable<ID>, ITEM_DETAIL>
      xBlockCurrentItemModel;
  final FormInput? formInput;

  int get xModuleId => xShelf.xModuleId;

  String get name => xBlockCurrentItemModel.xBlock.name;

  //
  bool loaded = false;

  FormLoadHint _formLoadHint = FormLoadHint.auto;

  FormLoadHint get formLoadHint => _formLoadHint;

  FormModelExecutionIntent? _stashedIntent;

  FormModelExecutionIntent? _executionIntent;



  ///
  /// IMPORTANT: To create new XBlockFormModel, use 'formModel._createXBlockFormModel' method
  /// to have the same Generics Parameters with the formModel.
  ///
  XBlockFormModel._({
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

  FormModelSaveIntent _createAndSetFormModelExecutionIntentSave() {
    final executionIntent = FormModelSaveIntent();
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
    // 1. Restore the stashed intent if the current intent is null.
    if (_executionIntent == null && _stashedIntent != null) {
      _executionIntent = _stashedIntent;
      _stashedIntent = null;
    }

    final input = BlockFormNextUnitInput(
      dataState: formModel.dataState,
      currentIntent: _executionIntent,
      formLoadHint: _formLoadHint,
      isVisible: formModel.ui.hasVisibleViews(),
      formMode: formModel.formMode,
      blockName: formModel.block.name,
    );

    final output = BlockFormExecutionCalculator.calculate(input);

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
      case BlockFormExecutionAction.loadData:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockFormModelLoadDataExecutionUnit(
            xBlockFormModel: this,
            executionIntent: _executionIntent as FormModelDataLoadIntent,
          ),
          info: finalDebugInfo,
        );
      case BlockFormExecutionAction.viewChange:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockFormViewChangeExecutionUnit(
            xBlockFormModel: this,
            executionIntent: _executionIntent as FormModelViewChangeIntent,
          ),
          info: finalDebugInfo,
        );
      case BlockFormExecutionAction.save:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _FormModelSaveFormExecutionUnit(
            xBlockFormModel: this,
            executionIntent: _executionIntent as FormModelSaveIntent,
          ),
          info: finalDebugInfo,
        );
      case BlockFormExecutionAction.patchFormFields:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _BlockFormModelPatchFormFieldsExecutionUnit(
            xBlockFormModel: this,
            executionIntent: _executionIntent as FormModelPatchFormFieldsIntent,
          ),
          info: finalDebugInfo,
        );
      case BlockFormExecutionAction.none:
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
