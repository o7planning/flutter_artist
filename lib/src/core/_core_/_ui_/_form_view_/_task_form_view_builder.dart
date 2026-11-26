part of '../../core.dart';

class TaskFormViewBuilder extends BaseFormViewBuilder<TaskFormModel> {
  @override
  final TaskFormViewConfig config;

  const TaskFormViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required super.formModel,
    required super.build,
    required TaskFormViewConfig? config,
  }) : config = config ?? const TaskFormViewConfig();

  @override
  State<StatefulWidget> createState() {
    return _TaskFormViewBuilderState();
  }
}

class _TaskFormViewBuilderState
    extends _BaseFormViewBuilderState<TaskFormViewBuilder, TaskFormModel> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.taskView;

  @override
  Activity? _getRelatedModule() {
    return widget.formModel.task.activity;
  }

  @override
  FocusRegionType getRegionType() {
    return FocusRegionType.taskFormView;
  }

  @override
  String getUnitName() {
    return widget.formModel.task.name;
  }

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  ProzessViewContext? get prozessViewContext => null;

  @override
  StageViewContext? get stageViewContext => null;

  @override
  TaskViewContext? get taskViewContext => TaskViewContext.form;

  @override
  LovViewContext? get lovViewContext => null;

  @override
  Future<bool> handleSaveOnPop() async {
    throw UnimplementedError("TODO: handleSaveOnPop");
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage.desk
        ._checkToRemoveActivity(widget.formModel.task.activity);
  }

  @override
  KeyEventResult handleFormMnemonicKeyEvent(
    BuildContext context,
    KeyEvent event,
  ) {
    return _TaskMnemonicHandler.handleKeyEvent(
      context: context,
      task: widget.formModel.task,
      screenNavigationContext: widget.config.screenNavigationContext,
      event: event,
    );
  }

  @override
  String getDebugLabel() {
    return "TaskFormView(${widget.formModel.name})";
  }

  @override
  bool hasError() {
    return widget.formModel.hasError;
  }

  @override
  List<_QuickSuggestionButton> createQuickSuggestionButtons(
      BuildContext context) {
    return [
      QuickSuggestionBarUtils.createTaskFormModelErrorButton(
        context,
        widget.formModel,
      ),
    ];
  }
}
