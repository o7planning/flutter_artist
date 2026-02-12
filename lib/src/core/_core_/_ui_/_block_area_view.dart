part of '../core.dart';

abstract class BlockAreaView<
    BLOCK extends Block<
        Object, //
        Identifiable,
        Identifiable,
        FilterInput,
        FilterCriteria,
        FormInput,
        FormRelatedData>> extends StatelessWidget {
  final bool itemRepresentative;
  final BLOCK block;

  const BlockAreaView({
    required this.block,
    this.itemRepresentative = true,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockAreaViewBuilder(
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
