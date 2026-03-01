part of '../core.dart';

abstract class SortPanel<ITEM extends Object> extends StatelessWidget {
  final SortModel<ITEM> sortModel;
  final bool provideItemContext;
  final bool provideFormContext;

  const SortPanel({
    required this.sortModel,
    this.provideItemContext = false,
    this.provideFormContext = false,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _SortPanelBuilder(
      ownerClassInstance: this,
      description: '',
      sortModel: sortModel,
      provideItemContext: provideItemContext,
      provideFormContext: provideFormContext,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
