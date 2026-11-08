part of '../../core.dart';

abstract class BlockItemDetailView<
    BLOCK extends Block<
        Comparable, //
        Identifiable<Comparable>,
        Identifiable<Comparable>,
        FilterPatch,
        FilterCriteria,
        CreationPreset,
        FormPatch>> extends StatelessWidget {
  final BLOCK block;

  final BlockItemDetailViewConfig config;

  BlockItemDetailView({
    required this.block,
    required BlockItemDetailViewConfig? config,
    super.key,
  })  : config = config ?? const BlockItemDetailViewConfig(),
        assert(
          config == null ||
              config.blockViewContext == BlockViewContext.itemDetail ||
              config.blockViewContext == BlockViewContext.form,
        );

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemDetailViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      config: config,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
