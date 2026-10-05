import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../enums/_enums.dart';

/// Utility calculator responsible for resolving target pageable parameters
/// based on query methods and pagination states.
class PageableCalculator {
  /// Calculates and returns the target [Pageable] object or null if out of bounds.
  static Pageable? calculate({
    required QueryType lastQueryType,
    required BlockQryMethodName qryMethod,
    required PaginationInfo? currentPagination,
    required Pageable defaultPageable,
    required Pageable? specifiedPageable,
  }) {
    if (lastQueryType == QueryType.emptyQuery) {
      return defaultPageable;
    }
    if (currentPagination == null) {
      return defaultPageable;
    }
    final int totalPages = currentPagination.totalPages;

    final Pageable currentPageable = Pageable(
      page: currentPagination.currentPage,
      pageSize: currentPagination.pageSize > 0
          ? currentPagination.pageSize
          : defaultPageable.pageSize,
    );

    switch (qryMethod) {
      case BlockQryMethodName.query:
        if (specifiedPageable != null) {
          return specifiedPageable;
        }
        return defaultPageable;
      case BlockQryMethodName.queryPreviousPage:
        return currentPageable.previous();

      case BlockQryMethodName.queryNextPage:
      case BlockQryMethodName.queryMore:
        final Pageable next = currentPageable.next();
        // Return null if the next page exceeds total available pages (boundary check)
        return next.page > totalPages ? null : next;
    }
  }
}
