part of '__precheck_utils.dart';

/// Result container holding the precheck decision and resolved pageable target for queries.
class BlockQueryPrecheckResult {
  /// The precheck outcome indicating whether the query is permitted.
  final Actionable<BlockQueryPrecheck> actionable;

  /// The resolved pageable configuration to apply for the query, if applicable.
  final Pageable? applyPageable;

  /// Flag indicating whether this query execution belongs to a "query more" flow.
  final bool isQueryMoreFlow;

  BlockQueryPrecheckResult({
    required this.actionable,
    required this.applyPageable,
    required this.isQueryMoreFlow,
  });
}

/// Utility class containing pure precheck logic for all block query operations.
class BlockQueryPrecheckUtils {
  /// Unified precheck handler for all types of block queries (standard & paginated).
  ///
  /// - [checkBusy] & [isBusy]: Enforces system-wide busy check first.
  /// - [nativeQueryMode] & pagination rules: Validates compatibility and boundary conditions.
  /// - [checkAllow] & [checkQueryAllowed]: Evaluates business permission rules.
  static BlockQueryPrecheckResult checkBeforeQuery({
    required bool checkBusy,
    required bool checkAllow,
    required bool isBusy,
    required BlockQryMethodName qryMethod,
    required BlockNativeQueryMode nativeQueryMode,
    required QueryType lastQueryType,
    required Pageable defaultPageable,
    required PaginationInfo? currentPagination,
    required Pageable? specifiedPageable,
    required CheckAllowResult Function() checkQueryAllowed,
  }) {
    // Identify if the current method execution belongs to a query more flow
    final bool isQueryMoreFlow = qryMethod == BlockQryMethodName.queryMore;

    // Priority 1: Always check if the system is busy first
    if (checkBusy && isBusy) {
      return BlockQueryPrecheckResult(
        actionable: Actionable<BlockQueryPrecheck>.no(
          errCode: BlockQueryPrecheck.busy,
        ),
        applyPageable: null,
        isQueryMoreFlow: isQueryMoreFlow,
      );
    }

    Pageable? applyPageable;

    // Handle pageableQuery mode logic and boundary validation
    if (nativeQueryMode == BlockNativeQueryMode.pageableQuery) {
      applyPageable = PageableCalculator.calculate(
        lastQueryType: lastQueryType,
        qryMethod: qryMethod,
        currentPagination: currentPagination,
        defaultPageable: defaultPageable,
        specifiedPageable: specifiedPageable,
      );
      final bool isPreviousQry =
          qryMethod == BlockQryMethodName.queryPreviousPage;
      if (applyPageable == null) {
        return BlockQueryPrecheckResult(
          actionable: Actionable<BlockQueryPrecheck>.no(
            errCode: isPreviousQry
                ? BlockQueryPrecheck.alreadyOnFirstPage
                : BlockQueryPrecheck.alreadyOnLastPage,
          ),
          applyPageable: null,
          isQueryMoreFlow: isQueryMoreFlow,
        );
      }
    }
    // Handle fullQuery mode (pagination is not supported)
    else {
      final bool requirePageable = specifiedPageable != null ||
          qryMethod == BlockQryMethodName.queryNextPage ||
          qryMethod == BlockQryMethodName.queryPreviousPage ||
          qryMethod == BlockQryMethodName.queryMore;
      if (requirePageable) {
        return BlockQueryPrecheckResult(
          actionable: Actionable<BlockQueryPrecheck>.no(
            errCode: BlockQueryPrecheck.pageableNotSupported,
          ),
          applyPageable: null,
          isQueryMoreFlow: isQueryMoreFlow,
        );
      }
    }

    // Priority 3: Check business permission rules
    if (checkAllow) {
      final CheckAllowResult result = checkQueryAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return BlockQueryPrecheckResult(
            actionable: Actionable<BlockQueryPrecheck>.yes(),
            applyPageable: applyPageable,
            isQueryMoreFlow: isQueryMoreFlow,
          );
        case CheckAllow.notAllow:
          return BlockQueryPrecheckResult(
            actionable: Actionable<BlockQueryPrecheck>.no(
              errCode: BlockQueryPrecheck.notAllow,
            ),
            applyPageable: null,
            isQueryMoreFlow: isQueryMoreFlow,
          );
        case CheckAllow.error:
          return BlockQueryPrecheckResult(
            actionable: Actionable<BlockQueryPrecheck>.no(
              errCode: BlockQueryPrecheck.checkAllowMethodError,
              errorInfo: result.errorInfo,
            ),
            applyPageable: null,
            isQueryMoreFlow: isQueryMoreFlow,
          );
      }
    }

    return BlockQueryPrecheckResult(
      actionable: Actionable<BlockQueryPrecheck>.yes(),
      applyPageable: applyPageable,
      isQueryMoreFlow: isQueryMoreFlow,
    );
  }
}
