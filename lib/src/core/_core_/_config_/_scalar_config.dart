part of '../core.dart';

class ScalarConfig {
  final ScalarHiddenAction onHideAction;

  final ExternalShelfEventScalarRecipient onExternalShelfEvents;
  final InternalShelfEventScalarRecipient onInternalShelfEvents;

  ScalarConfig({
    this.onHideAction = ScalarHiddenAction.none,
    //
    this.onExternalShelfEvents = const ExternalShelfEventScalarRecipient(
      scalarLevelReactionOn: [],
    ),
    this.onInternalShelfEvents = const InternalShelfEventScalarRecipient(
      scalarLevelReactionOn: [],
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
