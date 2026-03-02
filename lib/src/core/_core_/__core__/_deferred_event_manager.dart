part of '../core.dart';

class SourceAndSummaryEvents {
  final String? srcShelfName;
  final Set<Event> _events = {};

  SourceAndSummaryEvents({required this.srcShelfName});

  void addEvents(List<Event> events) {
    _events.addAll(events);
  }
}

class _DeferredEventManager {
  final _Storage storage;
  final List<DeferredEvent> _list = [];

  _DeferredEventManager(this.storage);

  void addDeferredEvent(DeferredEvent deferredEvent) {
    _list.add(deferredEvent);
  }

  Set<Event> _findEventsForListenerShelf({
    required List<DeferredEvent> deferredEvents,
    required String listenerShelfName,
  }) {
    Set<Event> events = {};
    for (DeferredEvent deferredEvent in deferredEvents) {
      final String? eventShelfName = deferredEvent.eventShelfName;
      if (eventShelfName == listenerShelfName) {
        continue;
      }
      //
      if (eventShelfName == null) {
        events.addAll(deferredEvent.events);
        continue;
      }
      events.addAll(deferredEvent.events);
    }
    return events;
  }

  void addTaskUnitForDeferredEvents() {
    final List<DeferredEvent> deferredEvents = [..._list];
    _list.clear();
    //
    if (deferredEvents.isEmpty) {
      return;
    }
    ExecutionTrace executionTrace =
        FlutterArtist.codeFlowLogger._initTaskUnitForDeferredEvent(
      ownerClassInstance: this,
    );
    executionTrace._addTraceStep(
      codeId: "#27000",
      shortDesc:
          "Several originEvents have occurred, and they have generated <b>DeferredEvent(s)</b>. "
          "It's time to execute them.",
      lineFlowType: LineFlowType.debug,
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
      lineFlowType: LineFlowType.debug,
      tipDocument: TipDocument.eventReactionFreezing,
    );
    //
    final List<Shelf> visibleReactionShelves = [];
    final List<Shelf> invisibleReactionShelves = [];
    //
    bool hasSeparator = false;
    for (String listenerShelfName in storage._shelfMap.keys) {
      Set<Event> originEvents = _findEventsForListenerShelf(
        deferredEvents: deferredEvents,
        listenerShelfName: listenerShelfName,
      );
      if (originEvents.isEmpty) {
        continue;
      }

      hasSeparator = true;
      // SEPARATOR.
      executionTrace._addLineFlowSeparator();
      //
      executionTrace._addTraceStep(
        codeId: "#27140",
        shortDesc:
            "The <b>$listenerShelfName</b> received the <b>originEvents</b>:"
            "\n - @originEvents: <b>${originEvents.toList()}</b>.",
        lineFlowType: LineFlowType.debug,
      );
      Set<Event> projectionEvents = FlutterArtist.storage._projectionManager
          .getProjectionEvents(originEvents);
      executionTrace._addTraceStep(
        codeId: "#27160",
        shortDesc:
            "Calculated <b>projectionEvents</b> from <b>originEvents</b>:"
            "\n - @projectionEvents: <b>${projectionEvents.toList()}</b>.",
        lineFlowType: LineFlowType.debug,
        tipDocument: TipDocument.projection,
      );
      Shelf listenerShelf = storage._shelfMap[listenerShelfName]!;
      //
      __markReactionConditionsForEvents(
        executionTrace: executionTrace,
        listenerShelf: listenerShelf,
        outsideEvents: projectionEvents.toList(),
      );
      if (listenerShelf._hasReactionBookmark()) {
        if (listenerShelf.ui.hasActiveUiComponent()) {
          visibleReactionShelves.add(listenerShelf);
        } else {
          invisibleReactionShelves.add(listenerShelf);
        }
      }
    }
    if (hasSeparator) {
      // END SEPARATOR:
      executionTrace._addLineFlowSeparator();
    }
    //
    // SAME-AS: #0003
    //
    for (Shelf reactionShelf in invisibleReactionShelves) {
      executionTrace._addTraceStep(
        codeId: "#27300",
        shortDesc:
            "Calling ${debugObjHtml(reactionShelf)}._addShelfExternalReactionTaskUnit():",
        note: " This Shelf is <b>INVISIBLE</b>.",
        lineFlowType: LineFlowType.nonControllableCalling,
      );
      reactionShelf._addShelfExternalReactionTaskUnit(
        executionTrace: executionTrace,
      );
    }
    for (Shelf reactionShelf in visibleReactionShelves) {
      if (!freezing) {
        executionTrace._addTraceStep(
          codeId: "#27400",
          shortDesc:
              "Calling ${debugObjHtml(reactionShelf)}._addShelfExternalReactionTaskUnit():",
          note: " This Shelf is <b>VISIBLE</b> and <b>is not frozen</b>.",
          lineFlowType: LineFlowType.nonControllableCalling,
          tipDocument: TipDocument.eventReactionFreezing,
        );
        reactionShelf._addShelfExternalReactionTaskUnit(
          executionTrace: executionTrace,
        );
      } else {
        executionTrace._addTraceStep(
          codeId: "#27500",
          shortDesc: "This Shelf is <b>VISIBLE</b> and <b>is frozen</b>.",
          lineFlowType: LineFlowType.info,
        );
      }
    }
  }

  void __markReactionConditionsForEvents({
    required ExecutionTrace executionTrace,
    required Shelf listenerShelf,
    required List<Event> outsideEvents,
  }) {
    if (listenerShelf.isFullyPending) {
      executionTrace._addTraceStep(
        codeId: "#49000",
        shortDesc:
            "The <b>${listenerShelf.name}</b> is in frozen mode reacting to events, "
            "so there is no need to create a task unit for it.",
        lineFlowType: LineFlowType.info,
      );
      return;
    }
    executionTrace._addTraceStep(
      codeId: "#49100",
      shortDesc:
          "Calculating how the members of <b>${listenerShelf.name}</b> would react to the events above...",
      lineFlowType: LineFlowType.info,
    );
    EffectedShelfMembers effectedShelfMembers =
        listenerShelf._calculateEffectedShelfMembersByEvents(outsideEvents);
    executionTrace._addTraceStep(
      codeId: "#49200",
      shortDesc: "Calculated:${effectedShelfMembers.getDebugInfoHtml()}",
      lineFlowType: LineFlowType.info,
    );
    if (!effectedShelfMembers.hasMember()) {
      return;
    }
    //
    listenerShelf._markReactionToExternalShelfEvents(
      executionTrace: executionTrace,
      effectedShelfMembers: effectedShelfMembers,
    );
  }
}
