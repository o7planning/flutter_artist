part of '../../core.dart';

abstract class TaskFormView<
    TASK_FORM_MODEL extends TaskFormModel<
        TaskInitData, //
        TaskResultData,
        FormPatch,
        FormOutput,
        AdditionalFormRelatedData>> extends StatelessWidget {
  final TASK_FORM_MODEL formModel;
  final TaskFormViewConfig config;

  const TaskFormView({
    required this.formModel,
    required TaskFormViewConfig? config,
    super.key,
  }) : config = config ?? const TaskFormViewConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return TaskFormViewBuilder(
      ownerClassInstance: this,
      description: '',
      formModel: formModel,
      config: config,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
