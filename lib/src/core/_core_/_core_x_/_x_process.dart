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

  ExecHint _loadInitDataHint = ExecHint.none;

  bool _initDataLoaded = false;

  ProzessExecutionIntent<STAGE_ENUM, PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA,
      dynamic, dynamic>? _executionIntent;

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
    final ProzessDataState prozessDataState = prozess.dataState;
    final originExecutionIntent = _executionIntent;
    final bool isVisible = prozess.ui.hasVisibleViews();

    if (originExecutionIntent is ProzessDoneIntent) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "Prozess (0.0), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent, "
            "dataState: ${prozessDataState.toBriefInfo()}, isVisible: $isVisible",
      );
    }

    // =========================================================================
    // 1. PENDING.
    // =========================================================================
    if (prozessDataState.isPending) {
      final bool shouldLoadInitData =
          (_loadInitDataHint == ExecHint.force || isVisible) &&
              !_initDataLoaded;
      if (shouldLoadInitData) {
        final ProzessLoadInitDataIntent<STAGE_ENUM, PROZESS_INIT_DATA,
            PROZESS_CONTEXT_DATA> intentToUse;
        if (originExecutionIntent is ProzessLoadInitDataIntent<STAGE_ENUM,
            PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>) {
          intentToUse = originExecutionIntent;
        } else {
          intentToUse = _createAndSetProzessIntentLoadInitData();
        }
        // IN: DATA STATE = PENDING
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ProzessLoadInitDataExecutionUnit<STAGE_ENUM,
              PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>(
            xProzess: this,
            executionIntent: intentToUse,
          ),
          info:
              "Prozess (1.1), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent --> $intentToUse, "
              "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "Prozess (1.2), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent, "
              "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
        );
      }
    }
    // =========================================================================
    // 2. LOADED STALE.
    // =========================================================================
    else if (prozessDataState.isStale) {
      final bool shouldLoadInitData =
          (_loadInitDataHint == ExecHint.force || isVisible) &&
              !_initDataLoaded;
      if (shouldLoadInitData) {
        final ProzessLoadInitDataIntent<STAGE_ENUM, PROZESS_INIT_DATA,
            PROZESS_CONTEXT_DATA> intentToUse;
        if (originExecutionIntent is ProzessLoadInitDataIntent<STAGE_ENUM,
            PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>) {
          intentToUse = originExecutionIntent;
        } else {
          intentToUse = _createAndSetProzessIntentLoadInitData();
        }
        // IN: DATA STATE = PENDING
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ProzessLoadInitDataExecutionUnit<STAGE_ENUM,
              PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>(
            xProzess: this,
            executionIntent: intentToUse,
          ),
          info:
              "Prozess (2.1), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent --> $intentToUse, "
              "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "Prozess (2.2), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent, "
              "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
        );
      }
    }
    // =========================================================================
    // 3. LOADED FRESH.
    // =========================================================================
    else if (prozessDataState.isFresh) {
      final bool shouldLoadInitData =
          (_loadInitDataHint == ExecHint.force) && !_initDataLoaded;
      if (shouldLoadInitData) {
        final ProzessLoadInitDataIntent<STAGE_ENUM, PROZESS_INIT_DATA,
            PROZESS_CONTEXT_DATA> intentToUse;
        if (originExecutionIntent is ProzessLoadInitDataIntent<STAGE_ENUM,
            PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>) {
          intentToUse = originExecutionIntent;
        } else {
          intentToUse = _createAndSetProzessIntentLoadInitData();
        }
        // IN: DATA STATE = LOADED FRESH
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ProzessLoadInitDataExecutionUnit<STAGE_ENUM,
              PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>(
            xProzess: this,
            executionIntent: intentToUse,
          ),
          info:
              "Prozess (3.1), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent --> $intentToUse, "
              "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
        );
      } else {
        if (originExecutionIntent is ProzessDetermineNextStageIntent<STAGE_ENUM,
            PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _ProzessDetermineNextStageExecutionUnit<STAGE_ENUM,
                PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>(
              xProzess: this,
              executionIntent: originExecutionIntent,
            ),
            info:
                "Prozess (3.2.1), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent, "
                "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "Prozess (3.2.2), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent, "
                "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
          );
        }
      }
    }
    // =========================================================================
    // 4. TRANSITIONING FAILED.
    // =========================================================================
    else if (prozessDataState.isTransitioningFailed) {
      final bool shouldLoadInitData =
          (_loadInitDataHint == ExecHint.force) && !_initDataLoaded;
      if (shouldLoadInitData) {
        final ProzessLoadInitDataIntent<STAGE_ENUM, PROZESS_INIT_DATA,
            PROZESS_CONTEXT_DATA> intentToUse;
        if (originExecutionIntent is ProzessLoadInitDataIntent<STAGE_ENUM,
            PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>) {
          intentToUse = originExecutionIntent;
        } else {
          intentToUse = _createAndSetProzessIntentLoadInitData();
        }
        // IN: DATA STATE = TRANSITIONING FAILED.
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ProzessLoadInitDataExecutionUnit<STAGE_ENUM,
              PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>(
            xProzess: this,
            executionIntent: intentToUse,
          ),
          info:
              "Prozess (4.1), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent --> $intentToUse, "
              "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
        );
      }
      // !shouldLoadInitData
      else {
        if (originExecutionIntent is ProzessDetermineNextStageIntent<STAGE_ENUM,
            PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _ProzessDetermineNextStageExecutionUnit<STAGE_ENUM,
                PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>(
              xProzess: this,
              executionIntent: originExecutionIntent,
            ),
            info:
                "Prozess (4.2.1), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent, "
                "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
                "Prozess (4.2.2), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent, "
                "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
          );
        }
      }
    }
    // =========================================================================
    // 5. TRANSITIONING SUCCESS.
    // =========================================================================
    else if (prozessDataState.isTransitioningSuccess) {
      final bool shouldLoadInitData =
          (_loadInitDataHint == ExecHint.force) && !_initDataLoaded;
      if (shouldLoadInitData) {
        final ProzessLoadInitDataIntent<STAGE_ENUM, PROZESS_INIT_DATA,
            PROZESS_CONTEXT_DATA> intentToUse;
        if (originExecutionIntent is ProzessLoadInitDataIntent<STAGE_ENUM,
            PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>) {
          intentToUse = originExecutionIntent;
        } else {
          intentToUse = _createAndSetProzessIntentLoadInitData();
        }
        // IN: DATA STATE = TRANSITIONING SUCCESS.
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _ProzessLoadInitDataExecutionUnit<STAGE_ENUM,
              PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>(
            xProzess: this,
            executionIntent: intentToUse,
          ),
          info:
              "Prozess (5.1), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent --> $intentToUse, "
              "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
        );
      }
      // !shouldLoadInitData
      else {
        if (originExecutionIntent is ProzessDetermineNextStageIntent<STAGE_ENUM,
            PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _ProzessDetermineNextStageExecutionUnit<STAGE_ENUM,
                PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>(
              xProzess: this,
              executionIntent: originExecutionIntent,
            ),
            info:
                "Prozess (5.2.1), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent\, "
                "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
          );
        }
        return NxtExecutionUnit.no(
          debug: debug,
          info:
              "Prozess (5.2.2), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent, "
              "dataState: ${prozessDataState.toBriefInfo()}, loadInitDataHint: $_loadInitDataHint, isVisible: $isVisible",
        );
      }
    }
    // =========================================================================
    // 6. COMPLETED.
    // =========================================================================
    else if (prozessDataState.isCompleted) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "Prozess (6.0), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent, "
            "dataState: ${prozessDataState.toBriefInfo()}, isVisible: $isVisible",
      );
    }
    // =========================================================================
    // 77. OTHERS
    // =========================================================================
    return NxtExecutionUnit.no(
      debug: debug,
      info:
          "Prozess (7.0), ${getClassNameWithoutGenerics(prozess)}, _executionIntent: $originExecutionIntent, "
          "dataState: ${prozessDataState.toBriefInfo()}, isVisible: $isVisible",
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _createAndSetProzessIntentDone({required String lastIntentInfo}) {
    _executionIntent = ProzessDoneIntent(
      lastIntentInfo: lastIntentInfo,
    );
  }

  ProzessLoadInitDataIntent<STAGE_ENUM, PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>
      _createAndSetProzessIntentLoadInitData() {
    final executionIntent = ProzessLoadInitDataIntent<STAGE_ENUM,
        PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  ProzessDetermineNextStageIntent<STAGE_ENUM, PROZESS_INIT_DATA,
      PROZESS_CONTEXT_DATA> _createAndSetProzessIntentDetermineNextStage({
    required PROZESS_INIT_DATA prozessInitData,
  }) {
    final executionIntent = ProzessDetermineNextStageIntent<STAGE_ENUM,
        PROZESS_INIT_DATA, PROZESS_CONTEXT_DATA>(
      // prozessInitData: prozessInitData,
    );
    _executionIntent = executionIntent;
    return executionIntent;
  }
}
