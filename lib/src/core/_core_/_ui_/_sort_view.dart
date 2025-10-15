part of '../core.dart';

abstract class SortView<ITEM extends Object> extends StatelessWidget {
  final SortingModel<ITEM> sortingModel;
  final SortingSide sortingSide;

  const SortView({
    required this.sortingModel,
    required this.sortingSide,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _SortViewBuilder(
      ownerClassInstance: this,
      description: '',
      sortingModel: sortingModel,
      sortingSide: sortingSide,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
