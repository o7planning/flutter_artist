part of '../flutter_artist.dart';

class _FilterCriteriaDebugView extends StatelessWidget {
  final Block? block;
  final Scalar? scalar;
  final FilterModel? filterModel;

  const _FilterCriteriaDebugView.block({
    super.key,
    required Block this.block,
  })
      : scalar = null,
        filterModel = null;

  const _FilterCriteriaDebugView.scalar({
    super.key,
    required Scalar this.scalar,
  })
      : block = null,
        filterModel = null;

  const _FilterCriteriaDebugView.filterModel({
    super.key,
    required FilterModel this.filterModel,
  })
      : block = null,
        scalar = null;

  @override
  Widget build(BuildContext context) {
    List<TabData> tabs = [];
    FilterModel? _filterModel = filterModel;
    if (block != null) {
      _filterModel = block!.filterModel;
      //
      tabs.add(
        TabData(
          text: getClassName(block!),
          closable: false,
          leading: (context, status) =>
              Icon(
                _blockIconData,
                color: Colors.indigo,
                size: 16,
              ),
          content: SingleChildScrollView(
            child: _BlockCriteriaView(
              block: block!,
            ),
          ),
        ),
      );
    }
    if (scalar != null) {
      _filterModel = scalar!.filterModel;
      //
      tabs.add(
        TabData(
          text: getClassName(scalar!),
          closable: false,
          leading: (context, status) =>
              Icon(
                _scalarIconData,
                color: Colors.indigo,
                size: 16,
              ),
          content: SingleChildScrollView(
            child: _ScalarCriteriaView(
              scalar: scalar!,
            ),
          ),
        ),
      );
    }
    if (_filterModel != null) {
      tabs.add(
        TabData(
          text: getClassName(_filterModel),
          closable: false,
          leading: (context, status) =>
              Icon(
                _filterModelIconData,
                color: Colors.indigo,
                size: 16,
              ),
          content: SingleChildScrollView(
            child: _FilterModelCriteriaView(
              filterModel: _filterModel,
            ),
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
