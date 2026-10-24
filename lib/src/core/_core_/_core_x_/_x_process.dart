part of '../core.dart';

/// Runtime prozess coordinator maintaining multi-stage progression and transitions.
class XProzess<
STAGE_ENUM extends StageEnum, //
PROZESS_INIT_DATA extends ProzessInitData,
PROZESS_CONTEXT_DATA extends ProzessContextData> {
  final XActivity xActivity;
  final Prozess<STAGE_ENUM, PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA> prozess;

  final Map<STAGE_ENUM, XStage> xStageMap = {};
  final List<XStage> allXStages = [];

  final List<XStageFormModel> allXStageFormModels = [];

  String get name => prozess.name;

  int get xModuleId => xActivity.xModuleId;

  ExecHint _restartHint = ExecHint.none;

  bool _initDataLoaded = false;

  ProzessExecutionIntent<
      STAGE_ENUM, //
      PROZESS_INIT_DATA,
      PROZESS_CONTEXT_DATA,
      dynamic,
      ExecutionUnitResult<dynamic>>? _stashedIntent;

  ProzessExecutionIntent<
      STAGE_ENUM, //
      PROZESS_INIT_DATA,
      PROZESS_CONTEXT_DATA,
      dynamic,
      ExecutionUnitResult<dynamic>>? _executionIntent;

  XProzess._({
    required this.xActivity,
    required this.prozess,
  }) {
    for (final Stage stage in prozess.orderedStages) {
      final StageFormModel? formModel = stage.formModel;
      XStageFormModel? xStageFormModel;
      if (formModel != null) {
        //
        // Create new XStageFormModel via 'formModel._createXStageFormModel' method
        // to have the same Generics Parameters with stage.
        //
        xStageFormModel = formModel._createXStageFormModel(formInput: null);
        allXStageFormModels.add(xStageFormModel);
      }
      //
      final xStage = stage._createXStage(
        xProzess: this,
        xStageFormModel: xStageFormModel,
      );
      xStageFormModel?.xStage = xStage;
      xStageMap[stage.stageId as STAGE_ENUM] = xStage;
      allXStages.add(xStage);
    }
  }

  // ***************************************************************************

  XStage findXStageById(STAGE_ENUM stageId) => xStageMap[stageId]!;

  // ***************************************************************************

  /// Finds and yields the next executable task belonging to the active stage.
  NxtExecutionUnit? _getNextExecutionUnit({required bool debug}) {
    NxtExecutionUnit next = __getNextExecutionUnit(debug: debug);
    if (next.yes) {
      return next;
    }
    //
    final Stage? frontierStage = prozess.findFrontierStage();
    if (frontierStage != null) {
      XStage frontierXStage =
      findXStageById(frontierStage.stageId as STAGE_ENUM);
      next = frontierXStage._getNextExecutionUnit(debug: debug);
      if (next.yes) {
        return next;
      }
    }
    return next;
  }

  // ***************************************************************************

  NxtExecutionUnit __getNextExecutionUnit({required bool debug}) {
    // 1. Restore stashed intent when idle
    if (_executionIntent == null && _stashedIntent != null) {
      _executionIntent = _stashedIntent;
      _stashedIntent = null;
    }

    final input = ProzessNextUnitInput(
      dataState: prozess.dataState,
      currentIntent: _executionIntent,
      restartHint: _restartHint,
      isVisible: prozess.ui.hasVisibleViews(),
      initDataLoaded: _initDataLoaded,
      modelName: getClassNameWithoutGenerics(prozess),
    );

    final output = ProzessExecutionCalculator.calculate(input);

    // 2. Retain the original Intent if pressured
    if (output.preserveCurrentIntent) {
      _stashedIntent = _executionIntent;
    }

    String finalDebugInfo = output.debugInfo;

    // 3. Injecting a Missing Intent (Restarting the process only)
    if (output.missingIntent == MissingIntentType.restart) {
      final intentToUse = _createAndSetProzessIntentRestart();
      finalDebugInfo = finalDebugInfo.replaceFirst(
          "_executionIntent: $_stashedIntent",
          "_executionIntent: $_stashedIntent --> $intentToUse");
    }

    // 4. Return to Execution Unit
    switch (output.action) {
      case ProzessExecutionAction.restart:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ProzessRestartExecutionUnit<STAGE_ENUM,
              PROZESS_INIT_DATA,
              PROZESS_CONTEXT_DATA>(
            xProzess: this,
            executionIntent: _executionIntent as ProzessRestartIntent<
                STAGE_ENUM,
                PROZESS_INIT_DATA,
                PROZESS_CONTEXT_DATA>,
          ),
          info: finalDebugInfo,
        );
      case ProzessExecutionAction.determineNextStage:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ProzessDetermineNextStageExecutionUnit<STAGE_ENUM,
              PROZESS_INIT_DATA,
              PROZESS_CONTEXT_DATA>(
            xProzess: this,
            executionIntent: _executionIntent
            as ProzessDetermineNextStageIntent<STAGE_ENUM,
                PROZESS_INIT_DATA,
                PROZESS_CONTEXT_DATA>,
          ),
          info: finalDebugInfo,
        );
      case ProzessExecutionAction.none:
      default:
        return NxtExecutionUnit.no(
          debug: debug,
          info: finalDebugInfo,
        );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndSetProzessIntentDone({required String lastIntentInfo}) {
    _executionIntent = ProzessDoneIntent(
      lastIntentInfo: lastIntentInfo,
    );
  }

  ProzessRestartIntent<STAGE_ENUM, PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>
  _createAndSetProzessIntentRestart() {
    final executionIntent = ProzessRestartIntent<STAGE_ENUM,
        PROZESS_INIT_DATA,
        PROZESS_CONTEXT_DATA>();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  ProzessDetermineNextStageIntent<STAGE_ENUM,
      PROZESS_INIT_DATA,
      PROZESS_CONTEXT_DATA> _createAndSetProzessIntentDetermineNextStage({
    required PROZESS_INIT_DATA prozessInitData,
  }) {
    final executionIntent = ProzessDetermineNextStageIntent<STAGE_ENUM,
        PROZESS_INIT_DATA,
        PROZESS_CONTEXT_DATA>(
      // prozessInitData: prozessInitData,
    );
    _executionIntent = executionIntent;
    return executionIntent;
  }
}
