part of '../core.dart';

abstract class BlockItemDetailView<
    BLOCK extends Block<
        Object, //
        Identifiable,
        Identifiable,
        FilterInput,
        FilterCriteria,
        FormInput,
        FormRelatedData>> extends StatelessWidget {
  final BLOCK block;

  const BlockItemDetailView({
    required this.block,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemDetailViewBuilder(
      ownerClassInstance: this,
      description: '',
      block: block,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
