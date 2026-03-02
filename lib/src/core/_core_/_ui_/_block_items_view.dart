part of '../core.dart';

abstract class BlockItemsView<
    BLOCK extends Block<
        Object, //
        Identifiable,
        Identifiable,
        FilterInput,
        FilterCriteria,
        FormInput,
        FormRelatedData>> extends StatelessWidget {
  final BLOCK block;
  final QuickSuggestionMode quickSuggestionMode;
  final bool provideItemContext;
  final bool provideFormContext;

  const BlockItemsView({
    required this.block,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.provideItemContext = false,
    this.provideFormContext = false,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemsViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      provideItemContext: provideItemContext,
      provideFormContext: provideFormContext,
      quickSuggestionMode: quickSuggestionMode,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
