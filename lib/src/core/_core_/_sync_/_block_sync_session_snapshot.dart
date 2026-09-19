import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/block_native_query_mode.dart';
import '../../../core/enums/resolved_query_action.dart';
import '../../../debug/state_view/dialogs/debug_id_list_dialog.dart';

// =============================================================================
// DIAGNOSTIC SNAPSHOT
// =============================================================================

/// A diagnostic snapshot capturing the exact runtime state and boundary context
/// of a Block at a specific point in time.
///
/// This immutable snapshot is intended to be embedded into the ExecutionTrace log,
/// enabling precise time-travel debugging and strategy replay without being
/// affected by subsequent mutations to the live Block instance.
class BlockSyncDiagnosticSnapshot<ID extends Comparable> {
  /// The structural data state of the block (e.g., Pending, LoadedFresh, LoadedStale)
  /// at the exact moment the snapshot was taken.
  final BlockDataState blockDataState;

  /// The effective configuration of the block, containing viewport sync policies
  /// and query modes driving the strategy resolution.
  final BlockEffectiveConfig effectiveConfig;

  /// The list of active item IDs residing in the block's current dataset pool.
  final List<ID> itemIds;

  /// The active parent item ID that this block is scoped to (if it is a child block).
  final Comparable? parentBlockCurrentItemId;

  /// The active filter criteria applied to the block at this moment.
  final FilterCriteria? filterCriteria;

  /// The session state accumulating background events, invalidations, and staleness markers.
  final DebugBlockSyncSessionState<ID>? syncSessionState;

  const BlockSyncDiagnosticSnapshot({
    required this.blockDataState,
    required this.effectiveConfig,
    required this.itemIds,
    required this.parentBlockCurrentItemId,
    required this.filterCriteria,
    required this.syncSessionState,
  });
}
