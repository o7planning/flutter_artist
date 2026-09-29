part of '../../core.dart';

class ProzessControlBar extends BaseControlBar<
    Prozess, //
    ProzessControlBarItemType,
    ProzessControlBarItem> {
  final Prozess prozess;
  final ProzessControlBarConfig config;

  const ProzessControlBar({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.prozess,
    this.config = const ProzessControlBarConfig(),
    super.style,
    super.leftItems = const [
      ProzessControlBarItem.standard(ProzessControlBarItemType.back),
      ProzessControlBarItem.standard(ProzessControlBarItemType.divider),
      ProzessControlBarItem.standard(ProzessControlBarItemType.cancel),
    ],
    super.rightItems = const [
      ProzessControlBarItem.standard(ProzessControlBarItemType.reset),
      ProzessControlBarItem.standard(ProzessControlBarItemType.divider),
      ProzessControlBarItem.standard(ProzessControlBarItemType.debugInspector),
    ],
  });

  @override
  State<StatefulWidget> createState() => _ProzessControlBarState();
}

class _ProzessControlBarState extends _BaseControlBarState<Prozess,
    ProzessControlBarItemType,
    ProzessControlBarItem,
    ProzessControlBar> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.controlBar;

  @override
  Shelf? _getRelatedShelf() => null;

  @override
  Activity? _getRelatedActivity() => widget.prozess.activity;

  @override
  bool get provideScalarContext => false;

  @override
  bool get provideBlockContext => false;

  @override
  bool get provideItemContext => false;

  @override
  bool get provideFormContext => false;

  @override
  bool get provideStageContext => false;

  @override
  bool get provideTaskContext => false;

  @override
  Widget? buildStandardButton(ProzessControlBarItem item) {
    final type = item.type ?? ProzessControlBarItemType.custom;

    switch (type) {
      case ProzessControlBarItemType.back:
        if (!widget.config.allowBackButton) return null;
        // If history exists, step back internally in the pipeline; otherwise pop the screen.
        final bool canStepBack = widget.prozess.stageHistory.isNotEmpty;
        return _buildButton(
          tooltip: canStepBack ? "Previous Stage" : "Back",
          iconData: FaIconConstants.formBackIconData,
          onPressed: () async {
            if (canStepBack) {
              await widget.prozess.stageBack();
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).maybePop();
            }
          },
        );

      case ProzessControlBarItemType.cancel:
        if (!widget.config.allowCancelButton) return null;
        return _buildButton(
          tooltip: "Cancel Prozess",
          iconData: Icons.cancel_outlined,
          customColor: widget.style.deleteIconColor,
          onPressed: () async {
            widget.prozess.reset();
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).maybePop();
            }
          },
        );

      case ProzessControlBarItemType.reset:
        if (!widget.config.allowResetButton) return null;
        return _buildButton(
          tooltip: "Reset All Stages",
          iconData: FaIconConstants.formCleanIconData,
          onPressed: () {
            widget.prozess.reset();
          },
        );

      case ProzessControlBarItemType.debugInspector:
        if (!widget.config.allowDebugInspectorButton) return null;
        return _buildButton(
          tooltip: "Inspect Prozess Context",
          iconData: Icons.account_tree_outlined,
          onPressed: () {
            widget.prozess.showDebugContextDataViewerDialog(context);
          },
        );

      case ProzessControlBarItemType.custom:
        return _buildButton(
          tooltip: item.tooltip ?? "Custom",
          iconData: item.iconData ?? CupertinoIcons.question_diamond,
          onPressed: item.onPressed == null
              ? null
              : () => item.onPressed!(widget.prozess, type),
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
        context,
        iconData,
        onPressed,
        onAction,
        tooltip,
      );
    }

    return _ControlBarButton(
      tooltip: tooltip,
      iconData: iconData,
      onAction: onAction,
      onPressed: onPressed,
      iconColor: onPressed == null
          ? widget.style.disabledIconColor
          : (customColor ?? widget.style.activeIconColor),
    );
  }

  @override
  String getWidgetOwnerClassName() =>
      getClassNameWithoutGenerics(widget.prozess);

  @override
  void addWidgetState({required bool isVisible}) =>
      widget.prozess.ui._addControlBarWidgetState(
        widgetState: this,
        isVisible: isVisible,
      );

  @override
  void removeWidgetState() =>
      widget.prozess.ui._removeControlBarWidgetState(widgetState: this);

  @override
  void checkAndFreeMemory() =>
      FlutterArtist.desk._checkToRemoveActivity(widget.prozess.activity);

  @override
  void executeAfterBuild() {}

  @override
  void setBuildingState({required bool isBuilding}) {}
}
