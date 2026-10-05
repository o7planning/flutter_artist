import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/error/_block_error_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlockDataStateUtils.calculateNewLazyDataState', () {
    final mockBlockErrorInfo = BlockErrorInfo(
      blockErrorMethod: BlockErrorMethod.performQuery,
      error: 'API 500 Internal Server Error',
      errorStackTrace: StackTrace.empty,
    );

    test('Child block: transitions to None when hasParentItem is false', () {
      final nextState = BlockDataStateUtils.calculateNewLazyDataState(
        currentBlockDataState: const BlockDataStateLoadedFresh(),
        hasParentItem: false,
        isRootBlock: false,
        parentItemChanged: false,
        filterCriteriaChanged: false,
      );

      expect(nextState, isA<BlockDataStateNone>());
    });

    test('Root block: stays viable even when hasParentItem is false', () {
      const rootFresh = BlockDataStateLoadedFresh();

      final nextState = BlockDataStateUtils.calculateNewLazyDataState(
        currentBlockDataState: rootFresh,
        hasParentItem: false,
        isRootBlock: true,
        parentItemChanged: false,
        filterCriteriaChanged: false,
      );

      expect(nextState, equals(rootFresh));
    });

    test(
        'Child block: evicts cache to Pending.initial when parentItemChanged is true',
        () {
      final nextState = BlockDataStateUtils.calculateNewLazyDataState(
        currentBlockDataState: const BlockDataStateLoadedFresh(),
        hasParentItem: true,
        isRootBlock: false,
        parentItemChanged: true,
        filterCriteriaChanged: false,
      );

      expect(nextState, isA<BlockDataStatePending>());
      final pending = nextState as BlockDataStatePending;
      expect(pending.reason, isA<BlockPendingReasonInitial>());
    });

    test(
        'Pending: preserves failure when criteria shifts (filterCriteriaChanged)',
        () {
      final pendingFailedState = BlockDataStatePending.failed(
        errorOrigin: BlockErrorOrigin.directFetch,
        errorInfo: mockBlockErrorInfo,
      );

      final nextState = BlockDataStateUtils.calculateNewLazyDataState(
        currentBlockDataState: pendingFailedState,
        hasParentItem: true,
        isRootBlock: true,
        parentItemChanged: false,
        filterCriteriaChanged: true,
      );

      expect(nextState, isA<BlockDataStatePending>());
      final pending = nextState as BlockDataStatePending;
      expect(pending.reason, isA<BlockPendingReasonFilterChanged>());
      expect(pending.errorInfo, equals(mockBlockErrorInfo));
      expect(pending.underlyingFailureReason, isNotNull);
      expect(pending.hasFailure, isTrue);
    });

    test(
        'LoadedFresh: transitions to Stale.filterChanged when criteria changes',
        () {
      const fresh = BlockDataStateLoadedFresh();

      final nextState = BlockDataStateUtils.calculateNewLazyDataState(
        currentBlockDataState: fresh,
        hasParentItem: true,
        isRootBlock: true,
        parentItemChanged: false,
        filterCriteriaChanged: true,
      );

      expect(nextState, isA<BlockDataStateLoadedStale>());
      final stale = nextState as BlockDataStateLoadedStale;
      expect(stale.reason, isA<BlockLoadedStateStaleReasonFilterChanged>());
      expect(stale.errorInfo, isNull);
    });

    test('LoadedFresh: transitions to Stale.event upon incoming domain event',
        () {
      const fresh = BlockDataStateLoadedFresh();

      final nextState = BlockDataStateUtils.calculateNewLazyDataState(
        currentBlockDataState: fresh,
        hasParentItem: true,
        isRootBlock: true,
        parentItemChanged: false,
        filterCriteriaChanged: false,
        hasIncomingEvent: true,
      );

      expect(nextState, isA<BlockDataStateLoadedStale>());
      final stale = nextState as BlockDataStateLoadedStale;
      expect(stale.reason, isA<BlockLoadedStateStaleReasonEvent>());
    });

    test(
        'LoadedStale(Failed): preserves error across filter mutations and incoming events',
        () {
      final staleFailedState = BlockDataStateLoadedStale.failed(
        errorOrigin: BlockErrorOrigin.directFetch,
        errorInfo: mockBlockErrorInfo,
      );

      // 1. Shift filter criteria
      final stateAfterFilter = BlockDataStateUtils.calculateNewLazyDataState(
        currentBlockDataState: staleFailedState,
        hasParentItem: true,
        isRootBlock: true,
        parentItemChanged: false,
        filterCriteriaChanged: true,
      );

      expect(stateAfterFilter, isA<BlockDataStateLoadedStale>());
      final staleFilter = stateAfterFilter as BlockDataStateLoadedStale;
      expect(
          staleFilter.reason, isA<BlockLoadedStateStaleReasonFilterChanged>());
      expect(staleFilter.errorInfo, equals(mockBlockErrorInfo));
      expect(staleFilter.hasFailure, isTrue);

      // 2. Subsequent incoming event
      final stateAfterEvent = BlockDataStateUtils.calculateNewLazyDataState(
        currentBlockDataState: stateAfterFilter,
        hasParentItem: true,
        isRootBlock: true,
        parentItemChanged: false,
        filterCriteriaChanged: false,
        hasIncomingEvent: true,
      );

      expect(stateAfterEvent, isA<BlockDataStateLoadedStale>());
      final staleEvent = stateAfterEvent as BlockDataStateLoadedStale;
      expect(staleEvent.reason, isA<BlockLoadedStateStaleReasonEvent>());
      expect(staleEvent.errorInfo, equals(mockBlockErrorInfo));
      expect(staleEvent.underlyingFailureReason?.errorOrigin,
          equals(BlockErrorOrigin.directFetch));
    });
  });
}
