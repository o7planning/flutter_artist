import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/icon/icon_constants.dart';
import '../utils/_tab_theme_utils.dart';
import '_active_shelves_view.dart';
import '_activities_view.dart';
import '_auto_stockers_view.dart';
import '_shelves_view.dart';

class StorageView extends StatefulWidget {
  const StorageView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StorageViewState();
  }
}

class _StorageViewState extends State<StorageView> {
  static const double iconSize = 16;
  static const double fontSize = 13;

  static const int instantValueTab = 2;
  late int selectedTab = instantValueTab;

  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFilterModelInfo(context),
        const SizedBox(height: 5),
        Expanded(
          child: _buildTabContainer(),
        ),
      ],
    );
  }

  Widget _buildFilterModelInfo(BuildContext context) {
    return SizedBox();
  }

  Widget _buildTabContainer() {
    List<TabData> tabs = [];
    tabs.add(
      TabData(
        text: ' Active Shelves',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.shelfIconData,
          color: Colors.indigo,
          size: iconSize,
        ),
        content: ActiveShelvesView(),
      ),
    );
    tabs.add(
      TabData(
        text: ' Auto Stockers',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.autoStockerIconData,
          color: Colors.black,
          size: iconSize,
        ),
        content: AutoStockersView(),
      ),
    );
    tabs.add(
      TabData(
        text: ' Activities',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.activityIconData,
          color: Colors.black,
          size: iconSize,
        ),
        content: ActivitiesView(),
      ),
    );
    tabs.add(
      TabData(
        text: ' Shelves',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.shelfIconData,
          color: Colors.black,
          size: iconSize,
        ),
        content: ShelvesView(),
      ),
    );
    //
    _controller = TabbedViewController(tabs);
    TabbedView tabbedView = TabbedView(controller: _controller);

    TabbedViewThemeData themeData = TabThemeUtils.getTabbedViewThemeData();

    TabbedViewTheme tabbedViewTheme = TabbedViewTheme(
      data: themeData,
      child: tabbedView,
    );
    //
    return tabbedViewTheme;
  }
}
