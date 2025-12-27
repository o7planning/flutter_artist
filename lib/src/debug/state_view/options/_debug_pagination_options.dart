class DebugPaginationOptions {
  final bool showCurrentPage;
  final bool showPageSize;
  final bool showTotalItems;
  final bool showTotalPages;

  const DebugPaginationOptions({
    this.showCurrentPage = true,
    this.showPageSize = true,
    this.showTotalItems = true,
    this.showTotalPages = true,
  });

  const DebugPaginationOptions.custom({
    this.showCurrentPage = false,
    this.showPageSize = false,
    this.showTotalItems = false,
    this.showTotalPages = false,
  });
}
