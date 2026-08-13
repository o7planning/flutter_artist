part of '../core.dart';

class RuntimeAppConfig {
  final String appName;
  final List<ProjectionFamily> projectionFamilies;
  final List<FaTheme> additionalThemes;
  final Duration garbageCollectionInterval;
  final Duration notificationFetchInterval;
  final Duration codeFlowRetentionPeriod;
  final int maxStoredLogEntryCount;
  final DebugOptions debugOptions;
  final ConsoleDebugOptions consoleDebugOptions;

  final Future<void> Function({required Locale locale}) _updateLocale;
  final Function() _registerActivities;
  final Function() _registerShelves;
  final ShowDebugNetworkInspector _showDebugNetworkInspector;
  final FlutterArtistOverlayAdapter _overlayAdapter;
  final FlutterArtistLoginLogoutAdapter _loginLogoutAdapter;
  final FlutterArtistNotificationAdapter? _notificationAdapter;
  final FlutterArtistGlobalDataAdapter _globalDataAdapter;

  // Private constructor so only the framework can instantiate it
  RuntimeAppConfig._({
    required this.appName,
    required this.projectionFamilies,
    required this.additionalThemes,
    required this.garbageCollectionInterval,
    required this.notificationFetchInterval,
    required this.codeFlowRetentionPeriod,
    required this.maxStoredLogEntryCount,
    required this.debugOptions,
    required this.consoleDebugOptions,
    //
    required Future<void> Function({required Locale locale}) updateLocale,
    required Function() registerActivities,
    required Function() registerShelves,
    required ShowDebugNetworkInspector showDebugNetworkInspector,
    required FlutterArtistOverlayAdapter overlayAdapter,
    required FlutterArtistLoginLogoutAdapter loginLogoutAdapter,
    required FlutterArtistNotificationAdapter? notificationAdapter,
    required FlutterArtistGlobalDataAdapter globalDataAdapter,
  })  : _updateLocale = updateLocale,
        _registerActivities = registerActivities,
        _registerShelves = registerShelves,
        _showDebugNetworkInspector = showDebugNetworkInspector,
        _overlayAdapter = overlayAdapter,
        _loginLogoutAdapter = loginLogoutAdapter,
        _notificationAdapter = notificationAdapter,
        _globalDataAdapter = globalDataAdapter;

  /// Factory to capture and freeze the configuration state at startup.
  factory RuntimeAppConfig.fromConfiguration(AppConfiguration config) {
    return RuntimeAppConfig._(
      appName: config.appName,
      // Deep copy or freeze the list to prevent external mutations
      projectionFamilies: List.unmodifiable(config.projectionFamilies()),
      additionalThemes: List.unmodifiable(config.additionalThemes()),
      garbageCollectionInterval: config.garbageCollectionInterval,
      notificationFetchInterval: config.notificationFetchInterval,
      codeFlowRetentionPeriod: config.codeFlowRetentionPeriod,
      maxStoredLogEntryCount: config.maxStoredLogEntryCount,
      debugOptions: config.debugOptions,
      consoleDebugOptions: config.consoleDebugOptions,
      //
      updateLocale: config.updateLocale,
      registerActivities: config.registerActivities,
      registerShelves: config.registerShelves,
      showDebugNetworkInspector: config.showDebugNetworkInspector,
      overlayAdapter: config.overlayAdapter,
      loginLogoutAdapter: config.loginLogoutAdapter,
      notificationAdapter: config.notificationAdapter,
      globalDataAdapter: config.globalDataAdapter,
    );
  }
}
