part of '../../core.dart';

abstract class SortPanel<ITEM extends Object> extends StatelessWidget {
  final SortModel<ITEM> sortModel;

  final SortPanelConfig config;

  const SortPanel({
    required this.sortModel,
    required SortPanelConfig? config,
    super.key,
  }) : config = config ?? const SortPanelConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _SortPanelBuilder(
      ownerClassInstance: this,
      description: '',
      sortModel: sortModel,
      config: config,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context);
}
