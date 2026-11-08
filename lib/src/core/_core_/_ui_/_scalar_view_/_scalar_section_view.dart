part of '../../core.dart';

abstract class ScalarSectionView<
    SCALAR extends Scalar<
        Comparable, //
        Identifiable<Comparable>,
        FilterPatch,
        FilterCriteria>> extends StatelessWidget {
  final SCALAR scalar;
  final ScalarSectionViewConfig config;

  const ScalarSectionView({
    required this.scalar,
    required ScalarSectionViewConfig? config,
    super.key,
  }) : config = config ?? const ScalarSectionViewConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ScalarSectionViewBuilder(
      ownerClassInstance: this,
      description: '',
      scalar: scalar,
      config: config,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
