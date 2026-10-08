part of '../../core.dart';

abstract class SortPanel<ITEM extends Object> extends StatelessWidget {
  final SortModel<ITEM> sortModel;
  final BlockViewContext blockViewContext;

  const SortPanel({
    required this.sortModel,
    this.blockViewContext = BlockViewContext.items,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _SortPanelBuilder(
      ownerClassInstance: this,
      description: '',
      sortModel: sortModel,
      blockViewContext: blockViewContext,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
