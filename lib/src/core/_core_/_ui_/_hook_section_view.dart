part of '../core.dart';

abstract class HookSectionView extends StatelessWidget {
  final Hook hook;

  const HookSectionView({
    required this.hook,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return HookSectionViewBuilder(
      ownerClassInstance: this,
      description: '',
      hook: hook,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
