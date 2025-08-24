part of '../core.dart';

class ScalarConfig {
  final ScalarHiddenBehavior hiddenBehavior;

  final bool selfReQueryable;
  final List<Evt> reQueryByInternalShelfEvents;
  final List<Type> reQueryByExternalShelfEvents;

  ScalarConfig({
    this.hiddenBehavior = ScalarHiddenBehavior.none,
    //
    this.selfReQueryable = false,
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
      selfReQueryable: selfReQueryable,
      reQueryByInternalShelfEvents: reQueryByInternalShelfEvents,
      reQueryByExternalShelfEvents: reQueryByExternalShelfEvents,
    );
  }
}
