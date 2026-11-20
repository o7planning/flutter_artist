import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:test/test.dart';

void main() {
  group('BlockBackendActionPrecheckUtils Tests', () {
    const defaultBlockDataState = BlockDataStateLoadedFresh();

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result =
          BlockBackendActionPrecheckUtils.checkBeforeExecuteBackendAction(
        checkBusy: true,
        isBusy: true,
        // System is busy
        blockDataState: defaultBlockDataState,
        checkAllow: true,
        checkBackendActionAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockBackendActionPrecheck.busy));
    });

    test('Should return blockInNoneState error when block is in none state',
        () {
      final result =
          BlockBackendActionPrecheckUtils.checkBeforeExecuteBackendAction(
        checkBusy: true,
        isBusy: false,
        blockDataState: const BlockDataStateNone(),
        // Block in none state
        checkAllow: true,
        checkBackendActionAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockBackendActionPrecheck.blockInNoneState),
      );
    });

    test(
        'Should return blockInPendingState error when block is in pending state',
        () {
      final result =
          BlockBackendActionPrecheckUtils.checkBeforeExecuteBackendAction(
        checkBusy: true,
        isBusy: false,
        blockDataState: const BlockDataStatePending(),
        // Block in pending state
        checkAllow: true,
        checkBackendActionAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockBackendActionPrecheck.blockInPendingState),
      );
    });

    test('Should return blockInStaleState error when block is in stale state',
        () {
      final result =
          BlockBackendActionPrecheckUtils.checkBeforeExecuteBackendAction(
        checkBusy: true,
        isBusy: false,
        blockDataState: BlockDataStateLoadedStale.event(),
        // Block in stale state
        checkAllow: true,
        checkBackendActionAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockBackendActionPrecheck.blockInStaleState),
      );
    });

    test(
        'Should return notAllowed when business rule checkBackendActionAllowed returns notAllowed',
        () {
      final result =
          BlockBackendActionPrecheckUtils.checkBeforeExecuteBackendAction(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        checkAllow: true,
        checkBackendActionAllowed: () => CheckAllowResult.notAllowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, equals(BlockBackendActionPrecheck.notAllowed));
    });

    test(
        'Should return checkAllowMethodError when checkBackendActionAllowed returns error',
        () {
      final mockErrorInfo = ErrorInfo.fromError(
        error: Exception('Permission check failed'),
        stackTrace: StackTrace.current,
      );

      final result =
          BlockBackendActionPrecheckUtils.checkBeforeExecuteBackendAction(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        checkAllow: true,
        checkBackendActionAllowed: () =>
            CheckAllowResult.error(errorInfo: mockErrorInfo),
      );

      expect(result.yes, isFalse);
      expect(
        result.errCode,
        equals(BlockBackendActionPrecheck.checkAllowMethodError),
      );
      expect(result.errorInfo, equals(mockErrorInfo));
    });

    test('Should skip permission check and return yes when checkAllow is false',
        () {
      final result =
          BlockBackendActionPrecheckUtils.checkBeforeExecuteBackendAction(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        checkAllow: false,
        checkBackendActionAllowed: () => CheckAllowResult.notAllowed(),
      );

      expect(result.yes, isTrue);
    });

    test(
        'Should return yes when block dataState is loaded fresh, system is not busy, and action is allowed',
        () {
      final result =
          BlockBackendActionPrecheckUtils.checkBeforeExecuteBackendAction(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState,
        // Loaded fresh
        checkAllow: true,
        checkBackendActionAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isTrue);
    });
  });
}
