part of '../core.dart';

abstract class TaskView<TASK extends Task<TaskInitData, CreationPreset, FormInput>>
    extends StatelessWidget {
  final TASK task;
  final QuickSuggestionMode quickSuggestionMode;

  const TaskView({
    required this.task,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return TaskViewBuilder(
      ownerClassInstance: this,
      description: '',
      task: task,
      quickSuggestionMode: quickSuggestionMode,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
