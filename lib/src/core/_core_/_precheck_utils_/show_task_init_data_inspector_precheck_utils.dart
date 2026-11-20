part of '__precheck_utils.dart';

/// Utility class providing pure precheck validation for opening the TaskInitData
/// debug inspector dialog.
class ShowTaskInitDataInspectorPrecheckUtils {
  /// Evaluates whether the current session and [hasInitData] permit opening
  /// the TaskInitData debug inspector dialog.
  static Actionable<ShowTaskInitDataInspectorPrecheck>
      checkBeforeShowInitDataInspector({
    required bool hasInitData,
    required ILoggedInUser? loggedInUser,
  }) {
    if (!hasInitData) {
      return Actionable.no(
        errCode: ShowTaskInitDataInspectorPrecheck.noInitData,
      );
    }

    if (loggedInUser == null) {
      return Actionable.no(
        errCode: ShowTaskInitDataInspectorPrecheck.noLoggedInUser,
      );
    }

    if (!loggedInUser.isSystemUser) {
      return Actionable.no(
        errCode: ShowTaskInitDataInspectorPrecheck.userIsNotSystemUser,
      );
    }

    return Actionable.yes();
  }
}
