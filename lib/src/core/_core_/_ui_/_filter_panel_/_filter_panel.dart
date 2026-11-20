part of '../../core.dart';

abstract class FilterPanel<FILTER_MODEL extends FilterModel>
    extends StatelessWidget {
  final FILTER_MODEL filterModel;
  final FilterPanelConfig config;

  const FilterPanel({
    required this.filterModel,
    required FilterPanelConfig? config,
    super.key,
  }) : config = config ?? const FilterPanelConfig();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _FilterPanelBuilder(
      ownerClassInstance: this,
      description: '',
      filterModel: filterModel,
      config: config,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildDebugButton({
    ButtonStyle? style,
    IconData? iconData,
    double? iconSize,
    Color? iconColor,
  }) {
    return TextButton(
      style: style ??
          TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
          ),
      onPressed: () {
        filterModel.showDebugFilterModelInspector();
      },
      child: Icon(
        FaIconConstants.filterModelDebugIconData,
        size: iconSize ?? 16,
        color: iconColor,
      ),
    );
  }

  Widget buildContent(BuildContext context);
}
