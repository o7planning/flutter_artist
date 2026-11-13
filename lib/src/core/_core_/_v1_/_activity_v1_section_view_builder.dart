part of '../core.dart';

class ActivityV1ControlConfig extends ViewConfig {
  const ActivityV1ControlConfig()
      : super(
          quickSuggestionMode: QuickSuggestionMode.none,
          enableKeyboardNavigation: false,
          mouseFocusPolicy: ViewMouseFocusPolicy.strictNavigationOnly,
        );
}

class ActivityV1SectionViewBuilder extends _ContextProviderView {
  final ActivityV1 activity;
  final Widget Function() build;
  final ActivityV1ControlConfig config;

  const ActivityV1SectionViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.activity,
    required this.build,
    this.config = const ActivityV1ControlConfig(),
  });

  @override
  State<StatefulWidget> createState() {
    return _ActivitySectionViewBuilderState();
  }
}

class _ActivitySectionViewBuilderState
    extends _ContextProviderViewState<ActivityV1SectionViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.activityV1Section;

  @override
  FeatureModule? _getRelatedModule() {
    return null;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.activity);
  }

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  ProzessViewContext? get prozessViewContext => null;

  @override
  StageViewContext? get stageViewContext => null;

  @override
  TaskViewContext? get taskViewContext => null;

  @override
  bool get provideActivityV1Context {
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  String getDebugLabel() {
    return "ActivityV1SectionView()";
  }

  @override
  bool hasError() {
    return false;
  }

  @override
  List<_QuickSuggestionButton> createQuickSuggestionButtons(
      BuildContext context) {
    return [];
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
