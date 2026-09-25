part of '../core.dart';

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
  Shelf? _getRelatedShelf() {
    return null;
  }

  @override
  Activity? _getRelatedActivity() {
    return widget.formModel.task.activity;
  }

  @override
  bool get provideBlockContext => false;

  @override
  bool get provideStageContext => false;

  @override
  bool get provideTaskContext => true;

  @override
  Future<bool> handleSaveOnPop() async {
    final TaskExecutionResult result = await widget.formModel.submit();
    return result.precheck == null && result.successForFirst;
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.desk._checkToRemoveActivity(widget.formModel.task.activity);
  }
}
