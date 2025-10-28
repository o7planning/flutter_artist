part of '../core.dart';

abstract class BlockItemDetailView<
    BLOCK extends Block<
        Object, //
        Identifiable,
        Identifiable,
        FilterInput,
        FilterCriteria,
        ExtraFormInput>> extends StatelessWidget {
  final BLOCK block;

  const BlockItemDetailView({
    required this.block,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockFragmentViewBuilder(
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
