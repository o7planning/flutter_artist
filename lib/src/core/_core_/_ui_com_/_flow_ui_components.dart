part of '../core.dart';

class _ProzessUiComponents extends _UiComponents {
  final Prozess prozess;

  _ProzessUiComponents({required this.prozess});

  @override
  // TODO: implement faRouteDatas
  Set<FaRouteData> get faRouteDatas => throw UnimplementedError();

  @override
  bool hasMountedViews() {
    // TODO: implement hasMountedUiComponent
    throw UnimplementedError();
  }

  String? findVisibleView() {
    return null;
  }
}
