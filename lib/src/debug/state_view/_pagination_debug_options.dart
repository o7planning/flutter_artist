class PaginationDebugOptions {
  final bool showCurrentPage;
  final bool showPageSize;
  final bool showTotalItems;
  final bool showTotalPages;

  const PaginationDebugOptions({
    this.showCurrentPage = true,
    this.showPageSize = true,
    this.showTotalItems = true,
    this.showTotalPages = true,
  });

  const PaginationDebugOptions.custom({
    this.showCurrentPage = false,
    this.showPageSize = false,
    this.showTotalItems = false,
    this.showTotalPages = false,
  });
}
