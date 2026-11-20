part of '__precheck_utils.dart';

/// Utility class providing pure precheck validation for opening global debug
/// inspector dialogs.
class ShowDebugInspectorPrecheckUtils {
  /// Evaluates whether the current session and active module state permit opening
  /// a global debug inspector dialog.
  static Actionable<ShowDebugInspectorPrecheck> checkBeforeShowDebugInspector({
    required ILoggedInUser? loggedInUser,
    required bool requiresRecentModule,
    required bool hasRecentModule,
  }) {
    if (loggedInUser == null) {
      return Actionable.no(
        errCode: ShowDebugInspectorPrecheck.noLoggedInUser,
      );
    }

    if (!loggedInUser.isSystemUser) {
      return Actionable.no(
        errCode: ShowDebugInspectorPrecheck.userIsNotSystemUser,
      );
    }

    if (requiresRecentModule && !hasRecentModule) {
      return Actionable.no(
        errCode: ShowDebugInspectorPrecheck.noActiveModule,
      );
    }

    return Actionable.yes();
  }
}
