part of '../core.dart';

/// Runtime operational context wrapper for individual [Stage] instances inside a [Prozess].
class XStage<
    STAGE_ENUM extends Enum,
    STAGE_INIT_DATA extends StageInitData,
    STAGE_RESULT_DATA extends StageResultData,
    PROZESS_CONTEXT_DATA extends ProzessContextData,
    FORM_INPUT extends FormInput> {
  final XProzess xProzess;

  final XStageFormModel? xStageFormModel;

  final Stage<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA,
      FORM_INPUT> stage;

  String get name => stage.name;

  STAGE_ENUM get stageId => stage.stageId;

  StageSubmitExecutionIntent<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA>? _executionIntent;

  StageSubmitExecutionIntent<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA>? get executionIntent => _executionIntent;

  StageLoadInitDataResult<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      PROZESS_CONTEXT_DATA> loadInitDataResult = StageLoadInitDataResult<
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
  NxtExecutionUnit __getNextExecutionUnit({required bool debug}) {
    final bool isCurrentStage = xProzess.flow.currentStageId == stageId;
    if (!isCurrentStage) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "Stage (${stage.name}) is not the active stage in Prozess (${xProzess.name}).",
      );
    }

    if (_executionIntent != null) {
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit: _StageSubmitExecutionUnit<
            STAGE_ENUM, //
            STAGE_INIT_DATA,
            STAGE_RESULT_DATA,
            PROZESS_CONTEXT_DATA>(
          xStage: this,
          executionIntent: _executionIntent!,
        ),
        info: "Stage (${stage.name}) executing stage intent: $_executionIntent",
      );
    }

    return NxtExecutionUnit.no(
      debug: debug,
      info: "Stage (${stage.name}) is current but has no active intent.",
    );
  }
}
