part of '../core.dart';

class ActivitySectionViewBuilder extends _ContextProviderView {
  final Activity activity;
  final Widget Function() build;

  const ActivitySectionViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.activity,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _ActivitySectionViewBuilderState();
  }
}

class _ActivitySectionViewBuilderState
    extends _ContextProviderViewState<ActivitySectionViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.activity);
  }

  @override
  ContextProviderViewType get type => ContextProviderViewType.activityFragment;

  @override
  bool get provideScalarContext {
    return false;
  }

  @override
  bool get provideBlockContext {
    return false;
  }

  @override
  bool get provideItemContext {
    return false;
  }

  @override
  bool get provideFormContext {
    return false;
  }

  @override
  bool get isActivityRepresentative {
    return false;
  }

  @override
  bool get provideHookContext {
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
