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
    final tokens = context.faTokens;
    final theme = Theme.of(context);

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
        buttonRadius: tokens.shortcut.borderRadius,
        buttonElevation: tokens.shortcut.elevation,

        // selectedButtonColor: tokens.primary,
        // selectedNumberColor: Colors.white,
        //
        // // Color for unselected buttons (Blends into the surface background)
        // unSelectedButtonColor: tokens.shortcut.surfaceColor,
        // unSelectedNumberColor: tokens.shortcut.onSurfaceColor.withValues(alpha: 0.7),
        //
        // // Border for buttons
        // buttonUnSelectedBorderColor: tokens.shortcut.border.color,
        // buttonSelectedBorderColor: tokens.primary ,

        // Selected button.
        selectedButtonColor: theme.primaryColor,
        selectedNumberColor: theme.colorScheme.onPrimary,

        // Unselected button
        unSelectedButtonColor: tokens.shortcut.surfaceColor,
        unSelectedNumberColor:
            tokens.shortcut.onSurfaceColor.withValues(alpha: 0.7),

        // Border for buttons
        buttonUnSelectedBorderColor: tokens.shortcut.border.color,
        buttonSelectedBorderColor: theme.primaryColor,

        controlButtonSize: const Size(22, 22),
        numberButtonSize: const Size(22, 22),
        // enableInteraction: false,
      ),
    );
  }
}
