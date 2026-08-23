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
    required RuntimeAppConfig appConfig,
  }) {
    TraceStep item = executionTrace._addTraceStep(
      codeId: "#SS000",
      shortDesc: "${debugObjHtml(appConfig)}.projectionFamilies().",
      traceStepType: TraceStepType.controllableCalling,
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
    item = executionTrace._addTraceStep(
      codeId: "#SS040",
      shortDesc: "${debugObjHtml(appConfig)}.registerActivities().",
      traceStepType: TraceStepType.controllableCalling,
      tipDocument: TipDocument.activity,
    );
    appConfig._registerActivities();
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterActivities
      ..sort();
    //
    item = executionTrace._addTraceStep(
      codeId: "#SS060",
      shortDesc: "${debugObjHtml(appConfig)}.registerShelves().",
      traceStepType: TraceStepType.controllableCalling,
      tipDocument: TipDocument.shelf,
    );
    appConfig._registerShelves();
    item._extraInfos = FlutterArtist.debugRegister.debugRegisterShelves..sort();
    //
    item = executionTrace._addTraceStep(
      codeId: "#SS160",
      shortDesc: "${debugObjHtml(appConfig)}.additionalThemes().",
      traceStepType: TraceStepType.controllableCalling,
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
