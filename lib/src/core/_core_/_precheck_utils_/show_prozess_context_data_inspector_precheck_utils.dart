part of '__precheck_utils.dart';

/// Utility class providing pure precheck validation for opening the ProzessContextData
/// debug inspector dialog.
class ShowProzessContextDataInspectorPrecheckUtils {
  /// Evaluates whether the current session and [hasContextData] permit opening
  /// the ProzessContextData debug inspector dialog.
  static Actionable<ShowProzessContextDataInspectorPrecheck>
      checkBeforeShowContextDataInspector({
    required bool hasContextData,
    required ILoggedInUser? loggedInUser,
  }) {
    if (!hasContextData) {
      return Actionable.no(
        errCode: ShowProzessContextDataInspectorPrecheck.noContextData,
      );
    }

    if (loggedInUser == null) {
      return Actionable.no(
        errCode: ShowProzessContextDataInspectorPrecheck.noLoggedInUser,
      );
    }

    if (!loggedInUser.isSystemUser) {
      return Actionable.no(
        errCode: ShowProzessContextDataInspectorPrecheck.userIsNotSystemUser,
      );
    }

    return Actionable.yes();
  }
}
