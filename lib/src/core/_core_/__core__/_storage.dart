part of '../core.dart';

class _Storage extends _StorageCore {
  late final ui = _StorageUiComponents(storage: this);

  late final _projectionManager = _ProjectionManager(this);
  late final eventHelper = _EventHelper(this);
  final _naturalQueryQueue = _StorageNaturalQueryQueue();

  // ***************************************************************************
  // ***************************************************************************

  _Storage();

  // ***************************************************************************
  // ***************************************************************************

  void _init({
    required ExecutionTrace executionTrace,
    required EffectiveAppConfig appConfig,
  }) {
    TraceStep item = executionTrace.addControllableCall(
      codeId: "#SS000",
      caller: appConfig,
      methodName: "projectionFamilies",
      suffixShortDesc: "",
      tipDocument: TipDocument.projection,
    );
    final List<ProjectionFamily> projectionFamilies =
        appConfig.projectionFamilies;
    // This method may throw Fatal Error cause stop app.
    _projectionManager._init(
      executionTrace: executionTrace,
      projectionFamilies: projectionFamilies,
    );
    //
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterProjections
      ..sort();
    item = executionTrace.addControllableCall(
      codeId: "#SS040",
      caller: appConfig,
      methodName: "registerActivities",
      suffixShortDesc: "",
    );
    appConfig._registerActivities();
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterActivities
      ..sort();
    //
    item = executionTrace.addControllableCall(
      codeId: "#SS060",
      caller: appConfig,
      methodName: "registerShelves",
      suffixShortDesc: "",
      tipDocument: TipDocument.shelf,
    );
    appConfig._registerShelves();
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterShelves..sort();
    //
    item = executionTrace.addControllableCall(
      codeId: "#SS160",
      caller: appConfig,
      methodName: "additionalThemes",
      suffixShortDesc: "",
      tipDocument: TipDocument.theme,
    );
    List<FaTheme> faThemes = appConfig.additionalThemes;
    FaThemeHub.instance.registerAll(faThemes);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isRouteValid(RouteKey routeKey) {
    for (Shelf shelf in activeShelves) {
      Set<FaRouteData> routes = shelf.ui.faRouteDatas;
      for (FaRouteData faRouteData in routes) {
        if (faRouteData.key.id == routeKey.id) {
          print(" --> FOUND routeKey: ${routeKey}");
          return true;
        }
      }
    }
    if (FlutterArtist.isCommonRouteKey(routeKey)) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _logout() {
    _shelfMap.clear();
  }
}
