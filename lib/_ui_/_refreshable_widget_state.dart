part of '../flutter_artist.dart';

abstract class _RefreshableWidgetState<W extends _RefreshableWidget>
    extends State<W> {
  ShowMode showMode = ShowMode.production;

  late final String keyId;

  RefreshableWidgetType get type;

  void addFilterFragmentWidgetState({required bool isShowing});

  void removeFilterFragmentWidgetState();

  Widget buildContent(BuildContext context);

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  ///
  /// Class name of Owner (Block, BlockForm, DataFilter).
  ///
  String getWidgetOwnerClassName();

  void checkAndFreeMemory();

  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "${getWidgetOwnerClassName()} (${type.name})"
        : widget.description!;
  }

  void refreshState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(keyId),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        addFilterFragmentWidgetState(isShowing: visiblePercentage > 0);
      },
      child: showMode == ShowMode.production
          ? buildContent(context)
          : _DevContainer(
              child: buildContent(context),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    //
    keyId = _generateVisibilityDetectorId(
        prefix: "${type.toString()}-${getWidgetOwnerClassName()}");
    //
    addFilterFragmentWidgetState(isShowing: true);
  }

  @override
  void dispose() {
    super.dispose();
    //
    removeFilterFragmentWidgetState();
    //
    checkAndFreeMemory();
  }
}
