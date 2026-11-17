part of '__precheck_utils.dart';

/// Utility class providing precheck validation for opening the FormModel
/// debug inspector dialog.
class ShowFormModelInspectorPrecheckUtils {
  /// Evaluates whether the current session and [hasForm] permit opening
  /// the FormModel debug inspector dialog.
  static Actionable<ShowFormModelInspectorPrecheck>
  checkBeforeShowFormModelInspector({
    required bool hasForm,
    required bool isLoggedIn,
    required bool isSystemUser,
  }) {
    if (!hasForm) {
      return Actionable.no(
        errCode: ShowFormModelInspectorPrecheck.noForm,
      );
    }

    if (!isLoggedIn) {
      return Actionable.no(
        errCode: ShowFormModelInspectorPrecheck.noLoggedInUser,
      );
    }

    if (!isSystemUser) {
      return Actionable.no(
        errCode: ShowFormModelInspectorPrecheck.userIsNotSystemUser,
      );
    }

    return Actionable.yes();
  }
}
