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
  late final String keyId;

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  @override
  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "(LoggedInUserBuilder)"
        : widget.description!;
  }

  @override
  WidgetStateType get type => WidgetStateType.loggedInUser;

  @override
  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //
    keyId = _generateVisibilityDetectorId(prefix: "logged-user");
    //
    _addWidgetStateListener(isShowing: true);
  }

  @override
  Widget build(BuildContext context) {
    _LoggedInUserManager manager = FlutterArtist._loggedInUserManager;
    //
    ILoggedInUser? user = FlutterArtist.loggedInUser;
    return VisibilityDetector(
      key: Key(keyId),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        _addWidgetStateListener(isShowing: visiblePercentage > 0);
      },
      child: showMode == ShowMode.production
          ? widget.build(user)
          : _DevContainer(
              child: widget.build(user),
            ),
    );
  }

  void _addWidgetStateListener({
    ILoggedInUser? user,
    required bool isShowing,
  }) {
    FlutterArtist._loggedInUserManager._addWidgetStateListener(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void dispose() {
    super.dispose();
    FlutterArtist._loggedInUserManager._removeWidgetStateListener(
      widgetState: this,
    );
  }
}
