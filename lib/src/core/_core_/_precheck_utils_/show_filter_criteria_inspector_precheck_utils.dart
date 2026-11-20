part of '__precheck_utils.dart';

class ShowFilterCriteriaInspectorPrecheckUtils {
  /// Evaluates whether the current session and [hasFilterModel] permit opening
  /// the debug filter criteria / filter model inspector dialog.
  static Actionable<ShowFilterCriteriaInspectorPrecheck>
      checkBeforeShowFilterCriteriaInspector({
    required bool hasFilterModel,
    required ILoggedInUser? loggedInUser,
  }) {
    if (!hasFilterModel) {
      return Actionable.no(
        errCode: ShowFilterCriteriaInspectorPrecheck.noFilterModel,
      );
    }

    if (loggedInUser == null) {
      return Actionable.no(
        errCode: ShowFilterCriteriaInspectorPrecheck.noLoggedInUser,
      );
    }

    if (!loggedInUser.isSystemUser) {
      return Actionable.no(
        errCode: ShowFilterCriteriaInspectorPrecheck.userIsNotSystemUser,
      );
    }

    return Actionable.yes();
  }
}
