import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:test/test.dart';

void main() {
  group('BlockItemsDeletionPrecheckUtils Tests', () {
    const List<String> mockItems = ['item_1', 'item_2'];

    test('Should return busy when checkBusy is true and isBusy is true', () {
      final result =
          BlockItemsDeletionPrecheckUtils.checkBeforeDeleteItems<String>(
        checkBusy: true,
        isBusy: true,
        checkAllow: true,
        items: mockItems,
        errorIfItemNotInTheBlock: true,
        findItemSameIdWith: (target) => target,
        checkItemsDeletionAllowed: (_) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemsDeletionPrecheck.busy));
    });

    test('Should return noTarget when items list is empty', () {
      final result =
          BlockItemsDeletionPrecheckUtils.checkBeforeDeleteItems<String>(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        items: [],
        errorIfItemNotInTheBlock: true,
        findItemSameIdWith: (target) => target,
        checkItemsDeletionAllowed: (_) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemsDeletionPrecheck.noTarget));
    });

    test('Should return invalidTarget when an item is not found in the block',
        () {
      final result =
          BlockItemsDeletionPrecheckUtils.checkBeforeDeleteItems<String>(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        items: mockItems,
        errorIfItemNotInTheBlock: true,
        findItemSameIdWith: (target) =>
            target == 'item_1' ? target : null, // item_2 không tìm thấy
        checkItemsDeletionAllowed: (_) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemsDeletionPrecheck.invalidTarget));
    });

    test('Should return notAllow when deletion is disallowed for an item', () {
      final result =
          BlockItemsDeletionPrecheckUtils.checkBeforeDeleteItems<String>(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        items: mockItems,
        errorIfItemNotInTheBlock: true,
        findItemSameIdWith: (target) => target,
        checkItemsDeletionAllowed: (item) => item == 'item_2'
            ? CheckAllowResult.notAllow()
            : CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemsDeletionPrecheck.notAllow));
    });

    test(
        'Should return checkAllowMethodError when allow check returns an error',
        () {
      final mockErrorInfo = ErrorInfo(
          errorMessage: 'Batch check error',
          errorDetails: null,
          stackTrace: null);

      final result =
          BlockItemsDeletionPrecheckUtils.checkBeforeDeleteItems<String>(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        items: mockItems,
        errorIfItemNotInTheBlock: true,
        findItemSameIdWith: (target) => target,
        checkItemsDeletionAllowed: (_) =>
            CheckAllowResult.error(errorInfo: mockErrorInfo),
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(BlockItemsDeletionPrecheck.checkAllowMethodError));
      expect(result.errorInfo, equals(mockErrorInfo));
    });

    test(
        'Should return yes when all conditions pass successfully for all items',
        () {
      final result =
          BlockItemsDeletionPrecheckUtils.checkBeforeDeleteItems<String>(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        items: mockItems,
        errorIfItemNotInTheBlock: true,
        findItemSameIdWith: (target) => target,
        checkItemsDeletionAllowed: (_) => CheckAllowResult.allow(),
      );

      expect(result.yes, isTrue);
    });
  });
}
