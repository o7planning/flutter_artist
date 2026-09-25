part of '../core.dart';

/// Context provider supplying safe, unified access to hierarchical ancestor Block data.
///
/// This context is passed to [BlockFormModel] methods to extract parent/ancestor
/// values during Form initialization without requiring redundant intermediary DTOs.
///
/// ### Example Usage:
/// ```dart
/// class EmployeeFormModel extends BlockFormModel<
///     int,
///     EmployeeData,
///     EmptyFormInput,
///     EmptyAdditionalFormRelatedData> {
///
///   @override
///   Map<String, dynamic>? specifyCreationValuesForSimpleProps({
///     required BlockAncestorContext ancestorContext,
///   }) {
///     // 1. Direct parent access (Immediate Parent: DepartmentBlock)
///     final departmentId = ancestorContext.parentCurrentItemId;
///     final department = ancestorContext.parentCurrentItem as DepartmentInfo?;
///
///     // 2. Query ancestor by Block Type directly (Strongly typed)
///     final branchBlock = ancestorContext.findAncestorBlock<BranchBlock>();
///     final branchInfo = branchBlock?.currentItem; // Automatically typed as BranchInfo?
///
///     // 3. Query ancestor by Block Name (Avoids ambiguity when models share the same type)
///     final company = ancestorContext.getItemDetailByBlockName<CompanyData>("company-block");
///
///     // 4. Query ancestor by generational depth (1 = Parent, 2 = Grandparent)
///     final grandparentItem = ancestorContext.getItemAtDepth<BranchInfo>(depth: 2);
///
///     return {
///       "departmentId": departmentId,
///       "departmentName": department?.name,
///       "branchCode": branchInfo?.code,
///       "companyCurrency": company?.currency,
///       "calculatedAllowance": branchInfo?.isSpecialZone == true ? 500.0 : 100.0,
///     };
///   }
/// }
/// ```
class BlockAncestorContext {
  /// The active Block owning the Form.
  final AnyBlock currentBlock;

  const BlockAncestorContext({required this.currentBlock});

  // ===========================================================================
  // 1. IMMEDIATE PARENT ACCESS (Level -1)
  // ===========================================================================

  /// Returns the active [currentItemId] of the immediate parent Block, if any.
  Object? get parentCurrentItemId => currentBlock.parent?.currentItemId;

  /// Returns the active [currentItem] of the immediate parent Block, if any.
  Object? get parentCurrentItem => currentBlock.parent?.currentItem;

  /// Returns the active [currentItemDetail] of the immediate parent Block, if any.
  Object? get parentCurrentItemDetail => currentBlock.parent?.currentItemDetail;

  /// Quick check whether the immediate parent Block has an active selected item.
  bool get hasParentItem => currentBlock.parent?.currentItem != null;

  // ===========================================================================
  // 2. QUERY BY ANCESTOR BLOCK CLASS TYPE (Strongly Typed & Idiomatic)
  // ===========================================================================

  /// Locates and returns an ancestor [Block] of specific type [B].
  ///
  /// This is the cleanest approach because the returned Block already carries
  /// strongly typed [currentItem] and [currentItemDetail] definitions.
  B? findAncestorBlock<B extends AnyBlock>() {
    for (final Block ancestor in currentBlock.ancestorBlocks) {
      if (ancestor is B) {
        return ancestor;
      }
    }
    return null;
  }

  /// Resolves the active [currentItem] belonging to an ancestor Block of type [B].
  T? getItemFromBlock<B extends AnyBlock, T>() {
    final B? block = findAncestorBlock<B>();
    return block?.currentItem as T?;
  }

  /// Resolves the active [currentItemDetail] belonging to an ancestor Block of type [B].
  D? getItemDetailFromBlock<B extends AnyBlock, D>() {
    final B? block = findAncestorBlock<B>();
    return block?.currentItemDetail as D?;
  }

  // ===========================================================================
  // 3. QUERY BY UNIQUE BLOCK NAME (Disambiguation for recursive/same-type trees)
  // ===========================================================================

  /// Resolves the active [currentItem] from an ancestor Block identified by [blockName].
  ///
  /// Useful when multiple recursive or nested Blocks share identical classes
  /// (e.g., Parent CategoryBlock vs Sub CategoryBlock).
  T? getItemByBlockName<T>(String blockName) {
    for (final Block ancestor in currentBlock.ancestorBlocks) {
      if (ancestor.name == blockName) {
        return ancestor.currentItem as T?;
      }
    }
    return null;
  }

  /// Resolves the active [currentItemDetail] from an ancestor Block identified by [blockName].
  D? getItemDetailByBlockName<D>(String blockName) {
    for (final Block ancestor in currentBlock.ancestorBlocks) {
      if (ancestor.name == blockName) {
        return ancestor.currentItemDetail as D?;
      }
    }
    return null;
  }

  /// Finds and returns the ancestor [Block] instance matching [blockName].
  B? findBlockByName<B extends AnyBlock>(String blockName) {
    for (final Block ancestor in currentBlock.ancestorBlocks) {
      if (ancestor.name == blockName) {
        return ancestor as B;
      }
    }
    return null;
  }

  // ===========================================================================
  // 4. QUERY BY GENERATIONAL DEPTH (Relative distance)
  // ===========================================================================

  /// Resolves the active [currentItem] at a specific generational ancestor distance.
  ///
  /// - `depth = 1`: Immediate Parent
  /// - `depth = 2`: Grandparent
  /// - `depth = 3`: Great-grandparent
  T? getItemAtDepth<T>({int depth = 1}) {
    assert(depth >= 1, "Ancestor depth must be greater than or equal to 1");
    final List<Block> ancestors = currentBlock.ancestorBlocks;
    if (depth <= ancestors.length) {
      return ancestors[depth - 1].currentItem as T?;
    }
    return null;
  }

  /// Resolves the active [currentItemDetail] at a specific generational ancestor distance.
  D? getItemDetailAtDepth<D>({int depth = 1}) {
    assert(depth >= 1, "Ancestor depth must be greater than or equal to 1");
    final List<Block> ancestors = currentBlock.ancestorBlocks;
    if (depth <= ancestors.length) {
      return ancestors[depth - 1].currentItemDetail as D?;
    }
    return null;
  }
}
