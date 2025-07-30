part of '../../_fa_core.dart';

abstract class ScalarFragmentView<SCALAR extends Scalar>
    extends StatelessWidget {
  final SCALAR scalar;
  final QuickSuggestionMode quickSuggestionMode;

  const ScalarFragmentView({
    required this.scalar,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ScalarFragmentViewBuilder(
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
