import 'package:flutter/material.dart';

import '../core/_core_/core.dart';
import 'internal_event/x/_internal_event_graph_view_test2b.dart';
import 'recent_modules/_recent_modules_view.dart';

part 'root_debug_controller.dart';

class RootDebugView extends StatefulWidget {
  final bool showTitle;

  const RootDebugView({
    super.key,
    this.showTitle = true,
  });

  @override
  State<StatefulWidget> createState() {
    return _RootDebugViewState();
  }
}

class _RootDebugViewState extends State<RootDebugView> {
  late final RootDebugController controller;
  Widget? currentView;

  @override
  void initState() {
    super.initState();
    //
    controller = RootDebugController(
      showDebugFeatureModuleState: _showDebugFeatureModuleState,
      showRecentModules: _showRecentModules,
      showDebugInternalEventGraph: _showDebugInternalEventGraph,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                _showRecentModules();
              },
              child: Text("Recent Shelves"),
            ),
            ElevatedButton(
              onPressed: () {
                _buildScreen2(context);
              },
              child: Text("Screen 2"),
            ),
          ],
        ),
        Divider(),
        Expanded(
          child: currentView == null ? Text("?") : currentView!,
        ),
      ],
    );
  }

  void _buildScreen2(BuildContext context) {
    currentView = Text("Screen 2");
    setState(() {});
  }

  void _showDebugFeatureModuleState({required FeatureModule module}) {
    // currentView = DebugShelfStateView(
    //   controller: controller,
    //   shelf: shelf,
    // );
    currentView = Text("TODO _showDebugFeatureModuleState");
    setState(() {});
  }

  void _showRecentModules() {
    currentView = RecentModulesView(controller: controller);
    setState(() {});
  }

  void _showDebugInternalEventGraph({required FeatureModule module}) {
    // currentView = InternalEventGraphView(
    //   controller: controller,
    //   shelf: shelf,
    // );
    // setState(() {});

    // currentView = InternalEventGraphViewTest();
    // setState(() {});

    // currentView = InternalEventGraphView4(shelf: shelf);
    // setState(() {});

    currentView = InternalEventGraphViewTest2b();
    setState(() {});
  }
}
