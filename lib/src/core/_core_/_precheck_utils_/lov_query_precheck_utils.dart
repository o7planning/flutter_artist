part of '__precheck_utils.dart';

/// Result container holding the precheck decision and resolved pageable target for LOV queries.
class LovQueryPrecheckResult {
  /// The precheck outcome indicating whether the query is permitted.
  final Actionable<LovQueryPrecheck> actionable;

  /// The resolved pageable configuration to apply for the query, if applicable.
  final Pageable? applyPageable;

  /// Flag indicating whether this query execution belongs to a "query more" flow.
  final bool isQueryMoreFlow;

  LovQueryPrecheckResult({
    required this.actionable,
    required this.applyPageable,
    required this.isQueryMoreFlow,
  });
}

/// Utility class containing pure precheck logic for all LOV query operations.
class LovQueryPrecheckUtils {
  /// Unified precheck handler for all types of LOV queries (standard & paginated).
  static LovQueryPrecheckResult checkBeforeQuery({
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
    final bool isQueryMoreFlow = qryMethod == BlockQryMethodName.queryMore;

    // Priority 1: Always check if the system is busy first.
    if (checkBusy && isBusy) {
      return LovQueryPrecheckResult(
        actionable: Actionable<LovQueryPrecheck>.no(
          errCode: LovQueryPrecheck.busy,
        ),
        applyPageable: null,
        isQueryMoreFlow: isQueryMoreFlow,
      );
    }

    Pageable? applyPageable;

    // Priority 2: Handle pagination mode and boundary validation.
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
        return LovQueryPrecheckResult(
          actionable: Actionable<LovQueryPrecheck>.no(
            errCode: isPreviousQry
                ? LovQueryPrecheck.alreadyOnFirstPage
                : LovQueryPrecheck.alreadyOnLastPage,
          ),
          applyPageable: null,
          isQueryMoreFlow: isQueryMoreFlow,
        );
      }
    } else {
      final bool requirePageable = specifiedPageable != null ||
          qryMethod == BlockQryMethodName.queryNextPage ||
          qryMethod == BlockQryMethodName.queryPreviousPage ||
          qryMethod == BlockQryMethodName.queryMore;
      if (requirePageable) {
        return LovQueryPrecheckResult(
          actionable: Actionable<LovQueryPrecheck>.no(
            errCode: LovQueryPrecheck.pageableNotSupported,
          ),
          applyPageable: null,
          isQueryMoreFlow: isQueryMoreFlow,
        );
      }
    }

    // Priority 3: Check business permission rules.
    if (checkAllow) {
      final CheckAllowResult result = checkQueryAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return LovQueryPrecheckResult(
            actionable: Actionable<LovQueryPrecheck>.yes(),
            applyPageable: applyPageable,
            isQueryMoreFlow: isQueryMoreFlow,
          );
        case CheckAllow.notAllow:
          return LovQueryPrecheckResult(
            actionable: Actionable<LovQueryPrecheck>.no(
              errCode: LovQueryPrecheck.notAllowed,
            ),
            applyPageable: null,
            isQueryMoreFlow: isQueryMoreFlow,
          );
        case CheckAllow.error:
          return LovQueryPrecheckResult(
            actionable: Actionable<LovQueryPrecheck>.no(
              errCode: LovQueryPrecheck.checkAllowMethodError,
              errorInfo: result.errorInfo,
            ),
            applyPageable: null,
            isQueryMoreFlow: isQueryMoreFlow,
          );
      }
    }

    return LovQueryPrecheckResult(
      actionable: Actionable<LovQueryPrecheck>.yes(),
      applyPageable: applyPageable,
      isQueryMoreFlow: isQueryMoreFlow,
    );
  }
}
