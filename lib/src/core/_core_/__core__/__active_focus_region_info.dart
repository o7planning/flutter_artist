part of '../core.dart';

/// An enterprise-grade immutable data transfer model representing the active
/// focus region, module path, and contextual metrics within the application viewport.
///
/// This model tracks core focus and navigation state across FeatureModules (such as Shelves or Activities),
/// providing standard metadata for status bars and inspection tools.
class ActiveFocusRegionInfo {
  /// The primary identifier or name of the outer FeatureModule, Shelf, or Activity scope
  /// (e.g., "inventory-activity" or "sales-shelf").
  final String? moduleName;

  /// The primary identifier or name of the active working component
  /// (e.g., "product-block" or "checkout-process").
  final String? componentName;

  /// The specific view, mode, or task type currently selected within the component
  /// (e.g., "itemsView", "formView", or "payment-task").
  final String? viewType;

  /// Custom icon representing the active focus region type.
  final IconData? iconData;

  /// Record or pagination status string (e.g., "Rec: 2/15" or "Page: 1/5").
  final String? recordStatus;

  /// Current operational mode of the active region (e.g., "EDIT", "INSERT", "QUERY", "READ-ONLY").
  final String? formMode;

  /// Contextual keyboard shortcut hints (e.g., "F2: Edit • Ctrl+S: Save").
  final String? shortcutHints;

  const ActiveFocusRegionInfo({
    this.moduleName,
    this.componentName,
    this.viewType,
    this.iconData,
    this.recordStatus,
    this.formMode,
    this.shortcutHints,
  });

  /// Computes a clean, standardized hierarchical display path string
  /// (e.g., "product-block / itemsView" or "warehouse-module / inventory-block / grid-view").
  String get displayPath {
    final List<String> parts = [];
    if (moduleName != null && moduleName!.isNotEmpty) {
      parts.add(moduleName!);
    }
    if (componentName != null && componentName!.isNotEmpty) {
      parts.add(componentName!);
    }
    if (viewType != null && viewType!.isNotEmpty) {
      parts.add(viewType!);
    }
    return parts.join(' / ');
  }

  /// Returns true if at least one structural naming attribute is present.
  bool get isValid => displayPath.isNotEmpty;
}
