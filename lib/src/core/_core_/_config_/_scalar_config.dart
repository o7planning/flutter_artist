part of '../core.dart';

class ScalarConfig {
  final ScalarHiddenBehavior hiddenBehavior;

  final bool selfReQueryable;

  ///
  /// Reaction to Internal Events.
  ///
  final List<Evt> executeScalarLevelReactionToEvts;

  ///
  /// Reaction to External Events.
  ///
  final List<Event> executeScalarLevelReactionToEvents;

  ScalarConfig({
    this.hiddenBehavior = ScalarHiddenBehavior.none,
    //
    this.selfReQueryable = false,
    List<Evt>? executeScalarLevelReactionToEvts,
    List<Event>? executeScalarLevelReactionToEvents,
  })
      : executeScalarLevelReactionToEvts =
  List.unmodifiable(executeScalarLevelReactionToEvts?.toSet() ?? []),
        executeScalarLevelReactionToEvents = List.unmodifiable(
            executeScalarLevelReactionToEvents?.toSet() ?? []);

  ScalarConfig copy() {
    return ScalarConfig(
      hiddenBehavior: hiddenBehavior,
      //
      selfReQueryable: selfReQueryable,
      executeScalarLevelReactionToEvts: executeScalarLevelReactionToEvts,
      executeScalarLevelReactionToEvents: executeScalarLevelReactionToEvents,
    );
  }
}
