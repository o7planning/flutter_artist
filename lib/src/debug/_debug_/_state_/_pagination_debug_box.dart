import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_fa_core.dart';
import '_block_debug_box.dart';
import '_pagination_debug_options.dart';

class PaginationDebugBox extends BaseDebugBox {
  final Block block;
  final PaginationDebugOptions options;

  const PaginationDebugBox({
    super.key,
    required this.block,
    required this.options,
  });

  @override
  List<IconLabelText> getChildIconLabelTexts() {
    return [
      if (options.showCurrentPage)
        IconLabelText(
          label: "Current Page: ",
          text: "${block.pagination?.currentPage}",
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showPageSize)
        IconLabelText(
          label: "Page Size: ",
          text: "${block.pagination?.pageSize}",
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showTotalItems)
        IconLabelText(
          label: "Total Items: ",
          text: "${block.pagination?.totalItems}",
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showTotalPages)
        IconLabelText(
          label: "Total Pages: ",
          text: "${block.pagination?.totalPages}",
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
    ];
  }
}
