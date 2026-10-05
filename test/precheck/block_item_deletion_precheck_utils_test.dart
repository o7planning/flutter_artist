import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:test/test.dart';

void main() {
  group('BlockItemDeletionPrecheckUtils Tests', () {
    // Khai báo một mock item đơn giản để test
    const String mockItem = 'item_123';

    test('Should return busy when checkBusy is true and isBusy is true', () {
      final result =
          BlockItemDeletionPrecheckUtils.checkBeforeDeleteItem<String>(
        checkBusy: true,
        isBusy: true,
        errorIfItemNotInTheBlock: true,
        item: mockItem,
        errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
        checkAllow: true,
        findItemSameIdWith: (target) => target,
        checkItemDeletionAllowed: (_) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemDeletionPrecheck.busy));
    });

    test(
        'Should return noTarget when item is null and errCodeIfItemIsNull is noTarget',
        () {
      final result =
          BlockItemDeletionPrecheckUtils.checkBeforeDeleteItem<String>(
        checkBusy: true,
        isBusy: false,
        errorIfItemNotInTheBlock: true,
        item: null,
        errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
        checkAllow: true,
        findItemSameIdWith: (target) => target,
        checkItemDeletionAllowed: (_) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemDeletionPrecheck.noTarget));
    });

    test(
        'Should return invalidTarget when item is null and errCodeIfItemIsNull is invalidTarget',
        () {
      final result =
          BlockItemDeletionPrecheckUtils.checkBeforeDeleteItem<String>(
        checkBusy: true,
        isBusy: false,
        errorIfItemNotInTheBlock: true,
        item: null,
        errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
        checkAllow: true,
        findItemSameIdWith: (target) => target,
        checkItemDeletionAllowed: (_) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemDeletionPrecheck.invalidTarget));
    });

    test(
        'Should return invalidTarget when errorIfItemNotInTheBlock is true and item is not found',
        () {
      final result =
          BlockItemDeletionPrecheckUtils.checkBeforeDeleteItem<String>(
        checkBusy: true,
        isBusy: false,
        errorIfItemNotInTheBlock: true,
        item: mockItem,
        errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
        checkAllow: true,
        findItemSameIdWith: (target) =>
            null, // Giả lập không tìm thấy item trong block
        checkItemDeletionAllowed: (_) => CheckAllowResult.allow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemDeletionPrecheck.invalidTarget));
    });

    test(
        'Should return notAllow when checkAllow is true and checkItemDeletionAllowed returns notAllow',
        () {
      final result =
          BlockItemDeletionPrecheckUtils.checkBeforeDeleteItem<String>(
        checkBusy: true,
        isBusy: false,
        errorIfItemNotInTheBlock: true,
        item: mockItem,
        errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
        checkAllow: true,
        findItemSameIdWith: (target) => target,
        checkItemDeletionAllowed: (_) => CheckAllowResult.notAllow(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockItemDeletionPrecheck.notAllow));
    });

    test('Should return checkAllowMethodError when checkAllow returns error',
        () {
      final mockErrorInfo = ErrorInfo(
          errorMessage: 'Custom rule error',
          errorDetails: null,
          stackTrace: null);

      final result =
          BlockItemDeletionPrecheckUtils.checkBeforeDeleteItem<String>(
        checkBusy: true,
        isBusy: false,
        errorIfItemNotInTheBlock: true,
        item: mockItem,
        errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
        checkAllow: true,
        findItemSameIdWith: (target) => target,
        checkItemDeletionAllowed: (_) =>
            CheckAllowResult.error(errorInfo: mockErrorInfo),
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(BlockItemDeletionPrecheck.checkAllowMethodError));
      expect(result.errorInfo, equals(mockErrorInfo));
    });

    test('Should return yes when all conditions pass successfully', () {
      final result =
          BlockItemDeletionPrecheckUtils.checkBeforeDeleteItem<String>(
        checkBusy: true,
        isBusy: false,
        errorIfItemNotInTheBlock: true,
        item: mockItem,
        errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
        checkAllow: true,
        findItemSameIdWith: (target) => target,
        checkItemDeletionAllowed: (_) => CheckAllowResult.allow(),
      );

      expect(result.yes, isTrue);
    });
  });
}
