part of '../../core.dart';

/// Utility class for building non-intrusive visual focus indicators and handling list navigation.
class _ViewFocusUtils {

  /// Helper to handle Up / Down / Home / End arrow keys for any [Block] items list.
  static KeyEventResult handleBlockItemsKeyEvent({
    required Block block,
    required KeyEvent event,
  }) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final LogicalKeyboardKey key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowDown) {
      return _navigateBlockItemByOffset(block, 1)
          ? KeyEventResult.handled
          : KeyEventResult.ignored;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      return _navigateBlockItemByOffset(block, -1)
          ? KeyEventResult.handled
          : KeyEventResult.ignored;
    } else if (key == LogicalKeyboardKey.home) {
      return _navigateBlockToEdgeItem(block, first: true)
          ? KeyEventResult.handled
          : KeyEventResult.ignored;
    } else if (key == LogicalKeyboardKey.end) {
      return _navigateBlockToEdgeItem(block, first: false)
          ? KeyEventResult.handled
          : KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  static bool _navigateBlockItemByOffset(Block block, int offset) {
    final List items = block.items;
    if (items.isEmpty) return false;

    if (FlutterArtist.executor.isBusy) {
      return true;
    }

    final Object? currentItem = block.currentItem;
    int currentIndex = -1;
    if (currentItem != null) {
      currentIndex = items.indexOf(currentItem);
    }

    final int targetIndex;
    if (currentIndex == -1) {
      targetIndex = offset > 0 ? 0 : items.length - 1;
    } else {
      targetIndex = (currentIndex + offset).clamp(0, items.length - 1);
    }

    if (targetIndex == currentIndex) {
      // return true;
    }

    block.refreshItemAndSetAsCurrent(item: items[targetIndex]);
    return true;
  }

  static bool _navigateBlockToEdgeItem(Block block, {required bool first}) {
    final List items = block.items;
    if (items.isEmpty) return false;

    if (FlutterArtist.executor.isBusy) {
      return true;
    }

    final dynamic targetItem = first ? items.first : items.last;
    if (block.isCurrentItem(targetItem)) {
      return true;
    }

    block.refreshItemAndSetAsCurrent(item: targetItem);
    return true;
  }
}
