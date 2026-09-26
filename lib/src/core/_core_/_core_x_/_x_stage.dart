part of '../core.dart';

/// Runtime operational context wrapper for individual [Stage] instances inside a [Flow].
class XStage<
    STAGE_ENUM extends Enum,
    STAGE_INIT_DATA extends StageInitData,
    STAGE_RESULT_DATA extends StageResultData,
    FLOW_CONTEXT_DATA extends FlowContextData,
    CREATION_PRESET extends CreationPreset,
    FORM_INPUT extends FormInput> {
  final XFlow xFlow;
  final Stage<
      STAGE_ENUM, //
      STAGE_INIT_DATA,
      STAGE_RESULT_DATA,
      FLOW_CONTEXT_DATA,
      CREATION_PRESET,
      FORM_INPUT> stage;

  String get name => stage.name;

  STAGE_ENUM get stageId => stage.stageId;

  StageSubmitExecutionIntent<
      STAGE_ENUM, //
      STAGE_RESULT_DATA,
      FLOW_CONTEXT_DATA>? _executionIntent;

  StageSubmitExecutionIntent<
      STAGE_ENUM, //
      STAGE_RESULT_DATA,
      FLOW_CONTEXT_DATA>? get executionIntent => _executionIntent;

  XStage._({
    required this.xFlow,
    required this.stage,
  });

  /// Evaluates if this specific stage is active and has pending execution units.
  NxtExecutionUnit _getNextExecutionUnit({required bool debug}) {
    final bool isCurrentStage = xFlow.flow.currentStageId == stageId;
    if (!isCurrentStage) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
            "Stage (${stage.name}) is not the active stage in Flow (${xFlow.name}).",
      );
    }

    if (_executionIntent != null) {
      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit: _StageSubmitExecutionUnit<STAGE_ENUM, STAGE_RESULT_DATA,
            FLOW_CONTEXT_DATA>(
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
