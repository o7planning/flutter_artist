part of '../../core.dart';

abstract class BlockSectionView<
    BLOCK extends Block<
        Comparable, //
        Identifiable<Comparable>,
        Identifiable<Comparable>,
        FilterPatch,
        FilterCriteria,
        CreationPreset,
        FormPatch>> extends StatelessWidget {
  final BLOCK block;
  final BlockSectionViewConfig config;

  const BlockSectionView({
    required this.block,
    required BlockSectionViewConfig? config,
    super.key,
  }) : config = config ?? const BlockSectionViewConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockSectionViewBuilder(
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
