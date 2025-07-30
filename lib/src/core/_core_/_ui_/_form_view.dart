part of '../core.dart';

abstract class FormView<FORM_MODEL extends FormModel> extends StatelessWidget {
  final FORM_MODEL formModel;
  final QuickSuggestionMode quickSuggestionMode;

  const FormView({
    required this.formModel,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return FormViewBuilder(
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
