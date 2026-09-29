part of '../../core.dart';

class TaskControlBar extends BaseControlBar<
    Task, //
    TaskControlBarItemType,
    TaskControlBarItem> {
  final Task task;
  final TaskControlBarConfig config;

  const TaskControlBar({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.task,
    this.config = const TaskControlBarConfig(),
    super.style,
    super.leftItems = const [
      TaskControlBarItem.standard(TaskControlBarItemType.back),
    ],
    super.rightItems = const [
      TaskControlBarItem.standard(TaskControlBarItemType.loadInitData),
      TaskControlBarItem.standard(TaskControlBarItemType.divider),
      TaskControlBarItem.standard(TaskControlBarItemType.submit),
    ],
  });

  @override
  State<StatefulWidget> createState() => _TaskControlBarState();
}

class _TaskControlBarState extends _BaseControlBarState<
    Task, //
    TaskControlBarItemType,
    TaskControlBarItem,
    TaskControlBar> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.controlBar;

  @override
  Shelf? _getRelatedShelf() => null;

  @override
  Activity? _getRelatedActivity() => widget.task.activity;

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
  bool get provideTaskContext => true;

  @override
  Widget? buildStandardButton(TaskControlBarItem item) {
    final type = item.type ?? TaskControlBarItemType.custom;

    switch (type) {
      case TaskControlBarItemType.back:
        if (!widget.config.allowBackButton) return null;
        return _buildButton(
          tooltip: "Back",
          iconData: FaIconConstants.formBackIconData,
          onPressed: Navigator.of(context).canPop()
              ? () => Navigator.of(context).maybePop()
              : null,
        );

      case TaskControlBarItemType.loadInitData:
        if (!widget.config.allowLoadInitDataButton) return null;
        return _buildButton(
          tooltip: "Load Init Data",
          iconData: FaIconConstants.formRefreshIconData,
          onAction: widget.task.isLoadingInitData,
          onPressed: () async {
            await widget.task.loadInitData();
          },
        );

      case TaskControlBarItemType.submit:
        if (!widget.config.allowSubmitButton) return null;
        // Submit is active only when INIT_DATA is loaded or task is ready
        final bool canSubmit = widget.task.dataState.isLoaded;
        return _buildButton(
          tooltip: "Submit",
          iconData: FaIconConstants.formSaveIconData,
          onAction: widget.task.isExecuting,
          onPressed: canSubmit
              ? () async {
                  if (widget.task.formModel != null) {
                    await widget.task.formModel!.submit();
                  } else {
                    await widget.task.performSubmit(
                      initData: widget.task.initData,
                      formData: null,
                    );
                  }
                }
              : null,
        );

      case TaskControlBarItemType.custom:
        return _buildButton(
          tooltip: item.tooltip ?? "Custom",
          iconData: item.iconData ?? CupertinoIcons.question_diamond,
          onPressed: item.onPressed == null
              ? null
              : () => item.onPressed!(widget.task, type),
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
  String getWidgetOwnerClassName() => getClassNameWithoutGenerics(widget.task);

  @override
  void addWidgetState({required bool isVisible}) =>
      widget.task.ui._addControlBarWidgetState(
        widgetState: this,
        isVisible: isVisible,
      );

  @override
  void removeWidgetState() =>
      widget.task.ui._removeControlBarWidgetState(widgetState: this);

  @override
  void checkAndFreeMemory() =>
      FlutterArtist.desk._checkToRemoveActivity(widget.task.activity);

  @override
  void executeAfterBuild() {}

  @override
  void setBuildingState({required bool isBuilding}) {}
}
