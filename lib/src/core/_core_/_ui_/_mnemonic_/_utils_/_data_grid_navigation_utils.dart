import 'package:flutter/widgets.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../../core.dart';

class DataGridNavigationUtils {
  /// Xử lý các thao tác điều hướng dữ liệu (Lật trang, Load More, Đổi bản ghi hiện tại).
  /// Trả về `true` nếu shortcut thuộc về điều hướng dữ liệu và đã được xử lý.
  static bool handleBlockDataNavigation({
    required BuildContext context,
    required Block block,
    required MnemonicShortcut shortcut,
  }) {
    print("handleBlockDataNavigation: shortcut1: $shortcut");

    // Nếu hệ thống đang bận thực thi logic khác, tạm thời nuốt sự kiện này
    if (FlutterArtist.executor.isBusy) return true;
    print("handleBlockDataNavigation: shortcut2: $shortcut");

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
        // Có thể gọi block.queryFirstPage() hoặc block.query() với cấu hình trang = 1
        block.query();
        return true;

      case MnemonicShortcut.loadMore:
        block.queryMore();
        return true;

      default:
        // Không phải phím điều hướng dữ liệu
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
