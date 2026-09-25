part of '../core.dart';

class _ReactionProcessor {
  _ReactionProcessor();

  void addReactionExecutionUnits({required Set<String> excludeShelfNames}) {
    ExecutionTrace executionTrace =
    FlutterArtist.codeFlowLogger._createPendingEventProcessorExecutionTrace(
      ownerClassInstance: this,
    );
    executionTrace.addInfo(
      codeId: "#27000",
      shortDesc: "addReactionExecutionUnits",
    );
    //
    // #0004.
    //
    final bool deferred = FlutterArtist.backstage.isReactionDeferred;
    executionTrace.addInfo(
      codeId: "#27040",
      shortDesc: deferred
          ? "The mode to defer <b>Reactions</b> execution is <b>enabled</b>."
          : "The mode to defer <b>Reactions</b> execution is <b>not enabled</b>.",
      tipDocument: TipDocument.deferringReactions,
    );
    //
    for (String listenerShelfName in FlutterArtist.storage._shelfMap.keys) {
      if (excludeShelfNames.contains(listenerShelfName)) {
        continue;
      }
      Shelf listenerShelf = FlutterArtist.storage._shelfMap[listenerShelfName]!;

      executionTrace.addSeparator();

      if (listenerShelf.deferReactions) {
        executionTrace.addSeparator();
        continue;
      }
      bool hasPendingOrStaleMember =
      listenerShelf.hasPendingOrStaleMember(requiresVisible: true);
      if (!hasPendingOrStaleMember) {
        executionTrace.addSeparator();
        continue;
      }
      executionTrace.addSeparator();
      listenerShelf._addShelfExternalReactionExecutionUnit(
        executionTrace: executionTrace,
      );
    }
  }
}
