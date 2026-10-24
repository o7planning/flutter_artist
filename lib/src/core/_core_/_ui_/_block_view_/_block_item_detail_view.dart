part of '../../core.dart';

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
  final BlockViewContext blockViewContext;

  const BlockItemDetailView({
    required this.block,
    this.blockViewContext = BlockViewContext.itemDetail,
    super.key,
  }) : assert(blockViewContext == BlockViewContext.itemDetail ||
            blockViewContext == BlockViewContext.form);

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemDetailViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      blockViewContext: blockViewContext,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
