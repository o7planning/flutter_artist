part of '../flutter_artist.dart';

class LoggedInUserBuilder extends _StatefulWidget {
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

class _LoggedInUserBuilderState extends _WidgetState<LoggedInUserBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return "LoggedInUserBuilder";
  }

  @override
  WidgetStateType get type => WidgetStateType.loggedInUser;

  @override
  Widget buildContent(BuildContext context) {
    ILoggedInUser? user = FlutterArtist.loggedInUser;
    //
    return widget.build(user);
  }

  @override
  void addWidgetStateListener({required bool isShowing}) {
    FlutterArtist._loggedInUserManager._addWidgetStateListener(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetStateListener() {
    FlutterArtist._loggedInUserManager._removeWidgetStateListener(
      widgetState: this,
    );
  }
}
