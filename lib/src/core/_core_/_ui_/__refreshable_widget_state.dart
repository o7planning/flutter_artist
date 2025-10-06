part of '../core.dart';

interface class IRefreshableWidgetState {
  ShowMode showMode = ShowMode.production;

  RefreshableWidgetType get type => throw UnimplementedError();

  String get locationInfo => throw UnimplementedError();

  String get description => throw UnimplementedError();

  void setState(Function() func) {}
}

// Google Search: Flutter NavigatorObserver Aware.
abstract class _RefreshableWidgetState<W extends _RefreshableWidget>
    extends State<W> //
    // Google Search: Flutter NavigatorObserver Aware.
    with
        RouteAware
    implements
        IRefreshableWidgetState {
  double __maxSize = 0;

  double get maxSize => __maxSize;

  int _refreshCount = 0;

  late final String keyId;

  @override
  ShowMode showMode = ShowMode.production;

  @override
  RefreshableWidgetType get type;

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  void setBuildingState({required bool isBuilding});

  void executeAfterBuild();

  void addWidgetState({required bool isShowing});

  void removeWidgetState();

  Widget buildContent(BuildContext context);

  ///
  /// Class name of Owner (Block, FormModel, FilterModel).
  ///
  String getWidgetOwnerClassName();

  void checkAndFreeMemory();

  @override
  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "${getWidgetOwnerClassName()} (${type.name})"
        : widget.description!;
  }

  void refreshState({bool force = false}) {
    if (force) {
      setState(() {});
    } else {
      if (_refreshCount < FlutterArtist.executor.taskUnitCount) {
        _refreshCount = FlutterArtist.executor.taskUnitCount;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      __executeAfterBuild();
    });
    this.setBuildingState(isBuilding: true);
    //
    return VisibilityDetector(
      key: Key(keyId),
      onVisibilityChanged: (VisibilityInfo visibilityInfo) {
        double s = visibilityInfo.size.width * visibilityInfo.size.height;
        if (__maxSize < s) {
          __maxSize = s;
        }
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        __addWidgetState(isShowing: visiblePercentage > 0);
      },
      child: showMode == ShowMode.production
          ? buildContent(context)
          : _DevContainer(
              child: buildContent(context),
            ),
    );
  }

  void __addWidgetState({required bool isShowing}) {
    DebugPrinter.printDebug(
      DebugCat.visibilityDetector,
      "[VisibilityDetector] ------------> ${getClassNameWithoutGenerics(widget)}: $isShowing (visible?)",
    );
    addWidgetState(isShowing: isShowing);
    // FlutterArtist.storage._freezeMan._onVisibilityChanged(
    //   widgetState: this,
    //   isShowing: isShowing,
    // );
  }

  void __removeWidgetState() {
    DebugPrinter.printDebug(
      DebugCat.visibilityDetector,
      "[VisibilityDetector] ------------> Remove ${getClassNameWithoutGenerics(widget)}",
    );
    removeWidgetState();
    // FlutterArtist.storage._freezeMan._onWidgetStateDisposed(
    //   widgetState: this,
    // );
  }

  Future<void> __executeAfterBuild() async {
    setBuildingState(isBuilding: false);
    // IMPORTANT: Do not remove below line:
    await Future.delayed(Duration.zero);
    setBuildingState(isBuilding: false);
    //
    executeAfterBuild();
  }

  @override
  void initState() {
    super.initState();
    //
    keyId = VisibilityDetectorUtils.generateVisibilityDetectorId(
        prefix: "${type.toString()}-${getWidgetOwnerClassName()}");
    //
    addWidgetState(isShowing: true);
  }

  @override
  void dispose() {
    FlutterArtist.navigatorObserver.unsubscribe(this);
    super.dispose();
    __removeWidgetState();
    //
    checkAndFreeMemory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FlutterArtist.navigatorObserver
        .subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPush() {
    // This route has been pushed onto the navigator.
    // You can infer this is the current route when this method is called.
    print('  [RouteAware] ---------> didPush: ${ModalRoute.of(context)?.settings.name} - ${getClassNameWithoutGenerics(widget)}');
  }

  @override
  void didPopNext() {
    // Another route was popped off, and this route is now the current one.
    print('  [RouteAware] ---------> didPopNext: ${ModalRoute.of(context)?.settings.name} - ${getClassNameWithoutGenerics(widget)}');
  }

  @override
  void didPushNext() {
    // A new route has been pushed on top of this one.
    print('  [RouteAware] ---------> didPushNext: ${ModalRoute.of(context)?.settings.name} - ${getClassNameWithoutGenerics(widget)}');
  }

  @override
  void didPop() {
    // This route has been popped off the navigator.
    print('  [RouteAware] ---------> didPop: ${ModalRoute.of(context)?.settings.name} - ${getClassNameWithoutGenerics(widget)}');
  }
}
