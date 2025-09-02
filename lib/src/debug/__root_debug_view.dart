import 'package:flutter/material.dart';
import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/debug/state_view/_shelf_debug_state_view.dart';

import 'recent_shelves/_recent_shelves_view.dart';

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
      showDebugShelfState: _showDebugShelfState,
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
                _buildScreen1(context);
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

  void _buildScreen1(BuildContext context) {
    currentView = RecentShelvesView(controller: controller);
    setState(() {});
  }

  void _buildScreen2(BuildContext context) {
    currentView = Text("Screen 2");
    setState(() {});
  }

  void _showDebugShelfState({required Shelf shelf}) {
    currentView = ShelfDebugStateView(
      controller: controller,
      shelf: shelf,
    );
    setState(() {});
  }
}
