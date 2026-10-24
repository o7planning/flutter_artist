part of '../../core.dart';

abstract class BlockItemsView<
    BLOCK extends Block<
        Comparable, //
        Identifiable<Comparable>,
        Identifiable<Comparable>,
        FilterInput,
        FilterCriteria,
        CreationPreset,
        FormInput>> extends StatelessWidget {
  final BLOCK block;
  final QuickSuggestionMode quickSuggestionMode;
  final BlockViewContext blockViewContext;

  const BlockItemsView({
    required this.block,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.blockViewContext = BlockViewContext.items,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemsViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      blockViewContext: blockViewContext,
      quickSuggestionMode: quickSuggestionMode,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
