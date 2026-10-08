part of '../../core.dart';

class TaskFormViewBuilder extends BaseFormViewBuilder<TaskFormModel> {
  const TaskFormViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required super.formModel,
    required super.build,
    super.quickSuggestionMode = QuickSuggestionMode.showIfError,
  });

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
  Future<bool> handleSaveOnPop() async {
    // final TaskSubmitExecutionResult result =
    //     await widget.formModel.task.submit();
    // return result.precheck == null && result.successForFirst;
    throw UnimplementedError("TODO: handleSaveOnPop");
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.desk._checkToRemoveActivity(widget.formModel.task.activity);
  }
}
