part of '../core.dart';

class ProzessStructure<
STAGE_ENUM extends Enum, //
PROZESS_CONTEXT_DATA extends ProzessContextData> {
  final ProzessConfig config;
  final String? description;
  final List<
      Stage<
          STAGE_ENUM, //
          StageInitData,
          StageResultData,
          PROZESS_CONTEXT_DATA,
          CreationPreset,
          FormInput>> stages;

  final STAGE_ENUM? initialStageId;

  ProzessStructure({
    this.config = const ProzessConfig(),
    this.description,
    required this.initialStageId,
    this.stages = const [],
  });
}
