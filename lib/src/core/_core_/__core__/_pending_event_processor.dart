part of '../core.dart';

class _PendingEventProcessor {
  final _Storage storage;

  _PendingEventProcessor(this.storage);

  void addTaskUnitForPendingEvents() {
    ExecutionTrace executionTrace =
        FlutterArtist.codeFlowLogger._initTaskUnitForDeferredEvent(
      ownerClassInstance: this,
    );
    executionTrace._addTraceStep(
      codeId: "#27000",
      shortDesc: "addTaskUnitForPendingEvents",
      traceStepType: TraceStepType.debug,
    );
    //
    // #0004.
    //
    final bool freezing = storage.__deferment.isFreezing;
    executionTrace._addTraceStep(
      codeId: "#27040",
      shortDesc: freezing
          ? "The mode to defer <b>DeferredEvent</b> execution is <b>enabled</b>."
          : "The mode to defer <b>DeferredEvent</b> execution is <b>not enabled</b>.",
      traceStepType: TraceStepType.debug,
      tipDocument: TipDocument.deferringEvent,
    );
    //
    for (String listenerShelfName in storage._shelfMap.keys) {
      Shelf listenerShelf = storage._shelfMap[listenerShelfName]!;
      if (listenerShelf.markedAsOrphan) {
        continue;
      }
      bool hasPendingOrStaleMember =
          listenerShelf.hasPendingOrStaleMember(requiresVisible: true);
      if (!hasPendingOrStaleMember) {
        continue;
      }
      listenerShelf._addShelfExternalReactionTaskUnit(
        executionTrace: executionTrace,
      );
    }
  }
}
