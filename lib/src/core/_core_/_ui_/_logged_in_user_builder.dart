part of '../core.dart';

class LoggedInUserBuilder extends _RefreshableWidget {
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
    extends _RefreshableWidgetState<LoggedInUserBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return "LoggedInUserBuilder";
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.loggedInUser;

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
  Widget buildContent(BuildContext context) {
    ILoggedInUser? user = FlutterArtist.loggedInUser;
    //
    return widget.build(user);
  }

  @override
  void addWidgetState({required bool isShowing}) {
    FlutterArtist.globalsManager.ui._addLoggedInUserWidgetState(
      widgetState: this,
      isShowing: isShowing,
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
