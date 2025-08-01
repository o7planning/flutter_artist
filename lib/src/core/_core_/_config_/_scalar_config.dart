part of '../core.dart';

class ScalarConfig {
  final ScalarHiddenBehavior hiddenBehavior;

  final List<Evt>? reQueryByInternalShelfEvents;
  final List<Type>? reQueryByExternalShelfEvents;

  ScalarConfig({
    this.hiddenBehavior = ScalarHiddenBehavior.none,
    //
    this.reQueryByInternalShelfEvents,
    this.reQueryByExternalShelfEvents,
  });

  ScalarConfig copy() {
    return ScalarConfig(
      hiddenBehavior: hiddenBehavior,
      //
      reQueryByInternalShelfEvents: reQueryByInternalShelfEvents,
      reQueryByExternalShelfEvents: reQueryByExternalShelfEvents,
    );
  }
}
