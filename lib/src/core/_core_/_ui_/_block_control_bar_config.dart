part of '../core.dart';

class BlockControlBarConfig {
  final bool allowRefreshButton;
  final bool allowQueryButton;
  final bool allowCreateButton;
  final bool allowSaveButton;
  final bool allowDeleteButton;
  final bool allowBackButton;
  final bool allowDebugFormModelViewerButton;
  final bool allowDebugFilterCriteriaViewerButton;
  final bool allowDebugButton;

  const BlockControlBarConfig({
    required this.allowRefreshButton,
    required this.allowQueryButton,
    required this.allowCreateButton,
    required this.allowSaveButton,
    required this.allowDeleteButton,
    required this.allowBackButton,
    required this.allowDebugFormModelViewerButton,
    this.allowDebugFilterCriteriaViewerButton = false,
    this.allowDebugButton = false,
  });
}
