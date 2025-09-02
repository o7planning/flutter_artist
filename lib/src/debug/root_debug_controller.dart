part of '__root_debug_view.dart';

class RootDebugController {
  final Function({required Shelf shelf}) showDebugShelfState;
  final Function({required Shelf shelf}) showDebugInternalEventGraph;
  final Function() showRecentShelves;

  RootDebugController({
    required this.showDebugShelfState,
    required this.showRecentShelves,
    required this.showDebugInternalEventGraph,
  });
}
