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
  Activity? _getRelatedActivity() {
    return null;
  }

  @override
  bool get provideScalarContext {
    return false;
  }

  @override
  bool get provideBlockContext {
    return false;
  }

  @override
  bool get provideItemContext {
    return false;
  }

  @override
  bool get provideFormContext {
    return false;
  }

  @override
  bool get provideStageContext {
    return false;
  }

  @override
  bool get provideTaskContext {
    return false;
  }

  @override
  Widget? buildStandardButton(FilterControlBarItem item) {
    Enum type = item.type ?? FilterControlBarItemType.custom;
    switch (type) {
      case FilterControlBarItemType.back:
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
      case FilterControlBarItemType.debugFilter:
        if (!widget.config.allowDebugFilterModelInspectorButton) {
          return null;
        }
        // widget.filterModel.canShowFilterModelCriteria()
        // bool show = true;
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
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


  @override
  String getWidgetOwnerClassName() =>
      getClassNameWithoutGenerics(widget.filterModel);

  @override
  void addWidgetState({required bool isVisible}) =>
      widget.filterModel.ui
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
