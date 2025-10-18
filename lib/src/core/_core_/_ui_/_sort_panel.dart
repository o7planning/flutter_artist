part of '../core.dart';

abstract class SortPanel<ITEM extends Object> extends StatelessWidget {
  final SortModel<ITEM> sortModel;

  const SortPanel({
    required this.sortModel,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _SortPanelBuilder(
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
