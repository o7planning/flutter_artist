part of '../core.dart';

abstract class AppConfiguration {
  String get appName;

  FlutterArtistOverlayAdapter get overlayAdapter {
    return MaterialFlutterArtistOverlayAdapter();
  }

  List<ProjectionFamily> projectionFamilies();

  void registerShelves();

  void registerActivities() {}

  List<FaTheme> additionalThemes() => [];

  void overrideColorResolvers() {}

  Future<void> updateLocale({required Locale locale});

  /// Defines the whitelist of [Task] or [Prozess] types that are explicitly
  /// authorized to implement [SessionEstablisher] and mutate the global user session.
  ///
  /// Security enforcement: Any workflow attempting to establish a session that is
  /// not registered in this list will be blocked and throw a fatal error.
  ///
  /// Example: `return [AppLoginTask, MicrosoftLoginTask, MfaLoginProzess];`
  List<Type> authorizedSessionEstablishers();

  FlutterArtistLoginLogoutAdapter get loginLogoutAdapter;

  FlutterArtistNotificationAdapter? get notificationAdapter;

  FlutterArtistGlobalDataAdapter get globalDataAdapter;

  Future<void> showDebugNetworkInspector(BuildContext context);

  Duration get garbageCollectionInterval => Duration(seconds: 30);

  Duration get notificationFetchInterval => Duration(seconds: 24 * 60 * 60);

  Duration get codeFlowRetentionPeriod => Duration(seconds: 60);

  int get maxStoredLogEntryCount => 20;

  DebugOptions get debugOptions => DebugOptions();

  ConsoleDebugOptions get consoleDebugOptions =>
      ConsoleDebugOptions(enabled: true);
}
