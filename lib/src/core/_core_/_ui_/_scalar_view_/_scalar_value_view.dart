part of '../../core.dart';

abstract class ScalarValueView<
    SCALAR extends Scalar<
        Comparable, //
        Identifiable<Comparable>,
        FilterPatch,
        FilterCriteria>> extends StatelessWidget {
  final SCALAR scalar;

  final ScalarValueViewConfig config;

  const ScalarValueView({
    required this.scalar,
    required ScalarValueViewConfig? config,
    super.key,
  }) : config = config ?? const ScalarValueViewConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ScalarValueViewBuilder(
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
