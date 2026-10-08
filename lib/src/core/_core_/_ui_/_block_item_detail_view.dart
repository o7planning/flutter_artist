part of '../core.dart';

abstract class BlockItemDetailView<
    BLOCK extends Block<
        Comparable, //
        Identifiable<Comparable>,
        Identifiable<Comparable>,
        FilterInput,
        FilterCriteria,
        CreationPreset,
        FormInput>> extends StatelessWidget {
  final BLOCK block;
  final BlockContextType blockContextType;

  const BlockItemDetailView({
    required this.block,
    this.blockContextType = BlockContextType.itemDetail,
    super.key,
  }) : assert(blockContextType == BlockContextType.itemDetail ||
            blockContextType == BlockContextType.form);

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemDetailViewBuilder(
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
