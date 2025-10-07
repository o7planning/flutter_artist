part of '../core.dart';

class SimpleLoginView extends StatelessWidget {
  final Hook hook;

  const SimpleLoginView({
    super.key,
    required this.hook,
  });

  @override
  Widget build(BuildContext context) {
    return HookFragmentWidgetBuilder(
      hook: hook,
      ownerClassInstance: this,
      description: null,
      build: () {
        return Text("OK");
      },
    );
  }
}
