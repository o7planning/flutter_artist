part of '../core.dart';

/// Runtime operational context wrapper for individual [Stage] instances inside a [Prozess].
class XStage<
STAGE_ENUM extends Enum,
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
      dynamic>? _executionIntent;

  StageExecutionIntent<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA,
      dynamic,
      dynamic>? get executionIntent => _executionIntent;

  final loadInitDataResult = StageLoadInitDataResult<
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

  /// Evaluates if this specific stage is active and has pending execution units.
  /// Evaluates and yields the next operational execution unit for this Stage.
  NxtExecutionUnit __getNextExecutionUnit({required bool debug}) {
    final bool isCurrentStage = xProzess.prozess.currentStageId == stageId;
    if (!isCurrentStage) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
        "Stage (${stage.name}) is not the active stage in Prozess (${xProzess
            .name}).",
      );
    }

    final StageDataState stageDataState = stage.dataState;
    final executionIntent = _executionIntent;
    final bool isVisible = stage.ui.hasVisibleViews();

    // =========================================================================
    // 1. DATA STATE = PENDING
    // =========================================================================
    if (stageDataState.isPending) {
      final bool shouldExecute =
          (_execHint == ExecHint.force || isVisible) && !_executed;

      if (shouldExecute) {
        final StageLoadInitDataIntent<STAGE_ENUM,
            STAGE_INIT_DATA,
            STAGE_RESULT_DATA,
            PROZESS_CONTEXT_DATA> intentToUse;
        if (executionIntent is StageLoadInitDataIntent<STAGE_ENUM,
            STAGE_INIT_DATA,
            STAGE_RESULT_DATA,
            PROZESS_CONTEXT_DATA>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetStageIntentLoadInitData();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageLoadInitDataExecutionUnit<STAGE_ENUM,
              STAGE_INIT_DATA,
              STAGE_RESULT_DATA,
              PROZESS_CONTEXT_DATA>(
            xStage: this,
            executionIntent: intentToUse,
          ),
          info:
          "Stage (1.1), ${getClassNameWithoutGenerics(
              stage)}, _executionIntent: $executionIntent --> $intentToUse, "
              "dataState: ${stageDataState
              .toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "Stage (1.2), ${getClassNameWithoutGenerics(
              stage)}, _executionIntent: $executionIntent, "
              "dataState: ${stageDataState
              .toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      }
    }

    // =========================================================================
    // 2. DATA STATE = STALE
    // =========================================================================
    else if (stageDataState.isStale) {
      final bool shouldExecute =
          (_execHint == ExecHint.force || isVisible) && !_executed;

      if (shouldExecute) {
        final StageSubmitIntent<STAGE_ENUM,
            STAGE_INIT_DATA,
            STAGE_RESULT_DATA,
            PROZESS_CONTEXT_DATA> intentToUse;
        if (executionIntent is StageSubmitIntent<STAGE_ENUM,
            STAGE_INIT_DATA,
            STAGE_RESULT_DATA,
            PROZESS_CONTEXT_DATA>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetStageIntentSubmit();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageSubmitExecutionUnit<STAGE_ENUM,
              STAGE_INIT_DATA,
              STAGE_RESULT_DATA,
              PROZESS_CONTEXT_DATA>(
            xStage: this,
            executionIntent: intentToUse,
          ),
          info:
          "Stage (2.1), ${getClassNameWithoutGenerics(
              stage)}, _executionIntent: $executionIntent --> $intentToUse, "
              "dataState: ${stageDataState
              .toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "Stage (2.2), ${getClassNameWithoutGenerics(
              stage)}, _executionIntent: $executionIntent, "
              "dataState: ${stageDataState
              .toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      }
    }

    // =========================================================================
    // 3. DATA STATE = FRESH
    // =========================================================================
    else if (stageDataState.isFresh) {
      // 3.0. Intercept terminal Done intent to prevent duplicate scheduler cycles
      if (executionIntent is StageDoneIntent) {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "Stage (3.0), ${getClassNameWithoutGenerics(
              stage)}, _executionIntent: $executionIntent, "
              "dataState: ${stageDataState.toBriefInfo()}",
        );
      }
      // 3.1. Force execution explicitly requested via ExecHint
      if (_execHint == ExecHint.force) {
        final StageLoadInitDataIntent<STAGE_ENUM,
            STAGE_INIT_DATA,
            STAGE_RESULT_DATA,
            PROZESS_CONTEXT_DATA> intentToUse;
        if (executionIntent is StageLoadInitDataIntent<STAGE_ENUM,
            STAGE_INIT_DATA,
            STAGE_RESULT_DATA,
            PROZESS_CONTEXT_DATA>) {
          intentToUse = executionIntent;
        } else {
          intentToUse = _createAndSetStageIntentLoadInitData();
        }

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _StageLoadInitDataExecutionUnit<STAGE_ENUM,
              STAGE_INIT_DATA,
              STAGE_RESULT_DATA,
              PROZESS_CONTEXT_DATA>(
            xStage: this,
            executionIntent: intentToUse,
          ),
          info:
          "Stage (3.1), ${getClassNameWithoutGenerics(
              stage)}, _executionIntent: $intentToUse, "
              "dataState: ${stageDataState
              .toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
        );
      }
      // 3.2. Handle active execution intents dispatched imperatively
      if (executionIntent != null) {
        if (executionIntent is StageNullIntent) {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "Stage (3.2.1), ${getClassNameWithoutGenerics(
                stage)}, _executionIntent: $executionIntent, "
                "dataState: ${stageDataState.toBriefInfo()}",
          );
        }
        // StageSubmitIntent
        else if (executionIntent is StageSubmitIntent<STAGE_ENUM,
            STAGE_INIT_DATA,
            STAGE_RESULT_DATA,
            PROZESS_CONTEXT_DATA>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _StageSubmitExecutionUnit<STAGE_ENUM,
                STAGE_INIT_DATA,
                STAGE_RESULT_DATA,
                PROZESS_CONTEXT_DATA>(
              xStage: this,
              executionIntent: executionIntent,
            ),
            info:
            "Stage (3.2.2), ${getClassNameWithoutGenerics(
                stage)}, _executionIntent: $executionIntent, "
                "dataState: ${stageDataState.toBriefInfo()}",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "Stage (3.2.3), ${getClassNameWithoutGenerics(
                stage)}, unhandled _executionIntent: $executionIntent, "
                "dataState: ${stageDataState.toBriefInfo()}",
          );
        }
      }
      // 3.3. Idle state when data is fresh and no intent is active
      return NxtExecutionUnit.no(
        debug: debug,
        info:
        "Stage (3.3), ${getClassNameWithoutGenerics(
            stage)}, _executionIntent: null, "
            "dataState: ${stageDataState
            .toBriefInfo()}, execHint: $_execHint, isVisible: $isVisible",
      );
    }

    // =========================================================================
    // 4. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return NxtExecutionUnit.no(
      debug: debug,
      info:
      "Stage (4.1), ${getClassNameWithoutGenerics(
          stage)}, _executionIntent: $executionIntent, "
          "dataState: ${stageDataState.toBriefInfo()}, isVisible: $isVisible",
    );
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

  StageLoadInitDataIntent<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA> _createAndSetStageIntentLoadInitData() {
    final executionIntent = StageLoadInitDataIntent<
        STAGE_ENUM, //
        STAGE_INIT_DATA,
        STAGE_RESULT_DATA,
        PROZESS_CONTEXT_DATA>();
    _executionIntent = executionIntent;
    return executionIntent;
  }
}
