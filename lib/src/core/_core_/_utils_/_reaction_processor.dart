part of '../core.dart';

class _ReactionProcessor {
  _ReactionProcessor();

  void addReactionExecutionUnits({required Set<String> excludeShelfNames}) {
    ExecutionTrace executionTrace =
        FlutterArtist.codeFlowLogger._createPendingEventProcessorExecutionTrace(
      ownerClassInstance: this,
    );
    executionTrace._addTraceStep(
      codeId: "#27000",
      shortDesc: "addReactionExecutionUnits",
      traceStepType: TraceStepType.debug,
    );
    //
    // #0004.
    //
    final bool deferred = FlutterArtist.backstage.isReactionDeferred;
    executionTrace._addTraceStep(
      codeId: "#27040",
      shortDesc: deferred
          ? "The mode to defer <b>Reactions</b> execution is <b>enabled</b>."
          : "The mode to defer <b>Reactions</b> execution is <b>not enabled</b>.",
      traceStepType: TraceStepType.debug,
      tipDocument: TipDocument.deferringReactions,
    );
    //
    for (String listenerShelfName in FlutterArtist.storage._shelfMap.keys) {
      if (excludeShelfNames.contains(listenerShelfName)) {
        continue;
      }
      Shelf listenerShelf = FlutterArtist.storage._shelfMap[listenerShelfName]!;
      executionTrace._addTraceStep(
        codeId: "#27100",
        shortDesc: "Separator",
        traceStepType: TraceStepType.separator,
      );
      if (listenerShelf.deferReactions) {
        executionTrace._addTraceStep(
          codeId: "#27200",
          shortDesc: "${debugObjHtml(listenerShelf)}: Reaction Deferred.",
          traceStepType: TraceStepType.separator,
        );
        continue;
      }
      bool hasPendingOrStaleMember =
          listenerShelf.hasPendingOrStaleMember(requiresVisible: true);
      if (!hasPendingOrStaleMember) {
        executionTrace._addTraceStep(
          codeId: "#27300",
          shortDesc:
              "${debugObjHtml(listenerShelf)}: Has no pending or stale members.",
          traceStepType: TraceStepType.separator,
        );
        continue;
      }
      executionTrace._addTraceStep(
        codeId: "#27400",
        shortDesc:
            "${debugObjHtml(listenerShelf)}: Add Shelf External Reaction Execution Unit.",
        traceStepType: TraceStepType.separator,
      );
      listenerShelf._addShelfExternalReactionExecutionUnit(
        executionTrace: executionTrace,
      );
    }
  }
}
