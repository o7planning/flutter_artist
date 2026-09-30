import '../../../core/_core_/core.dart';
import '../../app/_block_or_scalar.dart';
import 'widget/_graph_item.dart';

class GraphDebugUtils {
  /// Converts a Shelf structure into a root debug graph item,
  /// recursively processing both blocks and hierarchical scalars.
  static GraphItem toRootDebugGraphItem(Shelf shelf) {
    GraphItem rootItem = GraphItem.shelf(shelf);

    // 1. Process root blocks and their children recursively
    for (Block rootBlock in shelf.rootBlocks) {
      GraphItem item = toDebugGraphItemCascadeForBlock(rootBlock);
      rootItem.children.add(item);
    }

    // 2. Process root scalars and their hierarchical children recursively
    for (Scalar rootScalar in shelf.rootScalars) {
      GraphItem item = toDebugGraphItemCascadeForScalar(rootScalar);
      rootItem.children.add(item);
    }

    return rootItem;
  }

  /// Recursively builds the graph item tree for block hierarchies.
  static GraphItem toDebugGraphItemCascadeForBlock(Block block) {
    GraphItem item = GraphItem.blockOrScalar(BlockOrScalar.block(block));
    for (Block childBlock in block.childBlocks) {
      GraphItem childItem = toDebugGraphItemCascadeForBlock(childBlock);
      item.children.add(childItem);
    }
    return item;
  }

  /// Recursively builds the graph item tree for scalar hierarchies.
  static GraphItem toDebugGraphItemCascadeForScalar(Scalar scalar) {
    GraphItem item = GraphItem.blockOrScalar(BlockOrScalar.scalar(scalar));
    for (Scalar childScalar in scalar.childScalars) {
      GraphItem childItem = toDebugGraphItemCascadeForScalar(childScalar);
      item.children.add(childItem);
    }
    return item;
  }
}
