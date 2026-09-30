part of '../core.dart';

class XTaskFormModel<
    INIT_DATA extends TaskInitData, //
    RESULT_DATA extends TaskResultData> {
  XActivity get xActivity => xTask.xActivity;

  final TaskFormModel formModel;
  late final XTask<INIT_DATA, RESULT_DATA, CreationPreset, FormInput> xTask;
  final FormInput? formInput;

  int get xActivityId => xActivity.xActivityId;

  String get name => xTask.name;

  bool loaded = false;
  FormLoadHint _formLoadHint = FormLoadHint.auto;

  FormLoadHint get formLoadHint => _formLoadHint;

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
            "TaskFormModel (0.0), (${formModel.task.name}), _executionIntent: $executionIntent, "
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
            "TaskFormModel (1.1), (${formModel.task.name}), _executionIntent: $executionIntent, "
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
          executionUnit: _TaskFormModelLoadDataExecutionUnit(
            xTaskFormModel: this,
            executionIntent: executionIntent,
          ),
          info:
              "TaskFormModel (2.1), (${formModel.task.name}), _executionIntent: $executionIntent, "
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
          executionUnit: _TaskFormModelLoadDataExecutionUnit(
            xTaskFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "TaskFormModel (2.2.1), (${formModel.task.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "formDataState: ${formModelDataState.toBriefInfo()}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "TaskFormModel (2.2.2), (${formModel.task.name}), _executionIntent: $executionIntent, "
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
          executionUnit: _TaskFormModelLoadDataExecutionUnit(
            xTaskFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "TaskFormModel (3.1.1), (${formModel.task.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "formDataState: ${formModelDataState.toBriefInfo()}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "TaskFormModel (3.1.2), (${formModel.task.name}), _executionIntent: $executionIntent, "
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
          executionUnit: _TaskFormModelLoadDataExecutionUnit(
            xTaskFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "TaskFormModel (4.1.1), (${formModel.task.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "formDataState: ${formModelDataState.toBriefInfo()}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "TaskFormModel (4.1.2), (${formModel.task.name}), _executionIntent: $executionIntent, "
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
          executionUnit: _TaskFormModelLoadDataExecutionUnit(
            xTaskFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "TaskFormModel (5.1.2), (${formModel.task.name}), _executionIntent: $executionIntent --> $intentToUse, "
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
            executionUnit: _TaskFormViewChangeExecutionUnit(
              xTaskFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "TaskFormModel (5.2.2), (${formModel.task.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}",
          );
        } else if (executionIntent is FormModelDataLoadIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _TaskFormModelLoadDataExecutionUnit(
              xTaskFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "TaskFormModel (5.2.3), (${formModel.task.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}",
          );
        } else if (executionIntent is FormModelPatchFormFieldsIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _TaskFormModelPatchFormFieldsExecutionUnit(
              xTaskFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "TaskFormModel (5.2.4), (${formModel.task.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "TaskFormModel (5.2.4), (${formModel.task.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}",
          );
        }
      }

      // IN: DATA STATE = FRESH
      // 5.3. Idle state when form data is fresh and no active intent is present
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "TaskFormModel (5.3), (${formModel.task.name}), _executionIntent: null, "
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
          "TaskFormModel (6.1) (${formModel.task.name}), _executionIntent: $executionIntent, "
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
