part of '../core.dart';

abstract class StageFormView<
    STAGE_FORM_MODEL extends StageFormModel<
        Enum, //
        StageData,
        FlowContextData,
        FormInput,
        AdditionalFormRelatedData>> extends StatelessWidget {
  final STAGE_FORM_MODEL formModel;
  final QuickSuggestionMode quickSuggestionMode;

  const StageFormView({
    required this.formModel,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return StageFormViewBuilder(
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
