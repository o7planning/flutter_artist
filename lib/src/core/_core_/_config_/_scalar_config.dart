part of '../core.dart';

/// Configuration schema that dictates the behavioral policies, ancestor
/// invalidation dependencies, and event reactions for a [Scalar].
class ScalarConfig {
  /// Dictates whether this scalar's query depends on properties within the
  /// ancestor's payload value, rather than just the ancestor's identity ([valueId]).
  ///
  /// When set to `true`, if any ancestor transitions from FRESH to STALE,
  /// this child scalar will also automatically invalidate and transition to STALE.
  /// Defaults to `false`.
  final bool bindToAncestorPayloadState;

  final ScalarHiddenAction onHideAction;

  /// The list of event reaction rules configuring how this scalar should react
  /// to external or internal domain data type broadcasts.
  final List<ScalarEventReaction> reactions;

  /// Creates a configuration instance for a [Scalar].
  const ScalarConfig({
    this.bindToAncestorPayloadState = false,
    this.reactions = const [],
  }) : onHideAction = ScalarHiddenAction.none;

  /// Creates an immutable copy of this [ScalarConfig] with the current configuration values.
  ScalarConfig copy() {
    return ScalarConfig(
      bindToAncestorPayloadState: bindToAncestorPayloadState,
      reactions: List.unmodifiable(reactions),
    );
  }
}
