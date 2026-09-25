part of '../core.dart';

abstract class BlockFormView<
    BLOCK_FORM_MODEL extends BlockFormModel<
        Comparable, //
        Identifiable<Comparable>,
        FormInput,
        AdditionalFormRelatedData>> extends StatelessWidget {
  final BLOCK_FORM_MODEL formModel;
  final QuickSuggestionMode quickSuggestionMode;

  const BlockFormView({
    required this.formModel,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockFormViewBuilder(
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
