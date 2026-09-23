part of '../core.dart';

class ActivityV1SectionViewBuilder extends _ContextProviderView {
  final ActivityV1 activity;
  final Widget Function() build;

  const ActivityV1SectionViewBuilder({
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
    extends _ContextProviderViewState<ActivityV1SectionViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.activityFragment;

  @override
  Shelf? _getRelatedShelf() {
    return null;
  }

  @override
  Activity? _getRelatedActivity() {
    return null;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.activity);
  }

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
  bool get provideStageContext {
    return false;
  }

  @override
  bool get provideTaskContext {
    return false;
  }

  @override
  bool get isActivityRepresentative {
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isVisible}) {
    widget.activity.ui._addActivityContentViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.activity.ui._removeActivityContentViewWidgetState(
      widgetState: this,
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.desk._checkToRemoveActivityV1(widget.activity);
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
