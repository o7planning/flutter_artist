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
