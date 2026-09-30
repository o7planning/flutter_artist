part of '__root_debug_view.dart';

class RootDebugController {
  final Function({required FeatureModule module}) showDebugFeatureModuleState;
  final Function({required FeatureModule module}) showDebugInternalEventGraph;
  final Function() showRecentModules;

  RootDebugController({
    required this.showDebugFeatureModuleState,
    required this.showRecentModules,
    required this.showDebugInternalEventGraph,
  });
}
