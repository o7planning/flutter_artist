part of '__precheck_utils.dart';

/// Utility class providing pure precheck validation for opening the ProzessInitData
/// debug inspector dialog.
class ShowProzessInitDataInspectorPrecheckUtils {
  /// Evaluates whether the current session and [hasInitData] permit opening
  /// the ProzessInitData debug inspector dialog.
  static Actionable<ShowProzessInitDataInspectorPrecheck>
      checkBeforeShowInitDataInspector({
    required bool hasInitData,
    required ILoggedInUser? loggedInUser,
  }) {
    if (!hasInitData) {
      return Actionable.no(
        errCode: ShowProzessInitDataInspectorPrecheck.noInitData,
      );
    }

    if (loggedInUser == null) {
      return Actionable.no(
        errCode: ShowProzessInitDataInspectorPrecheck.noLoggedInUser,
      );
    }

    if (!loggedInUser.isSystemUser) {
      return Actionable.no(
        errCode: ShowProzessInitDataInspectorPrecheck.userIsNotSystemUser,
      );
    }

    return Actionable.yes();
  }
}
