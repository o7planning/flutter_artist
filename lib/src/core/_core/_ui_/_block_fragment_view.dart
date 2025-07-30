part of '../code.dart';

abstract class BlockFragmentView<BLOCK extends Block> extends StatelessWidget {
  final BLOCK block;

  const BlockFragmentView({
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
