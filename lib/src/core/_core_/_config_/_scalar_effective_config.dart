part of '../core.dart';

/// Mutable runtime operational configuration governing the active execution,
/// invalidation dependencies, and event reactions of a [Scalar].
///
/// While [ScalarConfig] serves as the static, immutable declaration blueprint,
/// [ScalarEffectiveConfig] represents the live runtime configuration layer
/// evaluated during query execution and state transitions.
class ScalarEffectiveConfig {
  /// Reference to the immutable baseline configuration used to seed this instance.
  final ScalarConfig _baselineConfig;

  /// Private constructor initializing runtime settings from baseline [ScalarConfig].
  ScalarEffectiveConfig._fromConfig(this._baselineConfig);

  /// Factory constructor to instantiate an effective config bound to a baseline [ScalarConfig].
  factory ScalarEffectiveConfig.fromConfig(ScalarConfig config) {
    return ScalarEffectiveConfig._fromConfig(config);
  }

  // ===========================================================================
  // DELEGATED IMMUTABLE BASELINE PROPERTIES (VERSION 1.0)
  // ===========================================================================

  /// Dictates whether this scalar's query depends on properties within the
  /// ancestor's payload value, rather than just the ancestor's identity ([valueId]).
  bool get bindToAncestorPayloadState =>
      _baselineConfig.bindToAncestorPayloadState;

  /// Action performed when the UI component bound to this scalar is unmounted or hidden.
  ScalarHiddenAction get onHideAction => _baselineConfig.onHideAction;

  /// Registered event reactions configuring how this scalar responds to external notifications.
  List<ScalarEventReaction> get reactions => _baselineConfig.reactions;

  // ===========================================================================
  // LIFECYCLE CONTROLS
  // ===========================================================================

  /// Restores all mutable runtime properties back to their initial baseline configuration values.
  ///
  /// Ready for future runtime mutable extensions beyond version 1.0.
  void resetToBaseline() {
    // Version 1.0 contains purely immutable baseline properties.
  }
}
