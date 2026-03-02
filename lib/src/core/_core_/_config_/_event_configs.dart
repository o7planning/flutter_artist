part of '../core.dart';

// final bool selfReQueryable;
// final bool currentItemSelfRefreshable;
// final List<Event> outsideBroadcastEvents; (**)
// final List<Event> executeBlockLevelReactionToEvents; (**)
// final List<Evt> executeItemLevelReactionToEvts; (**)
// final List<Evt> executeBlockLevelReactionToEvts;

// blockConfig: {
//     emitExternalShelfEvents: [], // outsideBroadcastEvents
//     onExternalShelfEvents: ExternalShelfEventBlockRecipient (
//         blockLevelReactionOn: [], // executeBlockLevelReactionToEvents; (**)
//     );
//     onInternalShelfEvents: InternalShelfEventBlockRecipient (
//         selfReQueryable: false,
//         itemLevelSelfReactionEnabled: false,
//         blockLevelReactionOn: [], // executeBlockLevelReactionToEvts
//         itemLevelReactionOn: [], // executeItemLevelReactionToEvts
//     ),
// }

// scalarConfig: {
//     onExternalShelfEvents: ExternalShelfEventScalarRecipient (
//         scalarLevelReactionOn: [],
//     );
//     onInternalShelfEvents: InternalShelfEventScalarRecipient (
//         scalarLevelReactionOn: [],
//     ),
// }

class ExternalShelfEventScalarRecipient {
  final List<Event> scalarLevelReactionOn;

  const ExternalShelfEventScalarRecipient({
    required this.scalarLevelReactionOn,
  });
}

class InternalShelfEventScalarRecipient {
  final bool scalarLevelSelfReactionEnabled;
  final List<Evt> scalarLevelReactionOn;

  const InternalShelfEventScalarRecipient({
    this.scalarLevelSelfReactionEnabled = false,
    required this.scalarLevelReactionOn,
  });
}

class ExternalShelfEventBlockRecipient {
  final List<Event> blockLevelReactionOn;

  const ExternalShelfEventBlockRecipient({
    required this.blockLevelReactionOn,
  });
}

class InternalShelfEventBlockRecipient {
  final bool blockLevelSelfReactionEnabled;
  final bool currentItemSelfReactionEnabled;

  /// Will reQuery the Block.
  final List<Evt> blockLevelReactionOn;

  /// Will refresh the current Item.
  final List<Evt> itemLevelReactionOn;

  const InternalShelfEventBlockRecipient({
    this.blockLevelSelfReactionEnabled = false,
    this.currentItemSelfReactionEnabled = false,
    this.blockLevelReactionOn = const [],
    this.itemLevelReactionOn = const [],
  });
}
