part of '../core.dart';

abstract class ScalarSectionView<SCALAR extends Scalar>
    extends StatelessWidget {
  final SCALAR scalar;
  final QuickSuggestionMode quickSuggestionMode;

  const ScalarSectionView({
    required this.scalar,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ScalarSectionViewBuilder(
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
