part of '../flutter_artist.dart';

abstract class FilterView<DATA_FILTER extends DataFilter>
    extends StatelessWidget {
  final DATA_FILTER dataFilter;

  const FilterView({
    required this.dataFilter,
    super.key,
  });

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return _FilterViewBuilder(
      ownerClassInstance: this,
      description: '',
      dataFilter: dataFilter,
      build: () {
        return buildContent(context);
      },
    );
  }

  Widget buildDebugBar({
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
        showDataFilterDebugDialog();
      },
      child: Icon(
        _dataFilterDebugIconData,
        size: iconSize ?? 16,
        color: iconColor ?? null,
      ),
    );
  }

  Future<void> showDataFilterDebugDialog() async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    //
    await _showDataFilterInfoDialog(
      context: context,
      locationInfo: getClassName(this),
      dataFilter: dataFilter,
    );
  }

  Widget buildContent(BuildContext context);
}
