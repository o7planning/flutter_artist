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
  FormForceType __forceTypeForForm = FormForceType.auto;

  FormForceType get forceTypeForForm => __forceTypeForForm;

  FormModelExecutionIntent? _executionIntent;

  ///
  /// IMPORTANT: To create new XFormModel, use 'formModel._createXFormModel' method
  /// to have the same Generics Parameters with the formModel.
  ///
  XFormModel._({
    required this.formModel,
    required this.formInput,
  });

  void setForceType(FormForceType forceType) {
    __forceTypeForForm = forceType;
  }

  void setForceTypeIfLessThan(FormForceType forceType) {
    if (__forceTypeForForm.lessThan(forceType)) {
      __forceTypeForForm = forceType;
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
    final formModelDataState = formModel.dataState;
    final bool visibleX = formModel.ui.hasActiveUiComponent();
    final executionIntent = _executionIntent;

    // =========================================================================
    // 0. TERMINAL INTENT INTERCEPTOR
    // =========================================================================
    if (executionIntent is FormModelDoneIntent) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "FormModel (Done), (${formModel.block.name}), _executionIntent: $executionIntent, "
            "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
      );
    }

    // =========================================================================
    // 1. DATA STATE = NONE
    // =========================================================================
    if (formModelDataState.isNone) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "FormModel (1.1) (${formModel.block.name}), _executionIntent: $executionIntent, "
            "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
      );
    }

    // =========================================================================
    // 2. DATA STATE = PENDING
    // =========================================================================
    else if (formModelDataState.isPending) {
      if (executionIntent is FormModelDataLoadIntent) {
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _FormModelLoadDataExecutionUnit(
            xFormModel: this,
            executionIntent: executionIntent,
          ),
          info:
              "FormModel (2.1) (${formModel.block.name}), _executionIntent: $executionIntent, "
              "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
              "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
        );
      }
      final bool shouldLoad =
          (__forceTypeForForm == FormForceType.force || visibleX);

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
          executionUnit: _FormModelLoadDataExecutionUnit(
            xFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "FormModel (2.2.1) (${formModel.block.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
              "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "FormModel (2.2.2) (${formModel.block.name}), _executionIntent: $executionIntent, "
              "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
              "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = STALE
    // =========================================================================
    else if (formModelDataState.isStale) {
      final bool shouldLoad =
          (__forceTypeForForm == FormForceType.force || visibleX);

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
          executionUnit: _FormModelLoadDataExecutionUnit(
            xFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "FormModel 3.1.1 (${formModel.block.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
              "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "FormModel 3.1.2 (${formModel.block.name}), _executionIntent: $executionIntent, "
              "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
              "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
        );
      }
    }

    // =========================================================================
    // 4. DATA STATE = FATAL ERROR
    // =========================================================================
    else if (formModelDataState.isFatalError) {
      final bool shouldLoad =
          (__forceTypeForForm == FormForceType.force || visibleX);

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
          executionUnit: _FormModelLoadDataExecutionUnit(
            xFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "FormModel 4.1.1 (${formModel.block.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
              "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "FormModel 4.1.2 (${formModel.block.name}), _executionIntent: $executionIntent, "
              "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
              "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
        );
      }
    }

    // =========================================================================
    // 5. DATA STATE = FRESH
    // =========================================================================
    else if (formModelDataState.isFresh) {
      // 5.1. Force reload explicitly requested from form configuration
      if (__forceTypeForForm == FormForceType.force) {
        if (formModel.formMode == FormMode.creation) {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "FormModel (5.1.1) (${formModel.block.name}), _executionIntent: $executionIntent, "
                "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
                "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
          );
        }
        final FormModelDataLoadIntent intentToUse;
        if (executionIntent is FormModelDataLoadIntent) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetFormModelExecutionIntentLoad();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _FormModelLoadDataExecutionUnit(
            xFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "FormModel (5.1.2) (${formModel.block.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
              "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
        );
      }

      // 5.2. Handle active execution intents
      if (executionIntent != null) {
        if (executionIntent is FormModelViewChangeIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormViewChangeExecutionUnit(
              xFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "FormModel (5.2.2) (${formModel.block.name}), _executionIntent: $executionIntent, "
                "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
          );
        } else if (executionIntent is FormModelDataLoadIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormModelLoadDataExecutionUnit(
              xFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "FormModel (5.2.3) (${formModel.block.name}), _executionIntent: $executionIntent, "
                "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
          );
        } else if (executionIntent is FormModelSaveIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormModelSaveFormExecutionUnit(
              xFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "FormModel (5.2.4) (${formModel.block.name}), _executionIntent: $executionIntent, "
                "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
          );
        } else if (executionIntent is FormModelPatchFormFieldsIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormModelPatchFormFieldsExecutionUnit(
              xFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "FormModel (5.2.5) (${formModel.block.name}), _executionIntent: $executionIntent, "
                "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "FormModel (5.2.6) (${formModel.block.name}), _executionIntent: $executionIntent, "
                "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
          );
        }
      }

      // 5.3. Idle state when form data is fresh and no active intent is present
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "FormModel (5.3) (${formModel.block.name}), _executionIntent: null, "
            "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
            "__forceTypeForForm: $__forceTypeForForm, visibleX: $visibleX",
      );
    }

    // =========================================================================
    // 6. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return NxtExecutionUnit.no(
      debug: debug,
      info:
          "FormModel (6.1) (${formModel.block.name}), _executionIntent: $executionIntent, "
          "dataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
    );
  }

  // ***************************************************************************

  void printInfo() {
    print(toString());
  }

  @override
  String toString() {
    return "${getClassName(formModel)} - needQuery: $forceTypeForForm";
  }
}
