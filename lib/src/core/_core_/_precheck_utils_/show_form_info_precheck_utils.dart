part of '__precheck_utils.dart';

/// Utility class containing pure precheck logic for showing form debug info.
class ShowFormInfoPrecheckUtils {
  /// Evaluates whether showing form information is permitted based on form presence
  /// and system user credentials.
  static Actionable<ShowFormInfoPrecheck> checkBeforeShowFormInfo({
    required bool hasForm,
    required bool isLoggedIn,
    required bool isSystemUser,
  }) {
    // 1. Check if form model exists
    if (!hasForm) {
      return Actionable<ShowFormInfoPrecheck>.no(
        errCode: ShowFormInfoPrecheck.noForm,
      );
    }

    // 2. Check if user is logged in
    if (!isLoggedIn) {
      return Actionable<ShowFormInfoPrecheck>.no(
        errCode: ShowFormInfoPrecheck.noLoggedInUser,
      );
    }

    // 3. Check if logged-in user holds system user privileges
    if (!isSystemUser) {
      return Actionable<ShowFormInfoPrecheck>.no(
        errCode: ShowFormInfoPrecheck.userIsNotSystemUser,
      );
    }

    return Actionable<ShowFormInfoPrecheck>.yes();
  }
}
