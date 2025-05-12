part of '../../../flutter_artist.dart';

class _PaginationDebugBox extends _BaseDebugBox {
  final Block block;
  final PaginationDebugOptions options;

  const _PaginationDebugBox({
    super.key,
    required this.block,
    required this.options,
  });

  @override
  List<dialogs.IconLabelText> getChildIconLabelTexts() {
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
          label: "Total Page: ",
          text: "${block.pagination?.totalPages}",
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
    ];
  }
}
