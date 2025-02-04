part of '../flutter_artist.dart';

class _FilterCriteriaDebugView extends StatelessWidget {
  final Block? block;
  final Scalar? scalar;
  final DataFilter? dataFilter;

  const _FilterCriteriaDebugView.block({
    super.key,
    required Block this.block,
  })  : scalar = null,
        dataFilter = null;

  const _FilterCriteriaDebugView.scalar({
    super.key,
    required Scalar this.scalar,
  })  : block = null,
        dataFilter = null;

  const _FilterCriteriaDebugView.dataFilter({
    super.key,
    required DataFilter this.dataFilter,
  })  : block = null,
        scalar = null;

  @override
  Widget build(BuildContext context) {
    List<TabData> tabs = [];
    DataFilter? _dataFilter = dataFilter;
    if (block != null) {
      _dataFilter = block!.dataFilter;
      //
      tabs.add(
        TabData(
          text: getClassName(block!),
          closable: false,
          leading: (context, status) => Icon(
            _blockIconData,
            color: Colors.indigo,
            size: 16,
          ),
          content: _BlockCriteriaView(
            block: block!,
          ),
        ),
      );
    }
    if (scalar != null) {
      _dataFilter = scalar!.dataFilter;
      //
      tabs.add(
        TabData(
          text: getClassName(scalar!),
          closable: false,
          leading: (context, status) => Icon(
            _scalarIconData,
            color: Colors.indigo,
            size: 16,
          ),
          content: _ScalarCriteriaView(
            scalar: scalar!,
          ),
        ),
      );
    }
    if (_dataFilter != null) {
      tabs.add(
        TabData(
          text: getClassName(_dataFilter),
          closable: false,
          leading: (context, status) => Icon(
            _dataFilterIconData,
            color: Colors.indigo,
            size: 16,
          ),
          content: _DataFilterCriteriaView(
            dataFilter: _dataFilter,
          ),
        ),
      );
    }
    //
    TabbedViewController _controller = TabbedViewController(tabs);
    TabbedView tabbedView = TabbedView(controller: _controller);

    TabbedViewThemeData themeData = _getTabbedViewThemeData();

    TabbedViewTheme tabbedViewTheme = TabbedViewTheme(
      data: themeData,
      child: tabbedView,
    );
    return tabbedViewTheme;
  }
}
