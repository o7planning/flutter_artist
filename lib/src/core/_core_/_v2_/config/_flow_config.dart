part of '../../core.dart';

class FlowConfig {
  const FlowConfig();

  FlowConfig copy() => FlowConfig();
}

class FlowEffectiveConfig {
  final FlowConfig _baselineConfig;

  FlowEffectiveConfig._fromConfig(this._baselineConfig);

  factory FlowEffectiveConfig.fromConfig(FlowConfig config) =>
      FlowEffectiveConfig._fromConfig(config);
}
