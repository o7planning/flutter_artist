part of '../core.dart';

class ActivityFragmentViewBuilder extends _RefreshableWidget {
  final Activity activity;
  final Widget Function() build;

  const ActivityFragmentViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.activity,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _ActivityFragmentViewBuilderState();
  }
}

class _ActivityFragmentViewBuilderState
    extends _RefreshableWidgetState<ActivityFragmentViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.activity);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.activityFragment;

  @override
  bool get isScalarRepresentative {
    return false;
  }

  @override
  bool get isBlockRepresentative {
    return false;
  }

  @override
  bool get isItemRepresentative {
    return false;
  }

  @override
  bool get isFormRepresentative {
    return false;
  }

  @override
  bool get isActivityRepresentative {
    return false;
  }

  @override
  bool get isHookRepresentative {
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.activity.ui._addActivityPieceWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
    widget.activity.ui._removeActivityPieceWidgetState(
      widgetState: this,
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveActivity(widget.activity);
  }

  @override
  void executeAfterBuild() {
    // Do nothing.
  }

  @override
  void setBuildingState({required bool isBuilding}) {
    //
  }
}
