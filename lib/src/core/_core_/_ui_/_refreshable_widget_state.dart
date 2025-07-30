part of '../core.dart';

interface class IRefreshableWidgetState {
  ShowMode showMode = ShowMode.production;

  RefreshableWidgetType get type => throw UnimplementedError();

  String get locationInfo => throw UnimplementedError();

  String get description => throw UnimplementedError();

  void setState(Function() func) {}
}

abstract class _RefreshableWidgetState<W extends _RefreshableWidget>
    extends State<W> implements IRefreshableWidgetState {
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
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        addWidgetState(isShowing: visiblePercentage > 0);
      },
      child: showMode == ShowMode.production
          ? buildContent(context)
          : _DevContainer(
              child: buildContent(context),
            ),
    );
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
    super.dispose();
    //
    removeWidgetState();
    //
    checkAndFreeMemory();
  }
}
