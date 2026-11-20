part of '__precheck_utils.dart';

/// Utility class providing pure precheck validation for opening the StageInitData
/// debug inspector dialog.
class ShowStageInitDataInspectorPrecheckUtils {
  /// Evaluates whether the stage route status, [hasInitData], and user session
  /// permit opening the StageInitData debug inspector dialog.
  static Actionable<ShowStageInitDataInspectorPrecheck>
      checkBeforeShowInitDataInspector({
    required StageRouteStatus stageRouteStatus,
    required bool hasInitData,
    required ILoggedInUser? loggedInUser,
  }) {
    switch (stageRouteStatus) {
      case StageRouteStatus.unreached:
        return Actionable.no(
          errCode: ShowStageInitDataInspectorPrecheck.stageUnreached,
        );
      case StageRouteStatus.bypassed:
        return Actionable.no(
          errCode: ShowStageInitDataInspectorPrecheck.stageBypassed,
        );
      case StageRouteStatus.active:
        break;
    }

    if (!hasInitData) {
      return Actionable.no(
        errCode: ShowStageInitDataInspectorPrecheck.noInitData,
      );
    }

    if (loggedInUser == null) {
      return Actionable.no(
        errCode: ShowStageInitDataInspectorPrecheck.noLoggedInUser,
      );
    }

    if (!loggedInUser.isSystemUser) {
      return Actionable.no(
        errCode: ShowStageInitDataInspectorPrecheck.userIsNotSystemUser,
      );
    }

    return Actionable.yes();
  }
}
