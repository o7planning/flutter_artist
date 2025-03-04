part of '../flutter_artist.dart';

abstract class BlockItemsView<BLOCK extends Block> extends StatelessWidget {
  final BLOCK block;

  const BlockItemsView({
    required this.block,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlockItemsViewBuilder(
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
