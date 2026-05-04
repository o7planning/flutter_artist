part of '../../core.dart';

class BlockControlBar extends BaseControlBar<Block, BlockControlBarItemType> {
  final Block block;
  final BlockControlBarConfig config;

  const BlockControlBar({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.block,
    required this.config,
    super.style,
    //
    super.leftItems = const [
      ControlBarItem.standard(BlockControlBarItemType.back),
      ControlBarItem.standard(BlockControlBarItemType.divider),
      ControlBarItem.standard(BlockControlBarItemType.create),
      ControlBarItem.standard(BlockControlBarItemType.delete),
    ],
    super.rightItems = const [
      ControlBarItem.standard(BlockControlBarItemType.refresh),
      ControlBarItem.standard(BlockControlBarItemType.query),
      ControlBarItem.standard(BlockControlBarItemType.divider),
      ControlBarItem.standard(BlockControlBarItemType.save),
      ControlBarItem.standard(BlockControlBarItemType.reset),
      ControlBarItem.standard(BlockControlBarItemType.divider),
      ControlBarItem.standard(BlockControlBarItemType.debugFilter),
      ControlBarItem.standard(BlockControlBarItemType.debugForm),
      // ControlBarItem.custom(
      //   tooltip: '',
      //   iconData: Icons.eighteen_mp,
      //   onPressed: (Block owner, ControlBarItemType itemType) {
      //     throw UnimplementError();
      //   },
      // ),
    ],
  });

  @override
  State<StatefulWidget> createState() => _BlockControlBarState();
}

class _BlockControlBarState extends _BaseControlBarState<Block,
    BlockControlBarItemType,
    BlockControlBar> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.controlBar;

  @override
  bool get provideBlockContext => true;

  @override
  bool get provideScalarContext => false;

  @override
  bool get provideHookContext => false;

  @override
  bool get provideItemContext =>
      widget.block.formModel != null && widget.config.allowSaveButton;

  @override
  bool get provideFormContext =>
      widget.block.formModel != null && widget.config.allowSaveButton;

  @override
  Widget? buildStandardButton(ControlBarItem item) {
    Enum type = item.type ?? BlockControlBarItemType.custom;
    switch (type) {
      case BlockControlBarItemType.back:
        if (!widget.config.allowBackButton) return null;
        return _buildButton(
          tooltip: "Back",
          iconData: FaIconConstants.formBackIconData,
          onPressed: Navigator.of(context).canPop()
              ? () => Navigator.of(context).maybePop()
              : null,
        );

      case BlockControlBarItemType.create:
        if (widget.block.formModel == null ||
            !widget.config.allowCreateButton) {
          return null;
        }
        final actionable = widget.block.canCreateItemWithForm();
        return _buildButton(
          tooltip: "Create",
          iconData: FaIconConstants.formCreateIconData,
          onAction: widget.block.isPreparingFormCreation,
          onPressed: actionable.yes
              ? () async {
            final result = await widget.block
                .prepareFormToCreateItem(navigate: null);
            widget.config.onNavigateCreate?.call(result);
          }
              : null,
        );

      case BlockControlBarItemType.delete:
        if (!widget.config.allowDeleteButton) return null;
        final actionable = widget.block.canDeleteCurrentItem();
        return _buildButton(
          tooltip: "Delete",
          iconData: FaIconConstants.formDeleteIconData,
          customColor: actionable.yes ? widget.style.deleteIconColor : null,
          onAction: widget.block.isDeleting,
          onPressed: actionable.yes
              ? () async {
            final result = await widget.block.deleteCurrentItem();
            widget.config.onNavigateDelete?.call(result);
          }
              : null,
        );

      case BlockControlBarItemType.save:
        if (widget.block.formModel == null || !widget.config.allowSaveButton) {
          return null;
        }
        final actionable = widget.block.canSaveForm();
        return _buildButton(
          tooltip: "Save",
          iconData: FaIconConstants.formSaveIconData,
          onAction: widget.block.__isSaving,
          onPressed: actionable.yes
              ? () async {
            final result = await widget.block.formModel!.saveForm();
            widget.config.onNavigateSave?.call(result);
          }
              : null,
        );

      case BlockControlBarItemType.refresh:
        if (!widget.config.allowRefreshButton) return null;
        final actionable = widget.block.canRefreshCurrentItem();
        return _buildButton(
          tooltip: "Refresh Current Item",
          iconData: FaIconConstants.formRefreshIconData,
          onAction: widget.block.isRefreshingCurrentItem,
          onPressed:
          actionable.yes ? () => widget.block.refreshCurrentItem() : null,
        );

      case BlockControlBarItemType.reset:
        if (widget.block.formModel == null || !widget.config.allowSaveButton) {
          return null;
        }
        final actionable = widget.block.canResetForm();
        return _buildButton(
          tooltip: "Reset Form",
          iconData: FaIconConstants.formCleanIconData,
          onPressed:
          actionable.yes ? () => widget.block.formModel?.resetForm() : null,
        );

      case BlockControlBarItemType.query:
        if (!widget.config.allowQueryButton) return null;
        final actionable = widget.block.canQuery();
        return _buildButton(
          tooltip: "Re Query",
          iconData: FaIconConstants.formQueryIconData,
          onAction: widget.block.isQuerying,
          onPressed: actionable.yes ? () => widget.block.query() : null,
        );

      case BlockControlBarItemType.debugFilter:
        if (!widget.config.allowDebugFilterCriteriaInspectorButton) return null;
        bool show = widget.block.canShowFilterCriteria();
        return _buildButton(
          tooltip: "Debug Filter Criteria Inspector",
          iconData: FaIconConstants.filterCriteriaIconData,
          onAction: false,
          onPressed: show
              ? () {
            DebugViewerDialog.openDebugFilterCriteriaInspector(
              context: context,
              locationInfo: '',
              filterModel: widget.block.registeredOrDefaultFilterModel,
            );
          }
              : null,
        );

      case BlockControlBarItemType.debugForm:
        if (!widget.config.allowDebugFormModelInspectorButton) return null;
        Actionable actionable = widget.block.canShowFormInfo();
        return _buildButton(
          tooltip: "Debug Form Model Inspector",
          iconData: FaIconConstants.formIconData,
          onAction: false,
          onPressed: actionable.yes
              ? () {
            DebugFormModelInspectorDialog.open(
              context: context,
              locationInfo:
              getClassNameWithoutGenerics(widget.ownerClassInstance),
              formModel: widget.block.formModel!,
            );
          }
              : null,
        );

      case BlockControlBarItemType.custom:
        return _buildButton(
          tooltip: item.tooltip ?? "Custom",
          iconData: item.iconData ?? CupertinoIcons.question_diamond,
          onAction: false,
          onPressed: item.onPressed == null
              ? null
              : () {
            item.onPressed!.call(widget.block, type);
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
  String getWidgetOwnerClassName() => getClassNameWithoutGenerics(widget.block);

  @override
  void addWidgetState({required bool isVisible}) =>
      widget.block.ui
          ._addControlBarWidgetState(widgetState: this, isVisible: isVisible);

  @override
  void removeWidgetState() =>
      widget.block.ui._removeControlBarWidgetState(widgetState: this);

  @override
  void checkAndFreeMemory() =>
      FlutterArtist.storage._checkToRemoveShelf(widget.block.shelf);

  @override
  void executeAfterBuild() {}

  @override
  void setBuildingState({required bool isBuilding}) {}
}
