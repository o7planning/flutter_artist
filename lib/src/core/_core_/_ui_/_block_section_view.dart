part of '../core.dart';

abstract class BlockSectionView<
    BLOCK extends Block<
        Object, //
        Identifiable,
        Identifiable,
        FilterInput,
        FilterCriteria,
        FormInput,
        FormRelatedData>> extends StatelessWidget {
  final bool provideItemContext;
  final bool provideFormContext;
  final BLOCK block;

  const BlockSectionView({
    required this.block,
    this.provideItemContext = true,
    this.provideFormContext = false,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockSectionViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      provideItemContext: provideItemContext,
      provideFormContext: provideFormContext,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
