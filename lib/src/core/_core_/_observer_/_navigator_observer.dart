part of '../core.dart';

// https://pub.dev/packages/navigation_history_observer/example
class _FlutterArtistNavigatorObserver extends RouteObserver<PageRoute> {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didPush: ${route.settings.name} - previousRoute: ${previousRoute?.settings.name}',
    );
  }

  @override
  bool debugObservingRoute(PageRoute route) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route debugObservingRoute: ${route.settings.name}',
    );
    return super.debugObservingRoute(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didPop: ${route.settings.name} - previousRoute: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    super.didChangeTop(topRoute, previousTopRoute);
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didChangeTop: ${topRoute.settings.name} - previousTopRoute: ${previousTopRoute?.settings.name}',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didRemove: ${route.settings.name} - previousRoute: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didReplace: ${newRoute?.settings?.name} - oldRoute: ${oldRoute?.settings.name}',
    );
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);

    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didStartUserGesture: ${route.settings.name} - previousRoute: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didStopUserGesture',
    );
  }

  @override
  void subscribe(RouteAware routeAware, PageRoute route) {
    super.subscribe(routeAware, route);
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route subscribe: ${route.settings.name} - routeAware: ${routeAware}',
    );
  }

  @override
  void unsubscribe(RouteAware routeAware) {
    super.unsubscribe(routeAware);
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route unsubscribe: routeAware: ${routeAware}',
    );
  }
}
