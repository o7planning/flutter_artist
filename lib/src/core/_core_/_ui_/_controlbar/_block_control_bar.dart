part of '../../core.dart';

class BlockControlBar extends BaseControlBar<Block,
    BlockControlBarItemType,
    BlockControlBarItem> {
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
      BlockControlBarItem.standard(BlockControlBarItemType.back),
      BlockControlBarItem.standard(BlockControlBarItemType.divider),
      BlockControlBarItem.standard(BlockControlBarItemType.create),
      BlockControlBarItem.standard(BlockControlBarItemType.edit),
      BlockControlBarItem.standard(BlockControlBarItemType.delete),
    ],
    super.rightItems = const [
      BlockControlBarItem.standard(BlockControlBarItemType.refresh),
      BlockControlBarItem.standard(BlockControlBarItemType.query),
      BlockControlBarItem.standard(BlockControlBarItemType.divider),
      BlockControlBarItem.standard(BlockControlBarItemType.save),
      BlockControlBarItem.standard(BlockControlBarItemType.reset),
      BlockControlBarItem.standard(BlockControlBarItemType.divider),
      BlockControlBarItem.standard(BlockControlBarItemType.debugFilter),
      BlockControlBarItem.standard(BlockControlBarItemType.debugForm),
      // BlockControlBarItem.custom(
      //   tooltip: '',
      //   iconData: Icons.eighteen_mp,
      //   onPressed: (Block owner, BlockControlBarItemType itemType) {
      //     throw UnimplementError();
      //   },
      // ),
    ],
  });

  @override
  State<StatefulWidget> createState() => _BlockControlBarState();
}

class _BlockControlBarState extends _BaseControlBarState<
    Block, //
    BlockControlBarItemType,
    BlockControlBarItem,
    BlockControlBar> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.controlBar;

  @override
  Shelf? _getRelatedShelf() {
    return widget.block.shelf;
  }

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
  Widget? buildStandardButton(BlockControlBarItem item) {
    final type = item.type ?? BlockControlBarItemType.custom;
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
            final result = await widget.block.prepareFormToCreateItem();
            // widget.config.onNavigateCreate?.call(result);
            final NavigationIntent? intent =
                widget.config.createNavigationIntent;
            if (intent != null) {
              widget.block._processNavigationIntent(
                context: context,
                result: result,
                intent: intent,
              );
            }
          }
              : null,
        );
      case BlockControlBarItemType.edit:
        if (widget.block.formModel == null || !widget.config.allowEditButton) {
          return null;
        }
        final actionable = widget.block.canEditCurrentItemWithForm();
        return _buildButton(
          tooltip: "Edit",
          iconData: FaIconConstants.formEditIconData,
          onAction: widget.block.isRefreshingCurrentItem,
          onPressed: actionable.yes
              ? () async {
            final result =
            await widget.block._prepareFormToEditCurrentItem();
            //
            final NavigationIntent? intent =
                widget.config.editNavigationIntent;
            if (intent != null) {
              widget.block._processNavigationIntent(
                context: context,
                result: result,
                intent: intent,
              );
            }
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
            // widget.config.onNavigateDelete?.call(result);
            final NavigationIntent? intent =
                widget.config.deleteNavigationIntent;
            if (intent != null) {
              widget.block._processNavigationIntent(
                context: context,
                result: result,
                intent: intent,
              );
            }
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
            // widget.config.onNavigateSave?.call(result);
            final NavigationIntent? intent =
                widget.config.saveNavigationIntent;
            if (intent != null) {
              widget.block._processNavigationIntent(
                context: context,
                result: result,
                intent: intent,
              );
            }
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
