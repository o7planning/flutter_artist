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

  Actionable<ShowDebugInspectorPrecheck> checkBeforeShowDebugInspector() {
    return ShowDebugInspectorPrecheckUtils.checkBeforeShowDebugInspector(
      loggedInUser: FlutterArtist.loggedInUser,
      requiresRecentModule: false,
      hasRecentModule: true,
    );
  }

  // ***************************************************************************

  Future<Actionable<ShowDebugInspectorPrecheck>>
      showDebugModuleStructureInspector({
    bool showErrorSnackBar = true,
  }) async {
    final actionable = checkBeforeShowDebugInspector();
    if (!actionable.yes) {
      if (showErrorSnackBar) {
        final ShowDebugInspectorPrecheck err = actionable.errCode!;
        this.showErrorSnackBar(
          message: err.message,
          errorDetails: err.details,
        );
      }
      return actionable;
    }
    BuildContext context = FlutterArtistCore.context;
    await DebugFeatureModuleStructureInspectorDialog.show(
      context: context,
      module: this,
    );
    return actionable;
  }

  // ***************************************************************************

  Future<Actionable<ShowDebugInspectorPrecheck>> showDebugUiContextInspector({
    bool showErrorSnackBar = true,
  }) async {
    final actionable = checkBeforeShowDebugInspector();
    if (!actionable.yes) {
      if (showErrorSnackBar) {
        final ShowDebugInspectorPrecheck err = actionable.errCode!;
        this.showErrorSnackBar(
          message: err.message,
          errorDetails: err.details,
        );
      }
      return actionable;
    }
    BuildContext context = FlutterArtistCore.context;
    await DebugUiContextInspectorDialog.show(
      context: context,
      module: this,
    );
    return actionable;
  }
}
