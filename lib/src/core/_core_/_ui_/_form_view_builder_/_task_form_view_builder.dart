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
  Activity? _getRelatedShelf() {
    return widget.formModel.task.activity;
  }


  @override
  BlockContextType? get blockContextType => null;

  @override
  ScalarContextType? get scalarContextType => null;

  @override
  StageContextType? get stageContextType => null;

  @override
  TaskContextType? get taskContextType => TaskContextType.form;


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
