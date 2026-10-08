part of '../core.dart';

class ProzessConfig {
  const ProzessConfig();

  ProzessConfig copy() => ProzessConfig();
}

class ProzessEffectiveConfig {
  final ProzessConfig _baselineConfig;

  ProzessEffectiveConfig._fromConfig(this._baselineConfig);

  factory ProzessEffectiveConfig.fromConfig(ProzessConfig config) =>
      ProzessEffectiveConfig._fromConfig(config);
}
