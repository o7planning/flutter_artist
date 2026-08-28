part of '../../core.dart';

class StageConfig {
  const StageConfig();

  StageConfig copy() => const StageConfig();
}

class StageEffectiveConfig {
  final StageConfig _baselineConfig;

  StageEffectiveConfig._fromConfig(this._baselineConfig);

  factory StageEffectiveConfig.fromConfig(StageConfig config) =>
      StageEffectiveConfig._fromConfig(config);
}
