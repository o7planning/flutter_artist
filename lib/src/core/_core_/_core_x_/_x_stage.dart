part of '../core.dart';

/// Runtime operational context wrapper for individual [Stage] instances inside a [Prozess].
class XStage<
STAGE_ENUM extends StageEnum,
STAGE_INIT_DATA extends StageInitData,
STAGE_RESULT_DATA extends StageResultData,
PROZESS_CONTEXT_DATA extends ProzessContextData,
FORM_INPUT extends FormInput,
FORM_OUTPUT extends FormOutput> {
  final XProzess xProzess;

  final XStageFormModel? xStageFormModel;

  final Stage<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA,
      FORM_INPUT,
      FORM_OUTPUT> stage;

  String get name => stage.name;

  STAGE_ENUM get stageId => stage.stageId;

  bool _executed = false;

  ExecHint _execHint = ExecHint.none;

  ExecHint get execHint => _execHint;

  StageExecutionIntent<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA,
      dynamic,
      ExecutionUnitResult<dynamic>>? _stashedIntent;

  StageExecutionIntent<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA,
      dynamic,
      ExecutionUnitResult<dynamic>>? _executionIntent;

  StageExecutionIntent<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA,
      dynamic,
      dynamic>? get executionIntent => _executionIntent;

  final stageRestartResult = StageRestartResult<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA>(precheck: null);

  XStage._({
    required this.xProzess,
    required this.stage,
    required this.xStageFormModel,
  });

  // ***************************************************************************
  // ***************************************************************************

  void setExecHint(ExecHint hint) {
    _execHint = hint;
  }

  void setExecHintToGreater(ExecHint hint) {
    if (_execHint.isLessThan(hint)) {
      _execHint = hint;
    }
  }

  void resetExecutionHints() {
    _execHint = ExecHint.none;
  }

  void _setExecutedTrue() {
    _executed = true;
  }

  void _setExecutedFalse() {
    _executed = false;
  }

  // ***************************************************************************
  // ***************************************************************************

  NxtExecutionUnit _getNextExecutionUnit({required bool debug}) {
    NxtExecutionUnit next = __getNextExecutionUnit(debug: debug);
    if (next.yes) {
      return next;
    }
    if (xStageFormModel != null) {
      next = xStageFormModel!._getNextExecutionUnit(debug: debug);
      if (next.yes) {
        return next;
      }
    }
    return next;
  }

  NxtExecutionUnit __getNextExecutionUnit({required bool debug}) {
    // 1. Restore the stashed intent if the current intent is null.
    if (_executionIntent == null && _stashedIntent != null) {
      _executionIntent = _stashedIntent;
      _stashedIntent = null;
    }

    final input = StageNextUnitInput(
      dataState: stage.dataState,
      currentIntent: _executionIntent,
      execHint: _execHint,
      isVisible: stage.ui.hasVisibleViews(),
      executed: _executed,
      modelName: getClassNameWithoutGenerics(stage),
      isCurrentStage: xProzess.prozess.viewingStageEnum == stageId,
      prozessName: xProzess.name,
    );

    final output = StageExecutionCalculator.calculate(input);

    // 2. Retain the old Intent if necessary
    if (output.preserveCurrentIntent) {
      _stashedIntent = _executionIntent;
    }

    String finalDebugInfo = output.debugInfo;

    // 3. Handling Side-effects: Injecting new Intents and updating Debug info
    if (output.missingIntent == MissingIntentType.restart) {
      final intentToUse = _createAndSetStageIntentRestart();
      finalDebugInfo = finalDebugInfo.replaceFirst(
          "_executionIntent: $_stashedIntent",
          "_executionIntent: $_stashedIntent --> $intentToUse");
    }

    // 4. Return Execution Unit
    switch (output.action) {
      case StageExecutionAction.restart:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageRestartExecutionUnit<STAGE_ENUM,
              STAGE_INIT_DATA,
              STAGE_RESULT_DATA,
              PROZESS_CONTEXT_DATA>(
            xStage: this,
            executionIntent: _executionIntent as StageRestartIntent<STAGE_ENUM,
                STAGE_INIT_DATA,
                STAGE_RESULT_DATA,
                PROZESS_CONTEXT_DATA>,
          ),
          info: finalDebugInfo,
        );
      case StageExecutionAction.submit:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageSubmitExecutionUnit<STAGE_ENUM,
              STAGE_INIT_DATA,
              STAGE_RESULT_DATA,
              PROZESS_CONTEXT_DATA>(
            xStage: this,
            executionIntent: _executionIntent as StageSubmitIntent<STAGE_ENUM,
                STAGE_INIT_DATA,
                STAGE_RESULT_DATA,
                PROZESS_CONTEXT_DATA>,
          ),
          info: finalDebugInfo,
        );
      case StageExecutionAction.none:
      default:
        return NxtExecutionUnit.no(
          debug: debug,
          info: finalDebugInfo,
        );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndSetStageIntentDone({required String lastIntentInfo}) {
    _executionIntent = StageDoneIntent<
        STAGE_ENUM, //
        STAGE_INIT_DATA,
        STAGE_RESULT_DATA,
        PROZESS_CONTEXT_DATA>(
      lastIntentInfo: lastIntentInfo,
    );
  }

  StageSubmitIntent<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA> _createAndSetStageIntentSubmit() {
    final executionIntent = StageSubmitIntent<
        STAGE_ENUM, //
        STAGE_INIT_DATA,
        STAGE_RESULT_DATA,
        PROZESS_CONTEXT_DATA>();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  StageRestartIntent<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA> _createAndSetStageIntentRestart() {
    final executionIntent = StageRestartIntent<
        STAGE_ENUM, //
        STAGE_INIT_DATA,
        STAGE_RESULT_DATA,
        PROZESS_CONTEXT_DATA>();
    _executionIntent = executionIntent;
    return executionIntent;
  }
}
