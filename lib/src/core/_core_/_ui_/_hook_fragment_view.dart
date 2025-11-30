part of '../core.dart';

abstract class HookFragmentView extends StatelessWidget {
  final Hook hook;

  const HookFragmentView({
    required this.hook,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return HookFragmentViewBuilder(
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
