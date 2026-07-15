part of '../core.dart';

class _ProcessedQueryResult<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    FILTER_CRITERIA extends FilterCriteria> {
  final Comparable? parentBlockCurrentItemId;
  final XFilterCriteria<FILTER_CRITERIA>? usedXFilterCriteria;
  final Pageable? usedPageable;

  //
  final List<ITEM>? queriedItemList;
  final PaginationInfo? queriedPaginationInfo;

  // final PageData<ITEM>? queriedPageData;
  final ActionResultState queryResultState;
  final DataState newBlockDataState;
  final bool newHasPendingInvalidation;

  //
  final List<ITEM> validItems;
  final List<ITEM> invalidItems;
  final List<ITEM> errorItems;

  final ErrorInfo? errorInfo;

  _ProcessedQueryResult({
    required this.parentBlockCurrentItemId,
    required this.usedXFilterCriteria,
    required this.usedPageable,
    //
    // required this.queriedPageData,
    required this.queriedItemList,
    required this.queriedPaginationInfo,
    required this.queryResultState,
    required this.newBlockDataState,
    required this.newHasPendingInvalidation,
    required this.validItems,
    required this.invalidItems,
    required this.errorItems,
    required this.errorInfo,
  }) {}
}
