part of '../core.dart';


class ScalarConfig {
  final ScalarHiddenAction onHideAction;

  final List<ScalarEventReaction> reactions;

  const ScalarConfig({
    this.reactions = const [],
  }) : onHideAction = ScalarHiddenAction.none;

  ScalarConfig copy() {
    return ScalarConfig(
      reactions: List.unmodifiable(reactions),
    );
  }
}
