part of '../core.dart';

abstract class TaskFormView<
TASK_FORM_MODEL extends TaskFormModel<
    TaskData, //
    FormInput,
    AdditionalFormRelatedData>> extends StatelessWidget {
  final TASK_FORM_MODEL formModel;
  final QuickSuggestionMode quickSuggestionMode;

  const TaskFormView({
    required this.formModel,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return TaskFormViewBuilder(
      ownerClassInstance: this,
      description: '',
      formModel: formModel,
      quickSuggestionMode: quickSuggestionMode,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
