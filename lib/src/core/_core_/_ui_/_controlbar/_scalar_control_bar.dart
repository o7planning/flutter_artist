part of '../../core.dart';

class ScalarControlBar
    extends BaseControlBar<Scalar, ScalarControlBarItemType> {
  final Scalar scalar;
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
      ControlBarItem<Scalar, ScalarControlBarItemType>.standard(
          ScalarControlBarItemType.back),
    ],
    super.rightItems = const [
      ControlBarItem.standard(ScalarControlBarItemType.query),
      ControlBarItem.standard(ScalarControlBarItemType.divider),
      ControlBarItem.standard(ScalarControlBarItemType.debugFilter),
    ],
  });

  @override
  State<StatefulWidget> createState() => _ScalarControlBarState();
}

class _ScalarControlBarState extends _BaseControlBarState<Scalar,
    ScalarControlBarItemType,
    ScalarControlBar> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.controlBar;

  @override
  bool get provideScalarContext => true;

  @override
  bool get provideBlockContext => false;

  @override
  bool get provideHookContext => false;

  @override
  bool get provideItemContext => false;

  @override
  bool get provideFormContext => false;

  @override
  Widget? buildStandardButton(ControlBarItem item) {
    Enum type = item.type ?? ScalarControlBarItemType.custom;
    switch (type) {
      case ScalarControlBarItemType.back:
        if (!widget.config.allowBackButton) return null;
        return _buildButton(
          tooltip: "Back",
          iconData: FaIconConstants.formBackIconData,
          onPressed: Navigator.of(context).canPop()
              ? () => Navigator.of(context).maybePop()
              : null,
        );

      case ScalarControlBarItemType.query:
        if (!widget.config.allowQueryButton) return null;
        final actionable = widget.scalar.canQuery();
        return _buildButton(
          tooltip: "Re Query",
          iconData: FaIconConstants.formQueryIconData,
          onAction: widget.scalar.isQuerying,
          onPressed: actionable.yes ? () => widget.scalar.query() : null,
        );

      case ScalarControlBarItemType.debugFilter:
        if (!widget.config.allowDebugFilterCriteriaInspectorButton) return null;
        bool show = widget.scalar.canShowFilterCriteria();
        return _buildButton(
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
        return _buildButton(
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

  Widget _buildButton({
    required String tooltip,
    required IconData iconData,
    bool onAction = false,
    required VoidCallback? onPressed,
    Color? customColor,
  }) {
    if (widget.style.buttonBuilder != null) {
      return widget.style.buttonBuilder!(
          context, iconData, onPressed, onAction, tooltip);
    }

    return _ControlBarButton(
      tooltip: tooltip,
      iconData: iconData,
      onAction: onAction,
      onPressed: onPressed,
      //
      iconColor: onPressed == null
          ? widget.style.disabledIconColor
          : (customColor ?? widget.style.activeIconColor),
    );
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
