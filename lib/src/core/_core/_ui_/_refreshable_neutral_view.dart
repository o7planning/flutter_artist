part of '../../_fa_core.dart';

abstract class RefreshableNeutralView extends StatelessWidget {
  final List<Shelf> shelves;

  const RefreshableNeutralView({
    super.key,
    required this.shelves,
  }) : assert(shelves.length > 0);

  @override
  Widget build(BuildContext context) {
    return RefreshableNeutralViewBuilder(
      ownerClassInstance: this,
      description: null,
      shelves: shelves,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
