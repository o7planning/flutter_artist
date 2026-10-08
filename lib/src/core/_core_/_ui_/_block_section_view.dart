part of '../core.dart';

abstract class BlockSectionView<
    BLOCK extends Block<
        Comparable, //
        Identifiable<Comparable>,
        Identifiable<Comparable>,
        FilterInput,
        FilterCriteria,
        CreationPreset,
        FormInput>> extends StatelessWidget {
  final BlockContextType? blockContextType;
  final BLOCK block;

  const BlockSectionView({
    required this.block,
    this.blockContextType = BlockContextType.items,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockSectionViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      blockContextType: blockContextType,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
