part of '__precheck_utils.dart';

class ShowFilterModelInspectorPrecheckUtils {
  /// Evaluates whether the current session and [hasFilterModel] permit opening
  /// the full FilterModel debug inspector dialog.
  static Actionable<ShowFilterModelInspectorPrecheck>
      checkBeforeShowFilterModelInspector({
    required bool hasFilterModel,
    required ILoggedInUser? loggedInUser,
  }) {
    if (!hasFilterModel) {
      return Actionable.no(
        errCode: ShowFilterModelInspectorPrecheck.noFilterModel,
      );
    }

    if (loggedInUser == null) {
      return Actionable.no(
        errCode: ShowFilterModelInspectorPrecheck.noLoggedInUser,
      );
    }

    if (!loggedInUser.isSystemUser) {
      return Actionable.no(
        errCode: ShowFilterModelInspectorPrecheck.userIsNotSystemUser,
      );
    }

    return Actionable.yes();
  }
}
