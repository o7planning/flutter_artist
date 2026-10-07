import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:test/test.dart';

void main() {
  group('PageableCalculator Tests', () {
    final defaultPageable = Pageable(page: 1, pageSize: 10);
    final paginationInfo = PaginationInfo(
      currentPage: 2,
      pageSize: 10,
      totalItems: 25,
      totalPages: 3,
    );

    test('Should return defaultPageable when lastQueryType is emptyQuery', () {
      final result = PageableCalculator.calculate(
        lastQueryType: QueryType.emptyQuery,
        qryMethod: BlockQryMethodName.query,
        currentPagination: paginationInfo,
        defaultPageable: defaultPageable,
        specifiedPageable: null,
      );

      expect(result?.page, equals(1));
    });

    test('Should return defaultPageable when currentPagination is null', () {
      final result = PageableCalculator.calculate(
        lastQueryType: QueryType.realQuery,
        qryMethod: BlockQryMethodName.query,
        currentPagination: null,
        defaultPageable: defaultPageable,
        specifiedPageable: null,
      );

      expect(result?.page, equals(1));
    });

    test(
        'Should return specifiedPageable when query method is standard query with specified pageable',
        () {
      final customPageable = Pageable(page: 3, pageSize: 10);
      final result = PageableCalculator.calculate(
        lastQueryType: QueryType.realQuery,
        qryMethod: BlockQryMethodName.query,
        currentPagination: paginationInfo,
        defaultPageable: defaultPageable,
        specifiedPageable: customPageable,
      );

      expect(result?.page, equals(3));
    });

    test('Should return previous pageable when qryMethod is queryPreviousPage',
        () {
      final result = PageableCalculator.calculate(
        lastQueryType: QueryType.realQuery,
        qryMethod: BlockQryMethodName.queryPreviousPage,
        currentPagination: paginationInfo,
        // Đang ở trang 2 -> lùi về trang 1
        defaultPageable: defaultPageable,
        specifiedPageable: null,
      );

      expect(result?.page, equals(1));
    });

    test(
        'Should return next pageable when qryMethod is queryNextPage and within totalPages',
        () {
      final result = PageableCalculator.calculate(
        lastQueryType: QueryType.realQuery,
        qryMethod: BlockQryMethodName.queryNextPage,
        currentPagination: paginationInfo,
        // Đang ở trang 2, tổng 3 trang -> tiến lên trang 3
        defaultPageable: defaultPageable,
        specifiedPageable: null,
      );

      expect(result?.page, equals(3));
    });

    test('Should return null when next page exceeds totalPages', () {
      final lastPagePagination = PaginationInfo(
        currentPage: 3,
        pageSize: 10,
        totalItems: 25,
        totalPages: 3, // Đang ở trang cuối cùng (trang 3)
      );

      final result = PageableCalculator.calculate(
        lastQueryType: QueryType.realQuery,
        qryMethod: BlockQryMethodName.queryNextPage,
        currentPagination: lastPagePagination,
        defaultPageable: defaultPageable,
        specifiedPageable: null,
      );

      expect(
          result, isNull); // Vượt biên -> null để trigger lỗi alreadyOnLastPage
    });

    test(
        'Should return defaultPageable (page 2) when query method is standard query with null specifiedPageable and custom defaultPageable',
        () {
      final customDefaultPageable = Pageable(page: 2, pageSize: 20);
      final result = PageableCalculator.calculate(
        lastQueryType: QueryType.realQuery,
        qryMethod: BlockQryMethodName.query,
        currentPagination: paginationInfo,
        defaultPageable: customDefaultPageable,
        // defaultPageable là trang 2, size 20
        specifiedPageable: null, // Không truyền specifiedPageable
      );

      // Theo logic mới, hệ thống sẽ trả về defaultPageable (trang 2) thay vì trang hiện tại của paginationInfo
      expect(result?.page, equals(2));
      expect(result?.pageSize, equals(20));
    });

    test(
        'Should respect defaultPageable when querying after navigating to page 3 and resetting specifiedPageable to null',
        () {
      final customDefaultPageable = Pageable(page: 2, pageSize: 20);

      // Bước 1: Cố tình giả lập user đang ở trang 3
      final page3Pagination = PaginationInfo(
        currentPage: 3,
        pageSize: 20,
        totalItems: 60,
        totalPages: 3,
      );

      // Bước 2: Gọi query() thông thường nhưng specifiedPageable = null
      final result = PageableCalculator.calculate(
        lastQueryType: QueryType.realQuery,
        qryMethod: BlockQryMethodName.query,
        currentPagination: page3Pagination,
        defaultPageable: customDefaultPageable,
        specifiedPageable: null,
      );

      // Đảm bảo hệ thống fallback về đúng defaultPageable (trang 2) chứ không giữ lại trang 3 cũ
      expect(result?.page, equals(2));
    });
  });
}
