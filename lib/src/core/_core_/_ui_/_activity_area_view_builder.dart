part of '../core.dart';

class ActivityAreaViewBuilder extends _RefreshableWidget {
  final Activity activity;
  final Widget Function() build;

  const ActivityAreaViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.activity,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _ActivityAreaViewBuilderState();
  }
}

class _ActivityAreaViewBuilderState
    extends _RefreshableWidgetState<ActivityAreaViewBuilder> {
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
  void addWidgetState({required bool isVisible}) {
    widget.activity.ui._addActivityBaseViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.activity.ui._removeActivityBaseViewWidgetState(
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
