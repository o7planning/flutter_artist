part of '../core.dart';

class _StageUiComponents extends _UiComponents {
  final Stage stage;

  _StageUiComponents({required this.stage});

  @override
  // TODO: implement faRouteDatas
  Set<FaRouteData> get faRouteDatas => throw UnimplementedError();

  String? findVisibleView() {
    return null;
  }

  @override
  bool hasMountedViews() {
    // TODO: implement hasMountedUiComponent
    throw UnimplementedError();
  }

  void refreshControlBars() {
    // TODO:....
  }

  void _removeStageBaseViewWidgetState({
    required _StageViewBuilderState widgetState,
  }) {
    // TODO: implement hasMountedUiComponent
    throw UnimplementedError();
  }

  void _addStageBaseViewWidgetState({
    required _StageViewBuilderState widgetState,
    required bool isVisible,
  }) {
    // TODO: implement hasMountedUiComponent
    throw UnimplementedError();
  }
}
