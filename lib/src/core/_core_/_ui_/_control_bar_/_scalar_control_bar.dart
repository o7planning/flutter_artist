part of '../../core.dart';

class ScalarControlBar extends BaseControlBar<
    Scalar, //
    ScalarControlBarItemType,
    ScalarControlBarItem> {
  final Scalar scalar;
  final ScalarControlBarConfig config;
  final ScalarContextType? scalarContextType;

  const ScalarControlBar({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.scalar,
    required this.config,
    this.scalarContextType = ScalarContextType.value,
    super.style,
    //
    super.leftItems = const [
      ScalarControlBarItem.standard(ScalarControlBarItemType.back),
    ],
    super.rightItems = const [
      ScalarControlBarItem.standard(ScalarControlBarItemType.query),
      ScalarControlBarItem.standard(ScalarControlBarItemType.divider),
      ScalarControlBarItem.standard(ScalarControlBarItemType.debugFilter),
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
  Shelf? _getRelatedShelf() {
    return widget.scalar.shelf;
  }


  @override
  BlockContextType? get blockContextType => null;

  @override
  ScalarContextType? get scalarContextType => widget.scalarContextType;

  @override
  StageContextType? get stageContextType => null;

  @override
  TaskContextType? get taskContextType => null;

  @override
  Widget? buildStandardButton(ScalarControlBarItem item) {
    final type = item.type ?? ScalarControlBarItemType.custom;
    switch (type) {
      case ScalarControlBarItemType.back:
        if (!widget.config.allowBackButton) return null;
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Back",
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
          tooltip: "Re Query",
          iconData: FaIconConstants.formQueryIconData,
          onAction: widget.scalar.isQuerying,
          onPressed: actionable.yes ? () => widget.scalar.query() : null,
        );

      case ScalarControlBarItemType.debugFilter:
        if (!widget.config.allowDebugFilterCriteriaInspectorButton) return null;
        bool show = widget.scalar.canShowFilterCriteria();
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Debug Filter Criteria Inspector",
          iconData: FaIconConstants.filterCriteriaIconData,
          onAction: false,
          onPressed: show
              ? () {
                  DebugViewerDialog.openDebugFilterCriteriaInspector(
                    context: context,
                    locationInfo: '',
                    filterModel: widget.scalar.registeredOrDefaultFilterModel,
                  );
                }
              : null,
        );

      case ScalarControlBarItemType.custom:
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: item.tooltip ?? "Custom",
          iconData: item.iconData ?? CupertinoIcons.question_diamond,
          onAction: widget.scalar.isQuerying,
          onPressed: item.onPressed == null
              ? null
              : () {
                  item.onPressed!.call(widget.scalar, type);
                },
        );
      default:
        return null;
    }
  }

  @override
  String getWidgetOwnerClassName() =>
      getClassNameWithoutGenerics(widget.scalar);

  @override
  void addWidgetState({required bool isVisible}) => widget.scalar.ui
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
