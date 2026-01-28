part of '../core.dart';

class ScalarConfig {
  final ScalarHiddenBehavior hiddenBehavior;

  final ExternalShelfEventS onExternalShelfEvents;
  final InternalShelfEventS onInternalShelfEvents;

  ScalarConfig({
    this.hiddenBehavior = ScalarHiddenBehavior.none,
    //
    this.onExternalShelfEvents = const ExternalShelfEventS(
      scalarLevelReactionTo: [],
    ),
    this.onInternalShelfEvents = const InternalShelfEventS(
      scalarLevelReactionTo: [],
    ),
  });

  ScalarConfig copy() {
    return ScalarConfig(
      hiddenBehavior: hiddenBehavior,
      //
      onExternalShelfEvents: onExternalShelfEvents,
      onInternalShelfEvents: onInternalShelfEvents,
    );
  }
}
