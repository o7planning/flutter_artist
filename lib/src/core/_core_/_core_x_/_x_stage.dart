part of '../core.dart';

/// Runtime operational context wrapper for individual [Stage] instances inside a [Flow].
class XStage<
    STAGE_ENUM extends Enum,
    STAGE_DATA extends StageData,
    FLOW_CONTEXT_DATA extends FlowContextData,
    FORM_INPUT extends FormInput,
    ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData> {
  final XFlow xFlow;
  final Stage<
      STAGE_ENUM, //
      STAGE_DATA,
      FLOW_CONTEXT_DATA,
      FORM_INPUT,
      ADDITIONAL_FORM_RELATED_DATA> stage;

  String get name => stage.name;

  STAGE_ENUM get stageId => stage.stageId;

  StageSubmitExecutionIntent<
      STAGE_ENUM, //
      STAGE_DATA,
      FLOW_CONTEXT_DATA>? _executionIntent;

  StageSubmitExecutionIntent<
      STAGE_ENUM, //
      STAGE_DATA,
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
        executionUnit: _StageSubmitExecutionUnit<STAGE_ENUM, STAGE_DATA,
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
