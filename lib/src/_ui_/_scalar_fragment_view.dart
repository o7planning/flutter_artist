part of '../../flutter_artist.dart';

abstract class ScalarFragmentView<SCALAR extends Scalar>
    extends StatelessWidget {
  final SCALAR scalar;

  const ScalarFragmentView({
    required this.scalar,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return ScalarFragmentViewBuilder(
      ownerClassInstance: this,
      description: '',
      scalar: scalar,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
