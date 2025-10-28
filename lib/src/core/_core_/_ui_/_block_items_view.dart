part of '../core.dart';

abstract class BlockItemsView<
    BLOCK extends Block<
        Object, //
        Identifiable,
        Identifiable,
        FilterInput,
        FilterCriteria,
        ExtraFormInput>> extends StatelessWidget {
  final BLOCK block;
  final QuickSuggestionMode quickSuggestionMode;

  const BlockItemsView({
    required this.block,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemsViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      quickSuggestionMode: quickSuggestionMode,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
