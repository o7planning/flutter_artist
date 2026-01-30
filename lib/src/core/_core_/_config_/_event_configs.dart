part of '../core.dart';

// final bool selfReQueryable;
// final bool currentItemSelfRefreshable;
// final List<Event> outsideBroadcastEvents; (**)
// final List<Event> executeBlockLevelReactionToEvents; (**)
// final List<Evt> executeItemLevelReactionToEvts; (**)
// final List<Evt> executeBlockLevelReactionToEvts;

// blockConfig: {
//     fireExternalShelfEvents: [], // outsideBroadcastEvents
//     onExternalShelfEvents: ExternalShelfEventB (
//         blockLevelReactionTo: [], // executeBlockLevelReactionToEvents; (**)
//     );
//     onInternalShelfEvents: InternalShelfEventB (
//         selfReQueryable: false,
//         itemLevelSelfReactionEnabled: false,
//         blockLevelReactionTo: [], // executeBlockLevelReactionToEvts
//         itemLevelReactionTo: [], // executeItemLevelReactionToEvts
//     ),
// }

// scalarConfig: {
//     onExternalShelfEvents: ExternalShelfEventS (
//         scalarLevelReactionTo: [],
//     );
//     onInternalShelfEvents: InternalShelfEventS (
//         scalarLevelReactionTo: [],
//     ),
// }

class ExternalShelfEventS {
  final List<Event> scalarLevelReactionTo;

  const ExternalShelfEventS({
    required this.scalarLevelReactionTo,
  });
}

class InternalShelfEventS {
  final bool scalarLevelSelfReactionEnabled;
  final List<Evt> scalarLevelReactionTo;

  const InternalShelfEventS({
    this.scalarLevelSelfReactionEnabled = false,
    required this.scalarLevelReactionTo,
  });
}

class ExternalShelfEventB {
  final List<Event> blockLevelReactionTo;

  const ExternalShelfEventB({
    required this.blockLevelReactionTo,
  });
}

class InternalShelfEventB {
  final bool blockLevelSelfReactionEnabled;
  final bool currentItemSelfReactionEnabled;
  final List<Evt> blockLevelReactionTo;
  final List<Evt> itemLevelReactionTo;

  const InternalShelfEventB({
    this.blockLevelSelfReactionEnabled = false,
    this.currentItemSelfReactionEnabled = false,
    this.blockLevelReactionTo = const [],
    this.itemLevelReactionTo = const [],
  });
}
