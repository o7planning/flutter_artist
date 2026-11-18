import 'package:flutter/widgets.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core.dart';

class DataGridNavigationUtils {
  /// Handles data navigation operations (paging, loading more, changing the current record).
  /// Returns `true` if the shortcut pertains to data navigation and has been processed.
  static bool handleBlockDataNavigation({
    required BuildContext context,
    required Block block,
    required MnemonicShortcut shortcut,
  }) {
    // If the system is busy executing other logic, temporarily swallow this event.
    if (FlutterArtist.executor.isBusy) return true;

    switch (shortcut) {
      case MnemonicShortcut.nextItem:
        return _navigateItemByOffset(block, 1);

      case MnemonicShortcut.previousItem:
        return _navigateItemByOffset(block, -1);

      case MnemonicShortcut.nextPage:
        block.queryNextPage();
        return true;

      case MnemonicShortcut.previousPage:
        block.queryPreviousPage();
        return true;

      case MnemonicShortcut.firstPage:
        // You can call block.queryFirstPage() or block.query() with the page configuration set to 1
        block.query();
        return true;

      case MnemonicShortcut.loadMore:
        block.queryMore();
        return true;

      default:
        // Not a data navigation key
        return false;
    }
  }

  static bool _navigateItemByOffset(Block block, int offset) {
    final List items = block.items;
    if (items.isEmpty) return false;

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

    if (targetIndex != currentIndex) {
      block.refreshItemAndSetAsCurrent(item: items[targetIndex]);
    }
    return true;
  }
}
