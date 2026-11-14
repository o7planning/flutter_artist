part of '_enums.dart';

/// Semantic classification of UI view regions within the FlutterArtist framework.
///
/// Used by [ActiveFocusRegion], [FaFocusTracker], status bars, and debug inspectors
/// to identify the exact type of view currently holding keyboard focus.
enum FocusRegionType {
  blockItemsView('itemsView'),
  blockItemDetailView('itemDetailView'),
  blockSectionView('sectionView'),
  blockFormView('formView'),
  taskFormView('taskFormView'),
  stageFormView('stageFormView'),
  filterPanel('filterPanel'),
  sortPanel('sortPanel'),
  scalarValueView('scalarValueView'),
  scalarSectionView('scalarSectionView'),
  taskView('taskView'),
  stageView('stageView'),
  prozessView('prozessView'),
  prozessStagesSwitcher('stagesSwitcher'),
  controlBar('controlBar'),
  pagination('pagination'),
  storageSectionView('storageSectionView'),
  executionProgress('executionProgress'),
  loggedInUser('loggedInUser');

  /// Human-readable short identifier suitable for status bars and diagnostic overlays.
  final String label;

  const FocusRegionType(this.label);
}
