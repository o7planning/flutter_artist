part of '../core.dart';

abstract class AppConfiguration {
  String get appName;

  List<ProjectionFamily> projectionFamilies();

  void registerShelves();

  void registerActivities() {}

  List<FaTheme> additionalThemes() => [];

  void overrideColorResolvers() {}

  FlutterArtistLocaleAdapter get localeAdapter;

  FlutterArtistLoginLogoutAdapter get loginLogoutAdapter;

  FlutterArtistNotificationAdapter? get notificationAdapter;

  FlutterArtistGlobalDataAdapter get globalDataAdapter;

  FlutterArtistCoreFeaturesAdapter get coreFeaturesAdapter;

  Future<void> showDebugNetworkInspector(BuildContext context);

  int get maxStoredLogEntryCount => 20;

  int get notificationFetchPeriodInSeconds => 24 * 60 * 60;

  int get codeFlowRetentionPeriodInSeconds => 60;

  DebugOptions get debugOptions => DebugOptions();

  ConsoleDebugOptions get consoleDebugOptions =>
      ConsoleDebugOptions(enabled: true);
}

class _DebugRegister {
  final List<String> __debugRegisterShelves = [];
  final List<String> __debugRegisterActivities = [];
  final List<String> __debugRegisterProjections = [];

  List<String> get debugRegisterShelves => __debugRegisterShelves;

  List<String> get debugRegisterActivities => __debugRegisterActivities;

  List<String> get debugRegisterProjections => __debugRegisterProjections;

  void _addDebugRegisterShelf(String info) {
    __debugRegisterShelves.add(info);
  }

  void _addDebugRegisterActivity(String info) {
    __debugRegisterActivities.add(info);
  }

  void _addDebugRegisterProjection(String info) {
    __debugRegisterProjections.add(info);
  }

  void printInfo() {
    print("1 - ${__debugRegisterShelves.firstOrNull}");
    print("2 - ${__debugRegisterActivities.firstOrNull}");
    print("4 - ${__debugRegisterProjections.firstOrNull}");
  }
}
