part of '__precheck_utils.dart';

/// Utility class providing pure precheck validation for opening the TaskResultData
/// debug inspector dialog.
class ShowTaskResultDataInspectorPrecheckUtils {
  /// Evaluates whether the current session and [hasResultData] permit opening
  /// the TaskResultData debug inspector dialog.
  static Actionable<ShowTaskResultDataInspectorPrecheck>
      checkBeforeShowResultDataInspector({
    required bool hasResultData,
    required ILoggedInUser? loggedInUser,
  }) {
    if (!hasResultData) {
      return Actionable.no(
        errCode: ShowTaskResultDataInspectorPrecheck.noResultData,
      );
    }

    if (loggedInUser == null) {
      return Actionable.no(
        errCode: ShowTaskResultDataInspectorPrecheck.noLoggedInUser,
      );
    }

    if (!loggedInUser.isSystemUser) {
      return Actionable.no(
        errCode: ShowTaskResultDataInspectorPrecheck.userIsNotSystemUser,
      );
    }

    return Actionable.yes();
  }
}
