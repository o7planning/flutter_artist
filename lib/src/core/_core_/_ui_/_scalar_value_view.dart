part of '../core.dart';

abstract class ScalarValueView<SCALAR extends Scalar> extends StatelessWidget {
  final SCALAR scalar;
  final QuickSuggestionMode quickSuggestionMode;

  const ScalarValueView({
    required this.scalar,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ScalarValueViewBuilder(
      ownerClassInstance: this,
      description: '',
      scalar: scalar,
      quickSuggestionMode: quickSuggestionMode,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
