part of '../core.dart';

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
  final BlockContextType blockContextType;

  const BlockItemsView({
    required this.block,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.blockContextType = BlockContextType.items,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemsViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      blockContextType: blockContextType,
      quickSuggestionMode: quickSuggestionMode,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
