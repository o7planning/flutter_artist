part of '../../core.dart';

abstract class TaskView<
    TASK extends Task<
        TaskInitData, //
        TaskResultData,
        FormPatch,
        FormOutput>> extends StatelessWidget {
  final TASK task;
  final TaskViewConfig config;

  const TaskView({
    required this.task,
    required TaskViewConfig? config,
    super.key,
  }) : config = config ?? const TaskViewConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return TaskViewBuilder(
      ownerClassInstance: this,
      description: '',
      task: task,
      config: config,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
