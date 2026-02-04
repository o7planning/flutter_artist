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
  Widget build() {
    return Padding(
      padding: padding,
      child: number_pagination.NumberPagination(
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
        controlButtonSize: const Size(22, 22),
        numberButtonSize: const Size(22, 22),
        // enableInteraction: false,
      ),
    );
  }
}
