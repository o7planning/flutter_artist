part of '../core.dart';

abstract class SortView<ITEM extends Object> extends StatelessWidget {
  final SortingModel<ITEM> sortingModel;

  const SortView({
    required this.sortingModel,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _SortViewBuilder(
      ownerClassInstance: this,
      description: '',
      sortingModel: sortingModel,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
