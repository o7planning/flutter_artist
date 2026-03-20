part of 'core.dart';

class FlutterArtistRouterBridge implements RouterBridge {
  @override
  void onRouteRemoved(RouteKey key) {
    print("[FLUTTER-ARTIST-ROUTER] REMOVE ROUTE: ${key.path}#${key.id}");
  }

  @override
  bool isRouteValid(RouteKey route) {
    bool valid = FlutterArtist.storage.isRouteValid(route);
    print("[FLUTTER-ARTIST-ROUTER] CHECK isRouteValid: $route --> $valid");
    return valid;
  }
}
