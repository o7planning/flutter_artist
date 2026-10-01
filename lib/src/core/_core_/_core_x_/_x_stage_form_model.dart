part of '../core.dart';

class XStageFormModel<
    STAGE_ENUM extends Enum,
    INIT_DATA extends StageInitData,
    RESULT_DATA extends StageResultData,
    PROZESS_CONTEXT_DATA extends ProzessContextData,
    FORM_INPUT extends FormInput> {
  XActivity get xActivity => xStage.xProzess.xActivity;

  final StageFormModel formModel;
  late final XStage<
      Enum, // STAGE_ENUM
      INIT_DATA,
      RESULT_DATA,
      ProzessContextData,
      FormInput> xStage;

  final FormInput? formInput;

  int get xModuleId => xActivity.xModuleId;

  String get name => xStage.name;

  bool loaded = false;
  FormLoadHint _formLoadHint = FormLoadHint.auto;

  FormLoadHint get formLoadHint => _formLoadHint;

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
    final formModelDataState = formModel.dataState;
    final bool visibleX = formModel.ui.hasVisibleViews();
    final executionIntent = _executionIntent;

    // =========================================================================
    // 0. TERMINAL INTENT INTERCEPTOR
    // =========================================================================
    if (executionIntent is FormModelDoneIntent) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "StageFormModel (0.0), (${formModel.stage.name}), _executionIntent: $executionIntent, "
            "formDataState: ${formModelDataState.toBriefInfo()}",
      );
    }

    // =========================================================================
    // 1. DATA STATE = NONE
    // =========================================================================
    if (formModelDataState.isNone) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "StageFormModel (1.1), (${formModel.stage.name}), _executionIntent: $executionIntent, "
            "formDataState: ${formModelDataState.toBriefInfo()}",
      );
    }

    // =========================================================================
    // 2. DATA STATE = PENDING
    // =========================================================================
    else if (formModelDataState.isPending) {
      if (executionIntent is FormModelDataLoadIntent) {
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageFormModelLoadDataExecutionUnit(
            xStageFormModel: this,
            executionIntent: executionIntent,
          ),
          info:
              "StageFormModel (2.1), (${formModel.stage.name}), _executionIntent: $executionIntent, "
              "formDataState: ${formModelDataState.toBriefInfo()}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      }
      final bool shouldLoad = (_formLoadHint == FormLoadHint.force || visibleX);

      if (shouldLoad) {
        // Enforce FormModelDataLoadIntent to populate form fields before allowing mutations
        final FormModelDataLoadIntent intentToUse;
        if (executionIntent is FormModelDataLoadIntent) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetFormModelExecutionIntentLoad();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageFormModelLoadDataExecutionUnit(
            xStageFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "StageFormModel (2.2.1), (${formModel.stage.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "formDataState: ${formModelDataState.toBriefInfo()}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "StageFormModel (2.2.2), (${formModel.stage.name}), _executionIntent: $executionIntent, "
              "formDataState: ${formModelDataState.toBriefInfo()}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = STALE
    // =========================================================================
    else if (formModelDataState.isStale) {
      final bool shouldLoad = (_formLoadHint == FormLoadHint.force || visibleX);

      if (shouldLoad) {
        // Enforce FormModelDataLoadIntent to refresh form fields
        final FormModelDataLoadIntent intentToUse;
        if (executionIntent is FormModelDataLoadIntent) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetFormModelExecutionIntentLoad();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageFormModelLoadDataExecutionUnit(
            xStageFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "StageFormModel (3.1.1), (${formModel.stage.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "formDataState: ${formModelDataState.toBriefInfo()}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "StageFormModel (3.1.2), (${formModel.stage.name}), _executionIntent: $executionIntent, "
              "formDataState: ${formModelDataState.toBriefInfo()}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      }
    }

    // =========================================================================
    // 4. DATA STATE = FATAL ERROR
    // =========================================================================
    else if (formModelDataState.isFatalError) {
      final bool shouldLoad = (_formLoadHint == FormLoadHint.force || visibleX);

      if (shouldLoad) {
        final FormModelDataLoadIntent intentToUse;
        if (executionIntent is FormModelDataLoadIntent) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetFormModelExecutionIntentLoad();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageFormModelLoadDataExecutionUnit(
            xStageFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "StageFormModel (4.1.1), (${formModel.stage.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "formDataState: ${formModelDataState.toBriefInfo()}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "StageFormModel (4.1.2), (${formModel.stage.name}), _executionIntent: $executionIntent, "
              "formDataState: ${formModelDataState.toBriefInfo()}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      }
    }

    // =========================================================================
    // 5. DATA STATE = FRESH
    // =========================================================================
    else if (formModelDataState.isFresh) {
      // 5.1. Force reload explicitly requested from form configuration
      if (_formLoadHint == FormLoadHint.force) {
        final FormModelDataLoadIntent intentToUse;
        if (executionIntent is FormModelDataLoadIntent) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetFormModelExecutionIntentLoad();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageFormModelLoadDataExecutionUnit(
            xStageFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "StageFormModel (5.1.2), (${formModel.stage.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "formDataState: ${formModelDataState.toBriefInfo()}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      }

      // IN: DATA STATE = FRESH
      // 5.2. Handle active execution intents
      if (executionIntent != null) {
        if (executionIntent is FormModelViewChangeIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _StageFormViewChangeExecutionUnit(
              xStageFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "StageFormModel (5.2.2), (${formModel.stage.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}",
          );
        } else if (executionIntent is FormModelDataLoadIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _StageFormModelLoadDataExecutionUnit(
              xStageFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "StageFormModel (5.2.3), (${formModel.stage.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}",
          );
        } else if (executionIntent is FormModelPatchFormFieldsIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _StageFormModelPatchFormFieldsExecutionUnit(
              xStageFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "StageFormModel (5.2.4), (${formModel.stage.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "StageFormModel (5.2.4), (${formModel.stage.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}",
          );
        }
      }

      // IN: DATA STATE = FRESH
      // 5.3. Idle state when form data is fresh and no active intent is present
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "StageFormModel (5.3), (${formModel.stage.name}), _executionIntent: null, "
            "formDataState: ${formModelDataState.toBriefInfo()}, "
            "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
      );
    }

    // =========================================================================
    // 6. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return NxtExecutionUnit.no(
      debug: debug,
      info:
          "StageFormModel (6.1) (${formModel.stage.name}), _executionIntent: $executionIntent, "
          "formDataState: ${formModelDataState.toBriefInfo()}",
    );
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
