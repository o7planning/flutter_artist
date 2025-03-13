part of '../flutter_artist.dart';

abstract class _RefreshableWidgetState<W extends _RefreshableWidget>
    extends State<W> {
  int _refreshCount = 0;
  ShowMode showMode = ShowMode.production;

  late final String keyId;

  bool _lockChangeEvent = false;

  RefreshableWidgetType get type;

  void setBuildingState({required bool isBuilding});

  void executeAfterBuild();

  void addWidgetState({required bool isShowing});

  void removeWidgetState();

  Widget buildContent(BuildContext context);

  String get locationInfo => getClassName(widget.ownerClassInstance);

  ///
  /// Class name of Owner (Block, FormModel, FilterModel).
  ///
  String getWidgetOwnerClassName();

  void checkAndFreeMemory();

  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "${getWidgetOwnerClassName()} (${type.name})"
        : widget.description!;
  }

  void refreshState({bool force = false}) {
    if (force) {
      setState(() {});
    } else {
      if (_refreshCount < FlutterArtist.storage._taskUnitCount) {
        _refreshCount = FlutterArtist.storage._taskUnitCount;
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
    this.setBuildingState(isBuilding: false);
    //
    executeAfterBuild();
  }

  @override
  void initState() {
    super.initState();
    //
    keyId = _generateVisibilityDetectorId(
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
