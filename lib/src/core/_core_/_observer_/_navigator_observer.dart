part of '../core.dart';

// https://pub.dev/packages/navigation_history_observer/example
class _FlutterArtistNavigatorObserver extends RouteObserver<ModalRoute> {
  ModalRoute? _topRoute;

  ModalRoute? get topRoute => _topRoute;

  bool get topRouteIsPopupRoute => _topRoute is PopupRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didPush: ${route.settings.name}'
      ' - previousRoute: ${previousRoute?.settings.name}',
    );
    //
    super.didPush(route, previousRoute);
  }

  @override
  bool debugObservingRoute(ModalRoute route) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route debugObservingRoute: ${route.settings.name}',
    );
    //
    return super.debugObservingRoute(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didPop: ${route.settings.name}'
      ' - previousRoute: ${previousRoute?.settings.name}',
    );
    //
    super.didPop(route, previousRoute);
  }

  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didChangeTop: ${topRoute.settings.name}'
      ' - previousTopRoute: ${previousTopRoute?.settings.name}',
    );
    //
    super.didChangeTop(topRoute, previousTopRoute);
    //
    if (topRoute is ModalRoute) {
      _topRoute = topRoute;
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didRemove: ${route.settings.name}'
      ' - previousRoute: ${previousRoute?.settings.name}',
    );
    //
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didReplace: ${newRoute?.settings.name}'
      ' - oldRoute: ${oldRoute?.settings.name}',
    );
    //
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didStartUserGesture: ${route.settings.name}'
      ' - previousRoute: ${previousRoute?.settings.name}',
    );
    //
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route didStopUserGesture',
    );
    //
    super.didStopUserGesture();
  }

  @override
  void subscribe(RouteAware routeAware, ModalRoute route) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route subscribe: ${route.settings.name}'
      ' - routeAware: $routeAware',
    );
    //
    super.subscribe(routeAware, route);
  }

  @override
  void unsubscribe(RouteAware routeAware) {
    DebugPrinter.printDebug(
      DebugCat.navigatorObserver,
      '[NavigatorObserver] -----------------> Route unsubscribe: routeAware: $routeAware',
    );
    //
    super.unsubscribe(routeAware);
  }
}
