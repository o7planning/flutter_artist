part of '../core.dart';

abstract class HookAreaView extends StatelessWidget {
  final Hook hook;

  const HookAreaView({
    required this.hook,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return HookAreaViewBuilder(
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
