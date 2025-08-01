part of '../core.dart';

class ScalarConfig {
  @Deprecated("Xoa di")
  final ScalarOutsideEventReaction? outsideEventReaction;

  final ScalarHiddenBehavior hiddenBehavior;

  final List<Evt>? reQueryByInternalShelfEvents;
  final List<Type>? reQueryByExternalShelfEvents;

  ScalarConfig({
    this.outsideEventReaction,
    //
    this.hiddenBehavior = ScalarHiddenBehavior.none,
    //
    this.reQueryByInternalShelfEvents,
    this.reQueryByExternalShelfEvents,
  });

  ScalarConfig copy() {
    return ScalarConfig(
      outsideEventReaction: outsideEventReaction,
      hiddenBehavior: hiddenBehavior,
      //
      reQueryByInternalShelfEvents: reQueryByInternalShelfEvents,
      reQueryByExternalShelfEvents: reQueryByExternalShelfEvents,
    );
  }
}
