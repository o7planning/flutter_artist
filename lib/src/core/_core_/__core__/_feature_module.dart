part of '../core.dart';

abstract class FeatureModule extends _Core {
  DateTime? __orphanedAt;

  DateTime? get orphanedAt => __orphanedAt;

  bool get markedAsOrphan => __orphanedAt != null;

  String get name;

  _ModuleUiComponents get ui;

  // ***************************************************************************

  FeatureModule();

  // ***************************************************************************

  void _markAsOrphaned(bool orphaned) {
    if (orphaned) {
      __orphanedAt = DateTime.now();
    } else {
      __orphanedAt = null;
    }
  }

  // ***************************************************************************


  Future<void> showDebugModuleStructureInspector() async {
    BuildContext context = FlutterArtistCore.context;
     DebugFeatureModuleStructureInspectorDialog.show(context: context, module: this);
  }

  // ***************************************************************************


  Future<void> showDebugUiContextInspector() async {
    BuildContext context = FlutterArtistCore.context;
    await DebugUiContextInspectorDialog.show(
      context: context,
      module: this,
    );
  }
}
