part of '../../core.dart';

class ProzessControlBar extends BaseControlBar<
    Prozess, //
    ProzessControlBarItemType,
    ProzessControlBarItem> {
  final Prozess prozess;
  final ProzessControlBarConfig config;

  final ProzessViewContext prozessViewContext;

  const ProzessControlBar({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.prozess,
    this.config = const ProzessControlBarConfig(),
    this.prozessViewContext = ProzessViewContext.initData,
    super.style,
    super.leftItems = const [
      ProzessControlBarItem.standard(ProzessControlBarItemType.back),
      ProzessControlBarItem.standard(ProzessControlBarItemType.divider),
      ProzessControlBarItem.standard(ProzessControlBarItemType.cancel),
      ProzessControlBarItem.standard(ProzessControlBarItemType.divider),
      ProzessControlBarItem.standard(
          ProzessControlBarItemType.moveToPreviousStage),
      ProzessControlBarItem.standard(ProzessControlBarItemType.moveToNextStage),
      ProzessControlBarItem.standard(ProzessControlBarItemType.divider),
      ProzessControlBarItem.standard(ProzessControlBarItemType.restartProzess),
    ],
    super.rightItems = const [
      ProzessControlBarItem.standard(
          ProzessControlBarItemType.restartViewingStage),
      ProzessControlBarItem.standard(
          ProzessControlBarItemType.submitViewingStage),
      ProzessControlBarItem.standard(ProzessControlBarItemType.divider),
      ProzessControlBarItem.standard(
          ProzessControlBarItemType.debugViewingStageForm),
      ProzessControlBarItem.standard(ProzessControlBarItemType.debugInspector),
    ],
  });

  @override
  State<StatefulWidget> createState() => _ProzessControlBarState();
}

class _ProzessControlBarState extends _BaseControlBarState<Prozess,
    ProzessControlBarItemType, ProzessControlBarItem, ProzessControlBar> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.controlBar;

  @override
  Activity? _getRelatedModule() => widget.prozess.activity;

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  ProzessViewContext? get prozessViewContext => widget.prozessViewContext;

  @override
  StageViewContext? get stageViewContext => null;

  @override
  TaskViewContext? get taskViewContext => null;

  @override
  Widget? buildStandardButton(ProzessControlBarItem item) {
    final type = item.type ?? ProzessControlBarItemType.custom;

    switch (type) {
      case ProzessControlBarItemType.divider:
        return ControlBarHelper.buildDivider();

      case ProzessControlBarItemType.back:
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

      case ProzessControlBarItemType.cancel:
        if (!widget.config.allowCancelButton) return null;
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Cancel Prozess",
          iconData: Icons.cancel_outlined,
          customColor: widget.style.deleteIconColor,
          onPressed: () async {
            widget.prozess.cancel();
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).maybePop();
            }
          },
        );

      case ProzessControlBarItemType.moveToPreviousStage:
        if (!widget.config.allowMoveToPreviousStageButton) return null;
        bool canMove = widget.prozess.canMoveToPreviousStage();
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Move to Previous Stage",
          iconData: FaIconConstants.stagePreviousIconData,
          customColor: widget.style.activeIconColor,
          onPressed: canMove
              ? () async {
                  widget.prozess.moveToPreviousStage();
                }
              : null,
        );
      case ProzessControlBarItemType.moveToNextStage:
        if (!widget.config.allowMoveToNextStageButton) return null;
        bool canMove = widget.prozess.canMoveToNextStage();
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Move to Next Stage",
          iconData: FaIconConstants.stageNextIconData,
          customColor: widget.style.activeIconColor,
          onPressed: canMove
              ? () async {
                  widget.prozess.moveToNextStage();
                }
              : null,
        );
      case ProzessControlBarItemType.restartProzess:
        if (!widget.config.allowResetButton) return null;
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Restart Prozess",
          iconData: FaIconConstants.prozessStartIconData,
          onPressed: () async {
            await widget.prozess.restart();
          },
        );

      case ProzessControlBarItemType.restartViewingStage:
        if (!widget.config.allowLoadStageInitDataButton) return null;
        Actionable actionable = widget.prozess.checkBeforeViewingStageRestart();
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Restart Viewing Stage",
          iconData: FaIconConstants.formRefreshIconData,
          onPressed: actionable.yes
              ? () {
                  widget.prozess.restartViewingStage();
                }
              : null,
        );

      case ProzessControlBarItemType.submitViewingStage:
        if (!widget.config.allowSubmitStageButton) return null;
        Actionable actionable = widget.prozess.checkBeforeViewingStageSubmit(
          // IMPORTANT: `checkValidate:false` to avoid error:
          // - setState() or markNeedsBuild() called during build.
          checkValidate: false,
        );
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Submit Viewing Stage",
          iconData: FaIconConstants.submitIconData,
          onPressed: actionable.yes
              ? () {
                  widget.prozess.submitViewingStage();
                }
              : null,
        );

      case ProzessControlBarItemType.debugViewingStageForm:
        if (!widget.config.allowDebugFormButton) return null;
        Actionable actionable = widget.prozess.checkBeforeShowFormInfo();
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Debug Form Model Inspector",
          iconData: FaIconConstants.formIconData,
          onAction: false,
          onPressed: actionable.yes
              ? () async {
                  await widget.prozess
                      .showViewingStageFormModelInspectorDialog();
                }
              : null,
        );

      case ProzessControlBarItemType.debugInspector:
        if (!widget.config.allowDebugInspectorButton) return null;
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Inspect Prozess Context",
          iconData: FaIconConstants.prozessIconData,
          onPressed: () {
            widget.prozess.showDebugContextDataViewerDialog(context);
          },
        );

      case ProzessControlBarItemType.custom:
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
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
