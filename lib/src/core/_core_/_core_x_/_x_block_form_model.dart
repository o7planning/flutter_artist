part of '../core.dart';

class XBlockFormModel<
    ID extends Comparable, //
    ITEM_DETAIL extends Identifiable<ID>> {
  XShelf get xShelf => xBlock.xShelf;

  final BlockFormModel formModel;
  late final XBlock<ID, Identifiable<ID>, ITEM_DETAIL> xBlock;
  final FormInput? formInput;

  int get xShelfId => xShelf.xShelfId;

  String get name => xBlock.name;

  //
  bool loaded = false;
  FormLoadHint _formLoadHint = FormLoadHint.auto;

  FormLoadHint get formLoadHint => _formLoadHint;

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
            "BlockFormModel (0.0), (${formModel.block.name}), _executionIntent: $executionIntent, "
            "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
      );
    }

    // =========================================================================
    // 1. DATA STATE = NONE
    // =========================================================================
    if (formModelDataState.isNone) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "BlockFormModel (1.1), (${formModel.block.name}), _executionIntent: $executionIntent, "
            "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
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
            xBlockFormModel: this,
            executionIntent: executionIntent,
          ),
          info:
              "BlockFormModel (2.1), (${formModel.block.name}), _executionIntent: $executionIntent, "
              "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
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
          executionUnit: _FormModelLoadDataExecutionUnit(
            xBlockFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "BlockFormModel (2.2.1), (${formModel.block.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "BlockFormModel (2.2.2), (${formModel.block.name}), _executionIntent: $executionIntent, "
              "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
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
            xBlockFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "BlockFormModel (3.1.1), (${formModel.block.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "BlockFormModel (3.1.2), (${formModel.block.name}), _executionIntent: $executionIntent, "
              "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
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
            xBlockFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "BlockFormModel (4.1.1), (${formModel.block.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "BlockFormModel (4.1.2), (${formModel.block.name}), _executionIntent: $executionIntent, "
              "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
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
        if (formModel.formMode == FormMode.creation) {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "BlockFormModel (5.1.1), (${formModel.block.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
                "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
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
            xBlockFormModel: this,
            executionIntent: intentToUse,
          ),
          info:
              "BlockFormModel (5.1.2), (${formModel.block.name}), _executionIntent: $executionIntent --> $intentToUse, "
              "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
              "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
        );
      }

      // IN: DATA STATE = FRESH
      // 5.2. Handle active execution intents
      if (executionIntent != null) {
        if (executionIntent is FormModelViewChangeIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormViewChangeExecutionUnit(
              xBlockFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "BlockFormModel (5.2.2), (${formModel.block.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
          );
        } else if (executionIntent is FormModelDataLoadIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormModelLoadDataExecutionUnit(
              xBlockFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "BlockFormModel (5.2.3), (${formModel.block.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
          );
        } else if (executionIntent is FormModelSaveIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormModelSaveFormExecutionUnit(
              xBlockFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "BlockFormModel (5.2.4), (${formModel.block.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
          );
        } else if (executionIntent is FormModelPatchFormFieldsIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FormModelPatchFormFieldsExecutionUnit(
              xBlockFormModel: this,
              executionIntent: executionIntent,
            ),
            info:
                "BlockFormModel (5.2.5), (${formModel.block.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "BlockFormModel (5.2.6), (${formModel.block.name}), _executionIntent: $executionIntent, "
                "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
          );
        }
      }

      // IN: DATA STATE = FRESH
      // 5.3. Idle state when form data is fresh and no active intent is present
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "BlockFormModel (5.3), (${formModel.block.name}), _executionIntent: null, "
            "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}, "
            "_formLoadHint: $_formLoadHint, visibleX: $visibleX",
      );
    }

    // =========================================================================
    // 6. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return NxtExecutionUnit.no(
      debug: debug,
      info:
          "BlockFormModel (6.1) (${formModel.block.name}), _executionIntent: $executionIntent, "
          "formDataState: ${formModelDataState.toBriefInfo()}, formMode: ${formModel.formMode.name}",
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
