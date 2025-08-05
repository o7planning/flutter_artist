part of '../core.dart';

class ScalarConfig {
  final ScalarHiddenBehavior hiddenBehavior;

  final List<Evt> reQueryByInternalShelfEvents;
  final List<Type> reQueryByExternalShelfEvents;

  ScalarConfig({
    this.hiddenBehavior = ScalarHiddenBehavior.none,
    //
    List<Evt>? reQueryByInternalShelfEvents,
    List<Type>? reQueryByExternalShelfEvents,
  })  : reQueryByInternalShelfEvents =
            List.unmodifiable(reQueryByInternalShelfEvents?.toSet() ?? []),
        reQueryByExternalShelfEvents =
            List.unmodifiable(reQueryByExternalShelfEvents?.toSet() ?? []);

  ScalarConfig copy() {
    return ScalarConfig(
      hiddenBehavior: hiddenBehavior,
      //
      reQueryByInternalShelfEvents: reQueryByInternalShelfEvents,
      reQueryByExternalShelfEvents: reQueryByExternalShelfEvents,
    );
  }
}
