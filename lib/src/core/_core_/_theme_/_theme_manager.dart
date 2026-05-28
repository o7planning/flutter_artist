part of '../core.dart';

class ThemeManager extends _Core {
  final GlobalsManager _globalsManager;

  ThemeManager._({
    required GlobalsManager globalsManager,
  }) : _globalsManager = globalsManager {
    FaThemeHub.instance.addThemeListener(_saveUpdateTheme);
  }

  Future<void> _saveUpdateTheme() async {
    ILoggedInUser? loggedInUser = _globalsManager.loggedInUser;
    if (loggedInUser == null) {
      print("Can not _saveUpdateTheme, loggedInUser is null");
      return;
    }
    FaMetadata? meta = await FaIsarStorage.getLatestMetadata();
    String themeName = FaThemeHub.instance.lastNotifyThemeName;
    // IMPORTANT: Do not remove if.
    if (meta?.themeName != themeName) {
      print("@SAVE themeName --> Call FaIsarStorage.saveSettings()");
      await FaIsarStorage.saveSettings(
        userId: loggedInUser.userName,
        themeName: themeName,
      );
    }
  }
}
