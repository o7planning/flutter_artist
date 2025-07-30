import '../../core/_core/code.dart';
import '_block_or_scalar.dart';
import 'widgets/_graph_item.dart';

class DebugUtils {
  static GraphItem toRootDebugGraphItem(Shelf shelf) {
    GraphItem rootItem = GraphItem.shelf(shelf);
    for (Block rootBlock in shelf.rootBlocks) {
      GraphItem item = toDebugGraphItemCascade(rootBlock);
      rootItem.children.add(item);
    }
    for (Scalar scalar in shelf.scalars) {
      GraphItem item = GraphItem.blockOrScalar(BlockOrScalar.scalar(scalar));
      rootItem.children.add(item);
    }
    return rootItem;
  }

  static GraphItem toDebugGraphItemCascade(Block block) {
    GraphItem item = GraphItem.blockOrScalar(BlockOrScalar.block(block));
    for (Block childBlock in block.childBlocks) {
      GraphItem childItem = toDebugGraphItemCascade(childBlock);
      item.children.add(childItem);
    }
    return item;
  }
}
