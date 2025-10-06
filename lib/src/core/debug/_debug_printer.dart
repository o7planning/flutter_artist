part of '../_core_/core.dart';

class DebugPrinter {
  static void printDebug(DebugCat consoleDebug, String message) {
    ConsoleDebugOptions options = FlutterArtist.consoleDebugOptions;
    if (!options.enabled) {
      return;
    }
    switch (consoleDebug) {
      case DebugCat.navigatorObserver:
        if (!options.navigatorObserver) {
          return;
        }
      case DebugCat.routeAware:
        if (!options.routeAware) {
          return;
        }
      case DebugCat.visibilityDetector:
        if (!options.visibilityDetector) {
          return;
        }
      case DebugCat.appStart:
        if (!options.appStart) {
          return;
        }
      case DebugCat.globalManager:
        if (!options.globalManager) {
          return;
        }
      case DebugCat.dataLoad:
        if (!options.dataLoad) {
          return;
        }
    }
    print(message);
  }
}
