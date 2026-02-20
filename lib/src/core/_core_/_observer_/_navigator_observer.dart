part of '../core.dart';

// https://pub.dev/packages/navigation_history_observer/example
class _FlutterArtistNavigatorObserver extends RouteObserver<ModalRoute> {
  final List<ModalRoute> _history = [];

  ModalRoute? _topRoute;

  ModalRoute? get topRoute => _topRoute;

  bool get topRouteIsPopupRoute => _topRoute is PopupRoute;

  /// Returns all active route names in the back-stack.
  List<String> get historyNames =>
      _history.map((r) => r.settings.name ?? 'anonymous').toList();

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is ModalRoute) {
      _history.add(route);
    }
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
    // --- MIXED: Remove from history and trigger potential Block disposal ---
    if (route is ModalRoute) {
      _history.remove(route);
      _onRouteRemovedForever(route.settings.name);
    }
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
    if (topRoute is ModalRoute) {
      _topRoute = topRoute;
    }
    //
    super.didChangeTop(topRoute, previousTopRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is ModalRoute) {
      _history.remove(route);
      _onRouteRemovedForever(route.settings.name);
    }
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
    // --- MIXED: Vital for SAP-style apps to prevent leaks during replacement ---
    if (oldRoute is ModalRoute) {
      _history.remove(oldRoute);
      _onRouteRemovedForever(oldRoute.settings.name);
    }
    if (newRoute is ModalRoute) {
      _history.add(newRoute);
    }

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

  // --- INTERNAL DISPOSAL LOGIC ---
  void _onRouteRemovedForever(String? routeName) {
    if (routeName != null) {
      // Logic for FlutterArtist to wipe the Block from memory
      // because the user can no longer "back" to this route.
      DebugPrinter.printDebug(
          DebugCat.navigatorObserver, 'Disposing Block for: $routeName');
    }
  }
}
