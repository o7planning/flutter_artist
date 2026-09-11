part of '../core.dart';

/// Represents the active, effective configuration resolved at runtime for a [FilterModel].
///
/// Wraps the baseline [FilterModelConfig] to provide access to operational policies,
/// while establishing an extensibility layer for runtime overrides or dynamic policy adjustments.
class FilterModelEffectiveConfig {
  /// The immutable baseline configuration supplied at initialization.
  final FilterModelConfig _baselineConfig;

  /// Private constructor binding the resolved baseline configuration.
  FilterModelEffectiveConfig._fromConfig(this._baselineConfig);

  /// Factory constructor resolving the effective configuration from a [FilterModelConfig].
  factory FilterModelEffectiveConfig.fromConfig(FilterModelConfig config) {
    return FilterModelEffectiveConfig._fromConfig(config);
  }

  /// The active policy governing how filter criteria mutations are committed and propagated.
  FilterApplyPolicy get applyPolicy => _baselineConfig.applyPolicy;

  /// Resets dynamic configuration parameters back to their original baseline values.
  void resetToBaseline() {
    // Version 1.0 contains purely immutable baseline properties.
  }
}
