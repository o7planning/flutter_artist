part of '../core.dart';

class _FlutterArtistNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didPush: ${route.settings.name} - previousRoute: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didPop: ${route.settings.name} - previousRoute: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didChangeTop: ${topRoute.settings.name} - previousTopRoute: ${previousTopRoute?.settings.name}',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didRemove: ${route.settings.name} - previousRoute: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didReplace: ${newRoute?.settings?.name} - oldRoute: ${oldRoute?.settings.name}',
    );
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didStartUserGesture: ${route.settings.name} - previousRoute: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didStopUserGesture() {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didStopUserGesture',
    );
  }
}
