part of '../_core_/core.dart';

class DebugOptions {
  final bool showTaskUnitQueue;

  DebugOptions({
    this.showTaskUnitQueue = false,
  });
}

class ConsoleDebugOptions {
  final bool enabled;

  final bool navigatorObserver;
  final bool visibilityDetector;
  final bool appStart;
  final bool globalManager;
  final bool dataLoad;

  ConsoleDebugOptions({
    required this.enabled,
    this.navigatorObserver = false,
    this.visibilityDetector = false,
    this.appStart = false,
    this.globalManager = false,
    this.dataLoad = false,
  });
}
