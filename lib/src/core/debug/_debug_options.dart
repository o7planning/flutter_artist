part of '../_core_/core.dart';

class DebugOptions {
  final bool showTaskUnitQueue;

  DebugOptions({
    this.showTaskUnitQueue = false,
  });
}

class ConsoleDebugOptions {
  final bool enabled;
  final bool appStart;
  final bool shelfCreation;
  final bool autoStockerCreation;
  final bool navigatorObserver;
  final bool routeAware;
  final bool globalManager;
  final bool dataLoad;

  ConsoleDebugOptions({
    required this.enabled,
    this.appStart = false,
    this.shelfCreation = false,
    this.autoStockerCreation = false,
    this.navigatorObserver = false,
    this.routeAware = false,
    this.globalManager = false,
    this.dataLoad = false,
  });
}
