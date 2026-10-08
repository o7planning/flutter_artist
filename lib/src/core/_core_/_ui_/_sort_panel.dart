part of '../core.dart';

abstract class SortPanel<ITEM extends Object> extends StatelessWidget {
  final SortModel<ITEM> sortModel;
  final BlockContextType blockContextType;

  const SortPanel({
    required this.sortModel,
    this.blockContextType = BlockContextType.items,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _SortPanelBuilder(
      ownerClassInstance: this,
      description: '',
      sortModel: sortModel,
      blockContextType: blockContextType,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
