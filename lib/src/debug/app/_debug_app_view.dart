import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/icon/icon_constants.dart';
import '../utils/_tab_theme_utils.dart';
import '_active_shelves_view.dart';
import '_activities_view.dart';
import '_projections_view.dart';
import '_route_stack_view.dart';
import '_shelves_view.dart';

class DebugAppView extends StatefulWidget {
  const DebugAppView({super.key});

  @override
  State<DebugAppView> createState() => _DebugAppViewState();
}

class _DebugAppViewState extends State<DebugAppView> {
  static const double iconSize = 16;

  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabbedViewController(_getTabs());
  }

  List<TabData> _getTabs() {
    return [
      TabData(
        id: "Active Shelves",
        text: ' Active Shelves',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.shelfIconData,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: iconSize,
        ),
        view: const ActiveShelvesView(),
      ),
      TabData(
        id: "Activities",
        text: ' Activities',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.activityIconData,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: iconSize,
        ),
        view: ActivitiesView(),
      ),
      TabData(
        id: "Shelves",
        text: ' Shelves',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.shelfIconData,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: iconSize,
        ),
        view: ShelvesView(),
      ),
      TabData(
        id: "Projections",
        text: ' Projections',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.projectionIconData,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: iconSize,
        ),
        view: ProjectionsView(),
      ),
      TabData(
        id: "Route Stack",
        text: ' Route Stack',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.routeStackIconData,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: iconSize,
        ),
        view: RouteStackView(),
      ),
    ];
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
          child: TabbedViewTheme(
            data: TabThemeUtils.getTabbedViewThemeData(context),
            child: TabbedView(
              controller: _controller,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterModelInfo(BuildContext context) {
    return const SizedBox();
  }
}
