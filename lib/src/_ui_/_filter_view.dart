part of '../../flutter_artist.dart';

abstract class FilterView<FILTER_MODEL extends FilterModel>
    extends StatelessWidget {
  final FILTER_MODEL filterModel;

  const FilterView({
    required this.filterModel,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _FilterViewBuilder(
      ownerClassInstance: this,
      description: '',
      filterModel: filterModel,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildFilterBar({
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
        showFilterModelDebugDialog();
      },
      child: Icon(
        _filterModelDebugIconData,
        size: iconSize ?? 16,
        color: iconColor ?? null,
      ),
    );
  }

  Future<void> showFilterModelDebugDialog() async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    //
    await _showFilterModelInfoDialog(
      context: context,
      locationInfo: getClassName(this),
      filterModel: filterModel,
    );
  }

  Widget buildContent(BuildContext context);
}
