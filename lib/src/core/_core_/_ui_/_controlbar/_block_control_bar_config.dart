part of '../../core.dart';

class BlockControlBarConfig {
  final bool allowRefreshButton;
  final bool allowQueryButton;
  final bool allowCreateButton;
  final bool allowEditButton;
  final bool allowSaveButton;
  final bool allowDeleteButton;
  final bool allowBackButton;
  final bool allowDebugFormModelInspectorButton;
  final bool allowDebugFilterCriteriaInspectorButton;
  final bool allowDebugButton;

  final NavigationIntent? createNavigationIntent;
  final NavigationIntent? editNavigationIntent;
  final NavigationIntent? saveNavigationIntent;
  final NavigationIntent? deleteNavigationIntent;

  const BlockControlBarConfig({
    required this.allowRefreshButton,
    required this.allowQueryButton,
    required this.allowCreateButton,
    this.allowEditButton = false,
    required this.allowSaveButton,
    required this.allowDeleteButton,
    required this.allowBackButton,
    required this.allowDebugFormModelInspectorButton,
    this.allowDebugFilterCriteriaInspectorButton = false,
    this.allowDebugButton = false,
    //
    this.saveNavigationIntent,
    this.createNavigationIntent,
    this.editNavigationIntent,
    this.deleteNavigationIntent,
  });
}
