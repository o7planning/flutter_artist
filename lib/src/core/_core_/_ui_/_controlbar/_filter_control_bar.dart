part of '../../core.dart';

class FilterControlBar extends BaseControlBar<
    FilterModel, //
    FilterControlBarItemType,
    FilterControlBarItem> {
  final FilterModel filterModel;
  final FilterControlBarConfig config;

  const FilterControlBar({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.filterModel,
    required this.config,
    super.style,
    //
    super.leftItems = const [
      FilterControlBarItem.standard(FilterControlBarItemType.back),
    ],
    super.rightItems = const [
      FilterControlBarItem.standard(FilterControlBarItemType.divider),
      FilterControlBarItem.standard(FilterControlBarItemType.debugFilter),
    ],
  });

  @override
  State<StatefulWidget> createState() => _FilterControlBarState();
}

class _FilterControlBarState extends _BaseControlBarState<
    FilterModel, //
    FilterControlBarItemType,
    FilterControlBarItem,
    FilterControlBar> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.controlBar;

  @override
  Shelf? _getRelatedShelf() {
    return widget.filterModel.shelf;
  }

  @override
  bool get provideScalarContext => false;

  @override
  bool get provideBlockContext => false;

  @override
  bool get provideHookContext => false;

  @override
  bool get provideItemContext => false;

  @override
  bool get provideFormContext => false;

  @override
  Widget? buildStandardButton(FilterControlBarItem item) {
    Enum type = item.type ?? FilterControlBarItemType.custom;
    switch (type) {
      case FilterControlBarItemType.back:
        if (!widget.config.allowBackButton) return null;
        return _buildButton(
          tooltip: "Back",
          iconData: FaIconConstants.formBackIconData,
          onPressed: Navigator.of(context).canPop()
              ? () => Navigator.of(context).maybePop()
              : null,
        );
      case FilterControlBarItemType.debugFilter:
        if (!widget.config.allowDebugFilterModelInspectorButton) {
          return null;
        }
        // widget.filterModel.canShowFilterModelCriteria()
        // bool show = true;
        return _buildButton(
          tooltip: "Debug Filter Model Inspector",
          iconData: FaIconConstants.filterModelDebugIconData,
          onAction: false,
          onPressed: () {
            DebugViewerDialog.openDebugFilterModelInspector(
              context: context,
              locationInfo: '',
              filterModel: widget.filterModel,
            );
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
      getClassNameWithoutGenerics(widget.filterModel);

  @override
  void addWidgetState({required bool isVisible}) => widget.filterModel.ui
      ._addControlBarWidgetState(widgetState: this, isVisible: isVisible);

  @override
  void removeWidgetState() =>
      widget.filterModel.ui._removeControlBarWidgetState(widgetState: this);

  @override
  void checkAndFreeMemory() =>
      FlutterArtist.storage._checkToRemoveShelf(widget.filterModel.shelf);

  @override
  void executeAfterBuild() {}

  @override
  void setBuildingState({required bool isBuilding}) {}
}
