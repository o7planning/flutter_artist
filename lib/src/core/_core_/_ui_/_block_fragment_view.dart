part of '../core.dart';

abstract class BlockFragmentView<
    BLOCK extends Block<
        Object, //
        Identifiable,
        Identifiable,
        FilterInput,
        FilterCriteria,
        FormRelatedData,
        FormInput>> extends StatelessWidget {
  final bool itemRepresentative;
  final BLOCK block;

  const BlockFragmentView({
    required this.block,
    this.itemRepresentative = true,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockFragmentViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      itemRepresentative: itemRepresentative,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
