part of '../flutter_artist.dart';

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
  Widget buildContent(BuildContext context) {
    ILoggedInUser? user = FlutterArtist.loggedInUser;
    //
    return widget.build(user);
  }

  @override
  void addFilterFragmentWidgetState({required bool isShowing}) {
    FlutterArtist._loggedInUserManager._addLoggedInUserWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeFilterFragmentWidgetState() {
    FlutterArtist._loggedInUserManager._removeLoggedInUserWidgetState(
      widgetState: this,
    );
  }

  @override
  void checkAndFreeMemory() {
    // Do nothing.
  }
}
