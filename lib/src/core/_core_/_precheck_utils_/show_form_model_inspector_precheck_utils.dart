part of '__precheck_utils.dart';

/// Utility class providing precheck validation for opening the FormModel
/// debug inspector dialog.
class ShowFormModelInspectorPrecheckUtils {
  /// Evaluates whether the current session and [hasForm] permit opening
  /// the FormModel debug inspector dialog.
  static Actionable<ShowFormModelInspectorPrecheck>
      checkBeforeShowFormModelInspector({
    required bool hasForm,
    required ILoggedInUser? loggedInUser,
  }) {
    if (!hasForm) {
      return Actionable.no(
        errCode: ShowFormModelInspectorPrecheck.noForm,
      );
    }

    if (loggedInUser == null) {
      return Actionable.no(
        errCode: ShowFormModelInspectorPrecheck.noLoggedInUser,
      );
    }

    if (!loggedInUser.isSystemUser) {
      return Actionable.no(
        errCode: ShowFormModelInspectorPrecheck.userIsNotSystemUser,
      );
    }

    return Actionable.yes();
  }
}
