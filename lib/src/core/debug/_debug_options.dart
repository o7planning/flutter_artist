part of '../_core_/core.dart';

class DebugOptions {
  final bool showExecutionUnitQueue;

  DebugOptions({
    this.showExecutionUnitQueue = false,
  });
}

class ConsoleDebugOptions {
  final bool enabled;
  final bool navigatorObserver;
  final bool routeAware;
  final bool globalManager;
  final bool dataLoad;

  ConsoleDebugOptions({
    required this.enabled,
    this.navigatorObserver = false,
    this.routeAware = false,
    this.globalManager = false,
    this.dataLoad = false,
  });
}
