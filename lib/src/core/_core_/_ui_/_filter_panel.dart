part of '../core.dart';

abstract class FilterPanel<FILTER_MODEL extends FilterModel>
    extends StatelessWidget {
  final FILTER_MODEL filterModel;

  const FilterPanel({
    required this.filterModel,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _FilterPanelBuilder(
      ownerClassInstance: this,
      description: '',
      filterModel: filterModel,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildFilterBar(
    BuildContext context, {
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding: padding ?? EdgeInsets.all(5),
      decoration: decoration ??
          BoxDecoration(
            color: Colors.black12,
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildDebugButton(),
        ],
      ),
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
        showDebugFilterModelViewerDialog();
      },
      child: Icon(
        FaIconConstants.filterModelDebugIconData,
        size: iconSize ?? 16,
        color: iconColor,
      ),
    );
  }

  Future<void> showDebugFilterModelViewerDialog() async {
    BuildContext context = FlutterArtist.coreFeaturesAdapter.context;
    //
    await DebugViewerDialog.openDebugFilterModelViewer(
      context: context,
      locationInfo: getClassName(this),
      filterModel: filterModel,
    );
  }

  Widget buildContent(BuildContext context);
}
