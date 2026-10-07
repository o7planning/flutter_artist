import 'package:flutter_artist/flutter_artist.dart';
import 'package:test/test.dart';

void main() {
  group('BlockBackendActionPrecheckUtils Tests', () {
    const defaultBlockDataState = BlockDataStateLoadedFresh();

    test('Should return busy error when checkBusy is true and isBusy is true',
        () {
      final result =
          BlockBackendActionPrecheckUtils.checkBeforeExecuteBackendAction(
        checkBusy: true,
        isBusy: true, // System is busy
        blockDataState: defaultBlockDataState,
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
        blockDataState: const BlockDataStateNone(), // Block in none state
      );

      expect(result.yes, isFalse);
      expect(
          result.errCode, equals(BlockBackendActionPrecheck.blockInNoneState));
    });

    test(
        'Should return blockInPendingState error when block is in pending state',
        () {
      final result =
          BlockBackendActionPrecheckUtils.checkBeforeExecuteBackendAction(
        checkBusy: true,
        isBusy: false,
        blockDataState: const BlockDataStatePending(), // Block in pending state
      );

      expect(result.yes, isFalse);
      expect(result.errCode,
          equals(BlockBackendActionPrecheck.blockInPendingState));
    });

    test('Should return blockInStaleState error when block is in stale state',
        () {
      final result =
          BlockBackendActionPrecheckUtils.checkBeforeExecuteBackendAction(
        checkBusy: true,
        isBusy: false,
        blockDataState:
            BlockDataStateLoadedStale.event(), // Block in stale state
      );

      expect(result.yes, isFalse);
      expect(
          result.errCode, equals(BlockBackendActionPrecheck.blockInStaleState));
    });

    test(
        'Should return yes when block dataState is loaded fresh and system is not busy',
        () {
      final result =
          BlockBackendActionPrecheckUtils.checkBeforeExecuteBackendAction(
        checkBusy: true,
        isBusy: false,
        blockDataState: defaultBlockDataState, // Loaded fresh
      );

      expect(result.yes, isTrue);
    });
  });
}
