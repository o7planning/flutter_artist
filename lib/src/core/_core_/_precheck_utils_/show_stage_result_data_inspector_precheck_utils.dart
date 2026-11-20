part of '__precheck_utils.dart';

/// Utility class providing pure precheck validation for opening the StageResultData
/// debug inspector dialog.
class ShowStageResultDataInspectorPrecheckUtils {
  /// Evaluates whether the stage route status, [hasResultData], and user session
  /// permit opening the StageResultData debug inspector dialog.
  static Actionable<ShowStageResultDataInspectorPrecheck>
      checkBeforeShowResultDataInspector({
    required StageRouteStatus stageRouteStatus,
    required bool hasResultData,
    required ILoggedInUser? loggedInUser,
  }) {
    switch (stageRouteStatus) {
      case StageRouteStatus.unreached:
        return Actionable.no(
          errCode: ShowStageResultDataInspectorPrecheck.stageUnreached,
        );
      case StageRouteStatus.bypassed:
        return Actionable.no(
          errCode: ShowStageResultDataInspectorPrecheck.stageBypassed,
        );
      case StageRouteStatus.active:
        break;
    }

    if (!hasResultData) {
      return Actionable.no(
        errCode: ShowStageResultDataInspectorPrecheck.noResultData,
      );
    }

    if (loggedInUser == null) {
      return Actionable.no(
        errCode: ShowStageResultDataInspectorPrecheck.noLoggedInUser,
      );
    }

    if (!loggedInUser.isSystemUser) {
      return Actionable.no(
        errCode: ShowStageResultDataInspectorPrecheck.userIsNotSystemUser,
      );
    }

    return Actionable.yes();
  }
}
