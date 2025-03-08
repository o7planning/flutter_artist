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
