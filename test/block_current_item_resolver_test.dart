import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock domain models representing domain entities
class MockItem {
  final String id;
  final String name;

  MockItem({required this.id, required this.name});
}

class MockItemDetail {
  final String id;
  final String name;
  final String description;

  MockItemDetail({
    required this.id,
    required this.name,
    required this.description,
  });
}

void main() {
  group('BlockCurrentItemResolver Tests', () {
    final candidateItem = MockItem(id: 'item_1', name: 'Sample Item');

    // Central test helper mirroring the updated resolveCurrentItemInternal signature
    BlockCurrentItemPlan executeInternal({
      Type? itemType,
      Type? itemDetailType,
      Object? candidateCurrItem,
      bool inputForceReloadItem = false,
      bool provideBlockContext = true,
      bool provideItemContext = true,
      bool provideFormContext = false,
      ItemAbsentRepresentativePolicy itemAbsentRepresentativePolicy =
          ItemAbsentRepresentativePolicy.tryNotSetAnItemAsCurrent,
      UnifiedItemRefreshPolicy unifiedItemRefreshPolicy =
          UnifiedItemRefreshPolicy.auto,
      BlockSetCurrentItemDirective setCurrentItemDirective =
          BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed,
      bool isCandidateCurrentItemInNewQueriedList = false,
      bool isCandidateItemDifferentFromCurrent = false,
      bool debug = false,
    }) {
      return BlockCurrentItemResolver.resolveCurrentItemInternal(
        executionTrace: null,
        itemType: itemType ?? MockItem,
        itemDetailType: itemDetailType ?? MockItemDetail,
        candidateCurrItem: candidateCurrItem ?? candidateItem,
        inputForceReloadItem: inputForceReloadItem,
        provideBlockContext: provideBlockContext,
        provideItemContext: provideItemContext,
        provideFormContext: provideFormContext,
        itemAbsentRepresentativePolicy: itemAbsentRepresentativePolicy,
        unifiedItemRefreshPolicy: unifiedItemRefreshPolicy,
        setCurrentItemDirective: setCurrentItemDirective,
        isCandidateCurrentItemInNewQueriedList:
            isCandidateCurrentItemInNewQueriedList,
        isCandidateItemDifferentFromCurrent:
            isCandidateItemDifferentFromCurrent,
        debug: debug,
      );
    }

    // =========================================================================
    // SECTION 1: CANDIDATE ACCEPTANCE TESTS
    // =========================================================================
    group('Section 1 - Candidate Acceptance Logic', () {
      test(
          '1.1 Existing current item is unconditionally retained across queries',
          () {
        // Even if the existing current item is not in the newly queried batch
        // and no UI demands an item context, it must remain accepted.
        final plan = executeInternal(
          setCurrentItemDirective:
              BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed,
          isCandidateItemDifferentFromCurrent: false,
          isCandidateCurrentItemInNewQueriedList: false,
          provideItemContext: false,
        );
        expect(plan.candidateAccepted, isTrue);
      });

      test(
          '1.2 New candidate accepted when item context is active and present in batch',
          () {
        // When there is no current item (different = true), but UI needs an item
        // and candidate belongs to the queried list -> accepted.
        final plan = executeInternal(
          setCurrentItemDirective:
              BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed,
          isCandidateItemDifferentFromCurrent: true,
          isCandidateCurrentItemInNewQueriedList: true,
          provideItemContext: true,
        );
        expect(plan.candidateAccepted, isTrue);
      });

      test(
          '1.3 Empty workspace protection: Candidate rejected when no UI demands item',
          () {
        // Crucial fix: When no current item exists and provideItemContext == false
        // under tryNotSetAnItemAsCurrent, candidate must NOT be accepted.
        final plan = executeInternal(
          setCurrentItemDirective:
              BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed,
          isCandidateItemDifferentFromCurrent: true,
          isCandidateCurrentItemInNewQueriedList: true,
          provideItemContext: false,
          itemAbsentRepresentativePolicy:
              ItemAbsentRepresentativePolicy.tryNotSetAnItemAsCurrent,
        );
        expect(plan.candidateAccepted, isFalse);
      });

      test(
          '1.4 Sibling/Fallback candidate accepted when UI demands item context even if absent from query batch',
          () {
        // When an item is deleted and a replacement/sibling candidate is nominated,
        // it must be accepted if UI demands an item context, even if absent from the new query batch.
        final plan = executeInternal(
          setCurrentItemDirective:
              BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed,
          isCandidateItemDifferentFromCurrent: true,
          isCandidateCurrentItemInNewQueriedList: false,
          provideItemContext: true,
        );
        expect(plan.candidateAccepted, isTrue);
      });

      test(
          '1.5 Policy trySetAnItemAsCurrent escalates acceptance for candidate even if provideItemContext is false',
          () {
        // Policy forces provideItemContextExt to true -> accepted.
        final plan = executeInternal(
          setCurrentItemDirective:
              BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed,
          isCandidateItemDifferentFromCurrent: true,
          isCandidateCurrentItemInNewQueriedList: false,
          provideItemContext: false,
          itemAbsentRepresentativePolicy:
              ItemAbsentRepresentativePolicy.trySetAnItemAsCurrent,
        );
        expect(plan.candidateAccepted, isTrue);
      });

      test('1.6 Explicit selection directives unconditionally accept candidate',
          () {
        for (final directive in [
          BlockSetCurrentItemDirective.setAnItemAsCurrent,
          BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm,
          BlockSetCurrentItemDirective.refresh,
        ]) {
          final plan = executeInternal(
            setCurrentItemDirective: directive,
            isCandidateItemDifferentFromCurrent: true,
            isCandidateCurrentItemInNewQueriedList: false,
            provideItemContext: false,
          );
          expect(plan.candidateAccepted, isTrue);
        }
      });
    });

    // =========================================================================
    // SECTION 2: UI CONTEXT & POLICY EXTENSIONS
    // =========================================================================
    group('Section 2 - UI Representative Extensions', () {
      test(
          '2.1 Extended via ItemAbsentRepresentativePolicy.trySetAnItemAsCurrent',
          () {
        final plan = executeInternal(
          provideItemContext: false,
          itemAbsentRepresentativePolicy:
              ItemAbsentRepresentativePolicy.trySetAnItemAsCurrent,
          isCandidateItemDifferentFromCurrent: true,
          isCandidateCurrentItemInNewQueriedList: true,
        );
        expect(plan.forceReloadItem, isTrue);
      });

      test(
          '2.2 Disabled via ItemAbsentRepresentativePolicy.tryNotSetAnItemAsCurrent',
          () {
        final plan = executeInternal(
          provideItemContext: false,
          itemAbsentRepresentativePolicy:
              ItemAbsentRepresentativePolicy.tryNotSetAnItemAsCurrent,
          isCandidateItemDifferentFromCurrent: true,
          isCandidateCurrentItemInNewQueriedList: true,
        );
        expect(plan.forceReloadItem, isFalse);
      });

      test('2.3 Directives override provideItemContext to true', () {
        for (final directive in [
          BlockSetCurrentItemDirective.setAnItemAsCurrent,
          BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm,
        ]) {
          final plan = executeInternal(
            provideItemContext: false,
            setCurrentItemDirective: directive,
            isCandidateItemDifferentFromCurrent: true,
          );
          expect(plan.forceReloadItem, isTrue);
        }
      });
    });

    // =========================================================================
    // SECTION 3: UNIFORM ITEM OPTIMIZATION (ITEM == ITEM_DETAIL)
    // =========================================================================
    group('Section 3 - Uniform Item Optimization (ITEM == ITEM_DETAIL)', () {
      test(
          '3.1 UnifiedItemRefreshPolicy.always bypasses optimization and forces reload',
          () {
        final plan = executeInternal(
          itemType: MockItem,
          itemDetailType: MockItem,
          unifiedItemRefreshPolicy: UnifiedItemRefreshPolicy.always,
          isCandidateCurrentItemInNewQueriedList: true,
          isCandidateItemDifferentFromCurrent: true,
        );
        expect(plan.forceReloadItem, isTrue);
      });

      test(
          '3.2 UnifiedItemRefreshPolicy.auto skips detail fetch when present in batch',
          () {
        final plan = executeInternal(
          itemType: MockItem,
          itemDetailType: MockItem,
          unifiedItemRefreshPolicy: UnifiedItemRefreshPolicy.auto,
          isCandidateCurrentItemInNewQueriedList: true,
          isCandidateItemDifferentFromCurrent: true,
        );
        expect(plan.forceReloadItem, isFalse);
      });

      test(
          '3.3 UnifiedItemRefreshPolicy.auto cannot skip when absent from batch',
          () {
        final plan = executeInternal(
          itemType: MockItem,
          itemDetailType: MockItem,
          unifiedItemRefreshPolicy: UnifiedItemRefreshPolicy.auto,
          isCandidateCurrentItemInNewQueriedList: false,
          isCandidateItemDifferentFromCurrent: true,
          setCurrentItemDirective:
              BlockSetCurrentItemDirective.setAnItemAsCurrent,
        );
        expect(plan.forceReloadItem, isTrue);
      });

      test(
          '3.4 Non-uniform type (ITEM != ITEM_DETAIL) cannot skip detail fetch',
          () {
        final plan = executeInternal(
          itemType: MockItem,
          itemDetailType: MockItemDetail,
          unifiedItemRefreshPolicy: UnifiedItemRefreshPolicy.auto,
          isCandidateCurrentItemInNewQueriedList: true,
          isCandidateItemDifferentFromCurrent: true,
        );
        expect(plan.forceReloadItem, isTrue);
      });
    });

    // =========================================================================
    // SECTION 4: FORCE RELOAD ITEM CALCULATION
    // =========================================================================
    group('Section 4 - Force Reload Item Calculation', () {
      test('4.1 Explicit refresh directive triggers force reload', () {
        final plan = executeInternal(
          setCurrentItemDirective: BlockSetCurrentItemDirective.refresh,
          inputForceReloadItem: false,
        );
        expect(plan.forceReloadItem, isTrue);
      });

      test('4.2 inputForceReloadItem flag triggers force reload', () {
        final plan = executeInternal(
          inputForceReloadItem: true,
          isCandidateItemDifferentFromCurrent: false,
          isCandidateCurrentItemInNewQueriedList: false,
        );
        expect(plan.forceReloadItem, isTrue);
      });

      test('4.3 Suppressed when no item representative is active on UI', () {
        final plan = executeInternal(
          provideItemContext: false,
          isCandidateItemDifferentFromCurrent: true,
          isCandidateCurrentItemInNewQueriedList: true,
          itemAbsentRepresentativePolicy:
              ItemAbsentRepresentativePolicy.tryNotSetAnItemAsCurrent,
        );
        expect(plan.forceReloadItem, isFalse);
      });

      test('4.4 Current item ID changed triggers detail fetch', () {
        final plan = executeInternal(
          provideItemContext: true,
          isCandidateItemDifferentFromCurrent: true,
          isCandidateCurrentItemInNewQueriedList: true,
        );
        expect(plan.forceReloadItem, isTrue);
      });

      test(
          '4.5 Retained current item present in new queried batch triggers detail refresh',
          () {
        // Item is unchanged, but newly queried batch contains updated fields -> refresh
        final plan = executeInternal(
          provideItemContext: true,
          isCandidateItemDifferentFromCurrent: false,
          isCandidateCurrentItemInNewQueriedList: true,
        );
        expect(plan.forceReloadItem, isTrue);
      });

      test(
          '4.6 Retained current item absent from newly queried batch remains stable without reload',
          () {
        // Pagination / Append batch does not contain the current item -> keep stable, no reload
        final plan = executeInternal(
          provideItemContext: true,
          isCandidateItemDifferentFromCurrent: false,
          isCandidateCurrentItemInNewQueriedList: false,
        );
        expect(plan.forceReloadItem, isFalse);
      });
    });
  });
}
