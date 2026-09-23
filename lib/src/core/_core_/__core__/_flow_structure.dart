part of '../core.dart';

class FlowStructure<STAGE_ENUM extends Enum,
    FLOW_CONTEXT_DATA extends FlowContextData> {
  final FlowConfig config;
  final String? description;
  final List<
      Stage<
          STAGE_ENUM, //
          StageData,
          FLOW_CONTEXT_DATA,
          FormInput,
          AdditionalFormRelatedData>> stages;

  final STAGE_ENUM? initialStageId;

  FlowStructure({
    this.config = const FlowConfig(),
    this.description,
    required this.initialStageId,
    this.stages = const [],
  });
}
