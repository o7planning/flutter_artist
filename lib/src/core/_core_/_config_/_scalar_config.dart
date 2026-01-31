part of '../core.dart';

class ScalarConfig {
  final ScalarHiddenAction onHideAction;

  final ExternalShelfEventS onExternalShelfEvents;
  final InternalShelfEventS onInternalShelfEvents;

  ScalarConfig({
    this.onHideAction = ScalarHiddenAction.none,
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
      onHideAction: onHideAction,
      //
      onExternalShelfEvents: onExternalShelfEvents,
      onInternalShelfEvents: onInternalShelfEvents,
    );
  }
}
