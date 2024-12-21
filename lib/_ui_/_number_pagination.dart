part of '../flutter_artist.dart';

class NumberPagination extends BasePagination {
  final EdgeInsets padding;
  final int visiblePagesCount;

  const NumberPagination({
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
              pageSize: block.data.pageable?.pageSize,
            ),
          );
        },
        visiblePagesCount: visiblePagesCount,
        totalPages: block.data.pagination == null
            ? 0
            : block.data.pagination!.totalPages,
        currentPage: block.data.pagination == null
            ? 1
            : block.data.pagination!.currentPage,
        fontSize: 13,
        controlButtonSize: const Size(22, 22),
        numberButtonSize: const Size(22, 22),
        // enableInteraction: false,
      ),
    );
  }
}
