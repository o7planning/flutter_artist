part of '../core.dart';

class LoggedInUserBuilder extends _ContextProviderView {
  final Widget Function(ILoggedInUser? user) build;

  const LoggedInUserBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.build,
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
  Shelf? _getRelatedShelf() {
    return null;
  }


  @override
  String getWidgetOwnerClassName() {
    return "LoggedInUserBuilder";
  }

  @override
  BlockContextType? get blockContextType => null;

  @override
  ScalarContextType? get scalarContextType => null;

  @override
  StageContextType? get stageContextType => null;

  @override
  TaskContextType? get taskContextType => null;

  @override
  Widget buildContent(BuildContext context) {
    ILoggedInUser? user = FlutterArtist.loggedInUser;
    //
    return widget.build(user);
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
