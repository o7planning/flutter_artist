part of '../../core.dart';

class ScalarControlBar extends BaseControlBar<
    Scalar, //
    ScalarControlBarItemType,
    ScalarControlBarItem> {
  final Scalar scalar;
  @override
  final ScalarControlBarConfig config;

  const ScalarControlBar({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.scalar,
    required this.config,
    super.style,
    //
    super.leftItems = const [
      ScalarControlBarItem.standard(ScalarControlBarItemType.back),
    ],
    super.rightItems = const [
      ScalarControlBarItem.standard(ScalarControlBarItemType.query),
      ScalarControlBarItem.standard(ScalarControlBarItemType.divider),
      ScalarControlBarItem.standard(
          ScalarControlBarItemType.debugFilterCriteria),
    ],
  });

  @override
  State<StatefulWidget> createState() => _ScalarControlBarState();
}

class _ScalarControlBarState extends _BaseControlBarState<
    Scalar, //
    ScalarControlBarItemType,
    ScalarControlBarItem,
    ScalarControlBar> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.controlBar;

  @override
  Shelf? _getRelatedModule() {
    return widget.scalar.shelf;
  }

  @override
  FocusRegionType getRegionType() {
    return FocusRegionType.controlBar;
  }

  @override
  String getUnitName() {
    return widget.scalar.name;
  }

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => widget.config.scalarContextType;

  @override
  ProzessViewContext? get prozessViewContext => null;

  @override
  StageViewContext? get stageViewContext => null;

  @override
  TaskViewContext? get taskViewContext => null;

  @override
  Widget? buildStandardButton(ScalarControlBarItem item) {
    final type = item.type ?? ScalarControlBarItemType.custom;
    switch (type) {
      case ScalarControlBarItemType.divider:
        return ControlBarHelper.buildDivider();

      case ScalarControlBarItemType.back:
        if (!widget.config.allowBackButton) return null;
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: type.formatTooltip("Back"),
          iconData: FaIconConstants.formBackIconData,
          onPressed: Navigator.of(context).canPop()
              ? () => Navigator.of(context).maybePop()
              : null,
        );
      case ScalarControlBarItemType.query:
        if (!widget.config.allowQueryButton) return null;
        final actionable = widget.scalar.checkBeforeQuery();
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: type.formatTooltip("Re Query"),
          iconData: FaIconConstants.formQueryIconData,
          onAction: widget.scalar.isQuerying,
          onPressed: actionable.yes ? () => widget.scalar.query() : null,
        );

      case ScalarControlBarItemType.debugFilterCriteria:
        if (!widget.config.allowDebugFilterCriteriaInspectorButton) return null;
        final actionable =
        widget.scalar.checkBeforeShowFilterCriteriaInspector();
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: type.formatTooltip("Debug Filter Criteria Inspector"),
          iconData: FaIconConstants.filterCriteriaIconData,
          onAction: false,
          onPressed: actionable.yes
              ? () async {
            await widget.scalar.showDebugFilterCriteriaViewerDialog();
          }
              : null,
        );

      case ScalarControlBarItemType.custom:
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: type.formatTooltip(item.tooltip ?? "Custom"),
          iconData: item.iconData ?? CupertinoIcons.question_diamond,
          onAction: widget.scalar.isQuerying,
          onPressed: item.onPressed == null
              ? null
              : () {
            item.onPressed!.call(widget.scalar, type);
          },
        );
    }
  }

  @override
  String getDebugLabel() {
    return "ScalarControlBar(${widget.scalar.name})";
  }

  @override
  bool hasError() {
    return widget.scalar.hasError;
  }

  @override
  String getWidgetOwnerClassName() =>
      getClassNameWithoutGenerics(widget.scalar);

  @override
  void addWidgetState({required bool isVisible}) =>
      widget.scalar.ui
          ._addControlBarWidgetState(widgetState: this, isVisible: isVisible);

  @override
  void removeWidgetState() =>
      widget.scalar.ui._removeControlBarWidgetState(widgetState: this);

  @override
  void checkAndFreeMemory() =>
      FlutterArtist.storage._checkToRemoveShelf(widget.scalar.shelf);

  @override
  void executeAfterBuild() {}

  @override
  void setBuildingState({required bool isBuilding}) {}
}
