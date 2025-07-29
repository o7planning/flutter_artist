part of '../_fa_core.dart';

class ActivityFragmentWidgetBuilder extends _RefreshableWidget {
  final Activity activity;
  final Widget Function() build;

  const ActivityFragmentWidgetBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.activity,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _ActivityFragmentWidgetBuilderState();
  }
}

class _ActivityFragmentWidgetBuilderState
    extends _RefreshableWidgetState<ActivityFragmentWidgetBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.activity);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.activityFragment;

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.activity._addActivityFragmentWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
    widget.activity._removeActivityFragmentWidgetState(
      widgetState: this,
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.activity.shelf);
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
