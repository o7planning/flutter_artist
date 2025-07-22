part of '../../flutter_artist.dart';

class ScalarConfig {
  final ScalarOutsideEventReaction? outsideEventReaction;

  final ScalarInternalEventReaction? internalEventReaction;

  final ScalarHiddenBehavior hiddenBehavior;

  ScalarConfig({
    required this.outsideEventReaction,
    required this.internalEventReaction,
    this.hiddenBehavior = ScalarHiddenBehavior.none,
  });
}
