import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../__root_debug_view.dart';

class RecentShelvesView extends StatelessWidget {
  final RootDebugController controller;
  final bool showTitle;

  const RecentShelvesView({
    super.key,
    this.showTitle = true,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    List<Shelf> recentShelves =
        FlutterArtist.storage.getRecentShelves(visibleOnly: true);

    return Center(
      child: Wrap(
        children: recentShelves
            .map(
              (shelf) => ElevatedButton(
                onPressed: () {
                  /// controller.showDebugShelfState(shelf: shelf);
                  controller.showDebugInternalEventGraph(shelf: shelf);
                },
                child: Text(shelf.name),
              ),
            )
            .toList(),
      ),
    );
  }
}
