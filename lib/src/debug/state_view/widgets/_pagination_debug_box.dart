import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../options/_debug_pagination_options.dart';
import '_debug_box.dart';
import '_debug_style_utils.dart';

class PaginationDebugBox extends BaseDebugBox {
  final Block block;
  final DebugPaginationOptions options;

  const PaginationDebugBox({
    super.key,
    required this.block,
    required this.options,
  });

  @override
  List<IconLabelText> getChildIconLabelTexts(BuildContext context) {
    return [
      if (options.showCurrentPage)
        IconLabelText(
          label: "Current Page: ",
          text: "${block.paginationInfo?.currentPage}",
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showPageSize)
        IconLabelText(
          label: "Page Size: ",
          text: "${block.paginationInfo?.pageSize}",
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showTotalItems)
        IconLabelText(
          label: "Total Items: ",
          text: "${block.paginationInfo?.totalItems}",
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showTotalPages)
        IconLabelText(
          label: "Total Pages: ",
          text: "${block.paginationInfo?.totalPages}",
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
    ];
  }
}
