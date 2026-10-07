import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:test/test.dart';

void main() {
  group('BlockQueryPrecheckUtils Tests', () {
    final defaultPageable = Pageable(page: 1, pageSize: 10);
    final paginationInfo = PaginationInfo(
      currentPage: 1,
      pageSize: 10,
      totalItems: 20,
      totalPages: 2,
    );

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final res = BlockQueryPrecheckUtils.checkBeforeQuery(
        checkBusy: true,
        checkAllow: true,
        isBusy: true,
        // System is busy
        qryMethod: BlockQryMethodName.query,
        nativeQueryMode: BlockNativeQueryMode.pageableQuery,
        lastQueryType: QueryType.realQuery,
        defaultPageable: defaultPageable,
        currentPagination: paginationInfo,
        specifiedPageable: null,
        checkQueryAllowed: () => CheckAllowResult.allow(),
      );

      expect(res.actionable.yes, isFalse);
      expect(res.actionable.errCode, equals(BlockQueryPrecheck.busy));
      expect(res.applyPageable, isNull);
    });

    test(
        'Should return pageableNotSupported when fullQuery mode tries to paginate',
        () {
      final res = BlockQueryPrecheckUtils.checkBeforeQuery(
        checkBusy: true,
        checkAllow: true,
        isBusy: false,
        qryMethod: BlockQryMethodName.queryNextPage,
        // Request pagination
        nativeQueryMode: BlockNativeQueryMode.fullQuery,
        // But in full query mode
        lastQueryType: QueryType.realQuery,
        defaultPageable: defaultPageable,
        currentPagination: paginationInfo,
        specifiedPageable: null,
        checkQueryAllowed: () => CheckAllowResult.allow(),
      );

      expect(res.actionable.yes, isFalse);
      expect(res.actionable.errCode,
          equals(BlockQueryPrecheck.pageableNotSupported));
    });

    test(
        'Should return alreadyOnFirstPage when querying previous page on page 1',
        () {
      final res = BlockQueryPrecheckUtils.checkBeforeQuery(
        checkBusy: true,
        checkAllow: true,
        isBusy: false,
        qryMethod: BlockQryMethodName.queryPreviousPage,
        nativeQueryMode: BlockNativeQueryMode.pageableQuery,
        lastQueryType: QueryType.realQuery,
        defaultPageable: defaultPageable,
        currentPagination: paginationInfo,
        // On page 1, previous will return null from calculator
        specifiedPageable: null,
        checkQueryAllowed: () => CheckAllowResult.allow(),
      );

      expect(res.actionable.yes, isFalse);
      expect(res.actionable.errCode,
          equals(BlockQueryPrecheck.alreadyOnFirstPage));
    });

    test(
        'Should return notAllow when business rule checkQueryAllowed returns notAllow',
        () {
      final res = BlockQueryPrecheckUtils.checkBeforeQuery(
        checkBusy: true,
        checkAllow: true,
        isBusy: false,
        qryMethod: BlockQryMethodName.query,
        nativeQueryMode: BlockNativeQueryMode.pageableQuery,
        lastQueryType: QueryType.realQuery,
        defaultPageable: defaultPageable,
        currentPagination: paginationInfo,
        specifiedPageable: null,
        checkQueryAllowed: () => CheckAllowResult.notAllow(), // Disallowed
      );

      expect(res.actionable.yes, isFalse);
      expect(res.actionable.errCode, equals(BlockQueryPrecheck.notAllow));
    });

    test('Should return yes and correct isQueryMoreFlow when all checks pass',
        () {
      final res = BlockQueryPrecheckUtils.checkBeforeQuery(
        checkBusy: true,
        checkAllow: true,
        isBusy: false,
        qryMethod: BlockQryMethodName.queryMore,
        // Query more flow
        nativeQueryMode: BlockNativeQueryMode.pageableQuery,
        lastQueryType: QueryType.realQuery,
        defaultPageable: defaultPageable,
        currentPagination: paginationInfo,
        specifiedPageable: null,
        checkQueryAllowed: () => CheckAllowResult.allow(),
      );

      expect(res.actionable.yes, isTrue);
      expect(res.isQueryMoreFlow, isTrue); // Verify query more flag
      expect(res.applyPageable, isNotNull);
    });
  });
}
