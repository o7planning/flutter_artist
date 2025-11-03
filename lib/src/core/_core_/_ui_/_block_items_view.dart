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
  final bool itemRepresentative;

  const BlockItemsView({
    required this.block,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.itemRepresentative = false,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemsViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      itemRepresentative: itemRepresentative,
      quickSuggestionMode: quickSuggestionMode,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
