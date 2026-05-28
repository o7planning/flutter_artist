part of '../core.dart';

class BlockNumberPagination extends BlockPagination {
  final EdgeInsets padding;
  final int visiblePagesCount;

  const BlockNumberPagination({
    super.key,
    required super.block,
    required super.description,
    required super.ownerClassInstance,
    this.padding = EdgeInsets.zero,
    required this.visiblePagesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: NumberPagination(
        onPageChanged: (int pageNumber) {
          block.query(
            pageable: Pageable(
              page: pageNumber,
              pageSize: block.pageable?.pageSize,
            ),
          );
        },
        visiblePagesCount: visiblePagesCount,
        totalPages:
            block.paginationInfo == null ? 0 : block.paginationInfo!.totalPages,
        currentPage: block.paginationInfo == null
            ? 1
            : block.paginationInfo!.currentPage,
        fontSize: 13,
        buttonRadius: context.faTheme.tokens.radius.borderRadius,
        buttonElevation: context.faTheme.tokens.elevation.level1,
        // Selected button.
        selectedBgColor: context.faColors.action.fill.primary,
        selectedFgColor: context.faColors.action.ink.onPrimaryFill,

        // Unselected button
        unSelectedBgColor: context.faColors.action.fill.secondary,
        unSelectedFgColor: context.faColors.action.ink.onSecondaryFill,

        // Border for buttons
        buttonUnSelectedBorderColor: context.faColors.action.stroke.subtle,
        buttonSelectedBorderColor: context.faColors.action.stroke.subtle,

        controlButtonSize: const Size(22, 22),
        numberButtonSize: const Size(22, 22),
        // enableInteraction: false,
      ),
    );
  }
}
