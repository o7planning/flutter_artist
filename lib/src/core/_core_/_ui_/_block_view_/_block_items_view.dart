part of '../../core.dart';

abstract class BlockItemsView<
    BLOCK extends Block<
        Comparable, //
        Identifiable<Comparable>,
        Identifiable<Comparable>,
        FilterPatch,
        FilterCriteria,
        CreationPreset,
        FormPatch>> extends StatelessWidget {
  final BLOCK block;
  final BlockItemsViewConfig config;

  const BlockItemsView({
    required this.block,
    required BlockItemsViewConfig? config,
    super.key,
  }) : config = config ?? const BlockItemsViewConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemsViewBuilder(
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
