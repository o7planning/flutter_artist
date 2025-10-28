part of '../core.dart';

class ScalarConfig {
  final ScalarHiddenBehavior hiddenBehavior;

  final bool selfReQueryable;
  final List<Evt> scalarLevelReactionToEvts;
  final List<Event> scalarLevelReactionToEvents;

  ScalarConfig({
    this.hiddenBehavior = ScalarHiddenBehavior.none,
    //
    this.selfReQueryable = false,
    List<Evt>? scalarLevelReactionToEvts,
    List<Event>? scalarLevelReactionToEvents,
  })  : scalarLevelReactionToEvts =
            List.unmodifiable(scalarLevelReactionToEvts?.toSet() ?? []),
        scalarLevelReactionToEvents =
            List.unmodifiable(scalarLevelReactionToEvents?.toSet() ?? []);

  ScalarConfig copy() {
    return ScalarConfig(
      hiddenBehavior: hiddenBehavior,
      //
      selfReQueryable: selfReQueryable,
      scalarLevelReactionToEvts: scalarLevelReactionToEvts,
      scalarLevelReactionToEvents: scalarLevelReactionToEvents,
    );
  }
}
