part of '../core.dart';

class LoggedInUserViewConfig extends ViewConfig {
  const LoggedInUserViewConfig()
      : super(
          quickSuggestionMode: QuickSuggestionMode.none,
          enableKeyboardNavigation: false,
          mouseFocusPolicy: ViewMouseFocusPolicy.strictNavigationOnly,
        );
}

class LoggedInUserBuilder extends _ContextProviderView {
  final Widget Function(ILoggedInUser? user) build;
  @override
  final LoggedInUserViewConfig config;

  const LoggedInUserBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.build,
    this.config = const LoggedInUserViewConfig(),
  });

  @override
  State<StatefulWidget> createState() {
    return _LoggedInUserBuilderState();
  }
}

class _LoggedInUserBuilderState
    extends _ContextProviderViewState<LoggedInUserBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.loggedInUser;

  @override
  Shelf? _getRelatedModule() {
    return null;
  }

  @override
  String getWidgetOwnerClassName() {
    return "LoggedInUserBuilder";
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
  Widget buildContent(BuildContext context) {
    ILoggedInUser? user = FlutterArtist.loggedInUser;
    //
    return widget.build(user);
  }

  @override
  String getDebugLabel() {
    return "LoginUserView()";
  }

  @override
  bool hasError() {
    return false; // TODO: Hardcode
  }

  @override
  List<_QuickSuggestionButton> createQuickSuggestionButtons(
      BuildContext context) {
    return [];
  }

  @override
  void addWidgetState({required bool isVisible}) {
    FlutterArtist.globalsManager.ui._addLoggedInUserWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    FlutterArtist.globalsManager.ui._removeLoggedInUserWidgetState(
      widgetState: this,
    );
  }

  @override
  void checkAndFreeMemory() {
    // Do nothing.
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
