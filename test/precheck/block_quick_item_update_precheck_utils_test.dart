import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:test/test.dart';

void main() {
  group('BlockQuickItemUpdatePrecheckUtils Tests', () {
    const defaultBlockDataState = BlockDataStateLoadedFresh();
    const testItem = 'Item A';
    final List<String> mockItemList = [testItem, 'Item B'];

    // Mock helper to check whether an item exists in the block's item list.
    bool mockContainsItem(String item) => mockItemList.contains(item);

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: true,
        blockDataState: defaultBlockDataState,
        item: testItem,
        errorIfItemNotInTheBlock: true,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockQuickItemUpdatePrecheck.busy));
    });

    test('Should return blockInNoneState error when block is in none state',
        () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: const BlockDataStateNone(),
        item: testItem,
        errorIfItemNotInTheBlock: true,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockQuickItemUpdatePrecheck.blockInNoneState),
      );
    });

    test(
        'Should return blockInPendingState error when block is in pending state',
        () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: const BlockDataStatePending(),
        item: testItem,
        errorIfItemNotInTheBlock: true,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockQuickItemUpdatePrecheck.blockInPendingState),
      );
    });

    test('Should return blockInStaleState error when block is in stale state',
        () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: BlockDataStateLoadedStale.event(),
        item: testItem,
        errorIfItemNotInTheBlock: true,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockQuickItemUpdatePrecheck.blockInStaleState),
      );
    });

    test('Should return noTarget error when item is null', () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        item: null,
        errorIfItemNotInTheBlock: true,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockQuickItemUpdatePrecheck.noTarget));
    });

    test(
        'Should return invalidTarget error when errorIfItemNotInTheBlock is true and item does not exist in the list',
        () {
      const nonExistentItem = 'Item X';

      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        item: nonExistentItem,
        errorIfItemNotInTheBlock: true,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockQuickItemUpdatePrecheck.invalidTarget),
      );
    });

    test(
        'Should return yes when errorIfItemNotInTheBlock is false even if item does not exist in the list',
        () {
      const nonExistentItem = 'Item X';

      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        item: nonExistentItem,
        errorIfItemNotInTheBlock: false,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isTrue);
    });

    test(
        'Should return notAllowed when business rule checkQuickUpdateAllowed returns notAllowed',
        () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        item: testItem,
        errorIfItemNotInTheBlock: true,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: () => CheckAllowResult.notAllowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockQuickItemUpdatePrecheck.notAllowed));
    });

    test(
        'Should return checkAllowMethodError when checkQuickUpdateAllowed returns error',
        () {
      final mockErrorInfo = ErrorInfo.fromError(
        error: Exception('Permission check failed'),
        stackTrace: StackTrace.current,
      );

      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        item: testItem,
        errorIfItemNotInTheBlock: true,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: () =>
            CheckAllowResult.error(errorInfo: mockErrorInfo),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockQuickItemUpdatePrecheck.checkAllowMethodError),
      );
      expect(result.errorInfo, equals(mockErrorInfo));
    });

    test('Should skip permission check and return yes when checkAllow is false',
        () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        item: testItem,
        errorIfItemNotInTheBlock: true,
        containsItem: mockContainsItem,
        checkAllow: false,
        checkQuickUpdateAllowed: () => CheckAllowResult.notAllowed(),
      );

      expect(result.yes, isTrue);
    });

    test('Should return yes when all precheck conditions pass successfully',
        () {
      final result =
          BlockQuickItemUpdatePrecheckUtils.checkBeforeQuickUpdateItem<String>(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        item: testItem,
        errorIfItemNotInTheBlock: true,
        containsItem: mockContainsItem,
        checkAllow: true,
        checkQuickUpdateAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isTrue);
    });
  });
}
