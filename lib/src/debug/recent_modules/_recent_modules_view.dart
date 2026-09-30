import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../__root_debug_view.dart';

class RecentModulesView extends StatelessWidget {
  final RootDebugController controller;
  final bool showTitle;

  const RecentModulesView({
    super.key,
    this.showTitle = true,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    List<FeatureModule> recentModules =
        FlutterArtist. getRecentModules(visibleOnly: true);

    return Center(
      child: Wrap(
        children: recentModules
            .map(
              (module) => ElevatedButton(
                onPressed: () {
                  controller.showDebugInternalEventGraph(module: module);
                },
                child: Text(module.name),
              ),
            )
            .toList(),
      ),
    );
  }
}
