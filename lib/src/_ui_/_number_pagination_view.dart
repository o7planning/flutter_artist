part of '../_fa_core.dart';

class NumberPaginationView extends PaginationView {
  final EdgeInsets padding;
  final int visiblePagesCount;

  const NumberPaginationView({
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
            pageable: PageableData(
              page: pageNumber,
              pageSize: block.pageable?.pageSize,
            ),
          );
        },
        visiblePagesCount: visiblePagesCount,
        totalPages: block.pagination == null ? 0 : block.pagination!.totalPages,
        currentPage:
            block.pagination == null ? 1 : block.pagination!.currentPage,
        fontSize: 13,
        controlButtonSize: const Size(22, 22),
        numberButtonSize: const Size(22, 22),
        // enableInteraction: false,
      ),
    );
  }
}
