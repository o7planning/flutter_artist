part of '_enums.dart';

enum StageRouteStatus {
  /// The stage is included in the active navigation route (executed / targeted).
  active,

  /// The stage was bypassed/skipped by the conditional routing logic.
  bypassed,

  /// The stage is yet to be reached or evaluated.
  unreached,
}
