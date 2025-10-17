part of '../core.dart';

abstract class SortView<ITEM extends Object> extends StatelessWidget {
  final SortModel<ITEM> sortModel;

  const SortView({
    required this.sortModel,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _SortViewBuilder(
      ownerClassInstance: this,
      description: '',
      sortModel: sortModel,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
