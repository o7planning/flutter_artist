part of '../core.dart';

interface class IContextProviderViewState {
  ShowMode showMode = ShowMode.production;

  ContextProviderViewType get type => throw UnimplementedError();

  String get locationInfo => throw UnimplementedError();

  String get description => throw UnimplementedError();

  void setState(Function() func) {}
}

// Google Search: Flutter NavigatorObserver Aware.
abstract class _ContextProviderViewState<W extends _ContextProviderView>
    extends State<W> //
// Google Search: Flutter NavigatorObserver Aware.
    with
        RouteAware
    implements
        IContextProviderViewState {
  String? __modelRouteName;

  double __maxSize = 0;

  double get maxSize => __maxSize;

  int _refreshCount = 0;

  @override
  ShowMode showMode = ShowMode.production;

  bool get provideBlockContext;

  bool get provideScalarContext;

  bool get provideItemContext;

  bool get provideHookContext;

  bool get provideFormContext;

  bool get isActivityRepresentative => false;

  bool isContextKind(ContextKind? contextKind) {
    switch (contextKind) {
      case null:
        // Do not change!
        return true;
      case ContextKind.scalar:
        return provideScalarContext;
      case ContextKind.block:
        return provideBlockContext;
      case ContextKind.item:
        return provideItemContext;
      case ContextKind.form:
        return provideFormContext;
      case ContextKind.hook:
        return provideHookContext;
      case ContextKind.activity:
        return isActivityRepresentative;
    }
  }

  @override
  ContextProviderViewType get type;

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  void setBuildingState({required bool isBuilding});

  void executeAfterBuild();

  void addWidgetState({required bool isVisible});

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
    setBuildingState(isBuilding: true);
    //
    return showMode == ShowMode.production
        ? buildContent(context)
        : _DevContainer(
            child: buildContent(context),
          );
  }

  void __addWidgetState({required bool isVisible}) {
    addWidgetState(isVisible: isVisible);
  }

  void __removeWidgetState() {
    removeWidgetState();
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //
    final ModalRoute modalRoute = ModalRoute.of(context)!;
    //
    FlutterArtist.navigatorObserver.subscribe(this, modalRoute);
    //
    __modelRouteName = modalRoute.settings.name;
    final bool topRouteIsDialog =
        FlutterArtist.navigatorObserver.topRouteIsPopupRoute;

    final String? topRouteName =
        FlutterArtist.navigatorObserver.topRoute?.settings.name;

    // Test: Event/62a  && Action/30a (Dialog)
    if (topRouteIsDialog) {
      // Do nothing!
    } else {
      if (__modelRouteName == topRouteName) {
        __addWidgetState(isVisible: true);
        //
        DebugPrinter.printDebug(
          DebugCat.routeAware,
          ' ---->  [RouteAware] ---------> didChangeDependencies (+): $__modelRouteName'
          ' ---->  ${getClassNameWithoutGenerics(widget)}',
        );
      } else {
        if (modalRoute is! DialogRoute) {
          __addWidgetState(isVisible: false);
          //
          DebugPrinter.printDebug(
            DebugCat.routeAware,
            ' ---->  [RouteAware] ---------> didChangeDependencies (-): $__modelRouteName'
            ' ---->  ${getClassNameWithoutGenerics(widget)}',
          );
        }
      }
    }
  }

  @override
  void dispose() {
    DebugPrinter.printDebug(
      DebugCat.routeAware,
      ' ---->  [RouteAware] ---------> unsubscribe: $__modelRouteName'
      ' ---->  ${getClassNameWithoutGenerics(widget)}',
    );
    //
    FlutterArtist.navigatorObserver.unsubscribe(this);
    //
    __removeWidgetState();
    //
    // Important (This code must be below of __removeWidgetState).
    super.dispose();
    //
    checkAndFreeMemory();
  }

  // This route has been pushed onto the navigator.
  // You can infer this is the current route when this method is called.
  @override
  void didPush() {
    __addWidgetState(isVisible: true);
    //
    DebugPrinter.printDebug(
      DebugCat.routeAware,
      ' ---->  [RouteAware] ---------> didPush: ${ModalRoute.of(context)?.settings.name}'
      ' ---->  ${getClassNameWithoutGenerics(widget)}',
    );
  }

  // This route has been popped off the navigator.
  @override
  void didPop() {
    __addWidgetState(isVisible: false);
    //
    DebugPrinter.printDebug(
      DebugCat.routeAware,
      ' ---->  [RouteAware] ---------> didPop: ${ModalRoute.of(context)?.settings.name}'
      ' ---->  ${getClassNameWithoutGenerics(widget)}',
    );
  }

  // A new route has been pushed on top of this one.
  @override
  void didPushNext() {
    // __addWidgetState(isVisible: false);
    //
    DebugPrinter.printDebug(
      DebugCat.routeAware,
      ' ---->  [RouteAware] ---------> didPushNext: ${ModalRoute.of(context)?.settings.name}'
      ' ---->  ${getClassNameWithoutGenerics(widget)}',
    );
  }

  // Another route was popped off, and this route is now the current one.
  @override
  void didPopNext() {
    // __addWidgetState(isVisible: true);
    //
    DebugPrinter.printDebug(
      DebugCat.routeAware,
      ' ---->  [RouteAware] ---------> didPopNext: ${ModalRoute.of(context)?.settings.name}'
      ' ---->  ${getClassNameWithoutGenerics(widget)}',
    );
  }
}
