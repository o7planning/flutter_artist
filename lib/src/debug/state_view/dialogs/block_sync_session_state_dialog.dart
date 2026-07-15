import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/block_native_query_mode.dart';
import '../../../core/enums/resolved_query_action.dart';
import 'debug_id_list_dialog.dart';

class DebugBlockSyncSessionStateDialog<ID extends Comparable>
    extends StatelessWidget {
  final String title;
  final Block<
      ID, //
      Identifiable<ID>,
      Identifiable<ID>,
      FilterInput,
      FilterCriteria,
      FormInput,
      AdditionalFormRelatedData> block;
  final DebugBlockSyncSessionState<ID>? syncSessionState;

  const DebugBlockSyncSessionStateDialog({
    required this.title,
    required this.block,
    required this.syncSessionState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Extract accumulated unique IDs across all events (if session exists)
    final Set<ID> allEffectedIds = {};
    final receivedEvents = syncSessionState?.receivedEventInfos ?? const [];

    for (var info in receivedEvents) {
      allEffectedIds.addAll(info.effectedItemIds);
    }

    // Resolve projected query execution plan based on current block state and session info
    final queryPlan = BlockQueryStrategyResolver.resolveQueryPlan<ID>(
      block: block,
      syncSessionState: syncSessionState,
      errorOrigin: block.errorOrigin,
    );

    // Extract parent item ID and filter criteria from Session Snapshot or directly from Live Block
    final Comparable? parentItemId = syncSessionState != null
        ? syncSessionState!.parentBlockItemId
        : block.parentBlockCurrentItemId;

    final FilterCriteria? activeFilterCriteria = syncSessionState != null
        ? syncSessionState!.filterCriteria
        : block.filterCriteria;

    final FaDialog alert = FaDialog(
      titleText: title,
      contentPadding: const EdgeInsets.all(12),
      preferredContentWidth: 740,
      preferredContentHeight: 520,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Session / Live Baseline Summary Section
          _buildSummarySection(
            context,
            parentItemId: parentItemId,
            filterCriteria: activeFilterCriteria,
            allEffectedIds: allEffectedIds,
          ),
          const SizedBox(height: 10),

          // 2. Projected Query Execution Plan Card (Predicted Outcome)
          _buildPredictedPlanCard(context, block, queryPlan),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // 3. Section Header for Events
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "Accumulated Received Events",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(width: 6),
                  if (syncSessionState == null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Text(
                        "PRISTINE",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                ],
              ),
              Chip(
                labelStyle: const TextStyle(fontSize: 11),
                padding: EdgeInsets.zero,
                label: Text("${receivedEvents.length} events"),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 4. Accumulated Event List Section
          Expanded(
            child: receivedEvents.isEmpty
                ? _buildEmptyEventsBanner()
                : ListView.separated(
                    itemCount: receivedEvents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final eventInfo = receivedEvents[index];
                      return _buildEventInfoCard(context, index, eventInfo);
                    },
                  ),
          ),
        ],
      ),
    );
    return alert;
  }

  /// Builds the banner displayed when no sync session exists or no events are accumulated.
  Widget _buildEmptyEventsBanner() {
    final bool isPristine = syncSessionState == null;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPristine
                  ? Icons.check_circle_outline_rounded
                  : Icons.inbox_outlined,
              size: 32,
              color: isPristine ? Colors.green.shade600 : Colors.grey.shade500,
            ),
            const SizedBox(height: 8),
            Text(
              isPristine
                  ? "Clean Baseline State (No Active Sync Session)"
                  : "No events accumulated in this session state.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color:
                    isPristine ? Colors.green.shade900 : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isPristine
                  ? "This block is fully up-to-date with no pending external background events."
                  : "Session is active but no external broadcasts have targeted this block yet.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the baseline context header cards.
  Widget _buildSummarySection(
    BuildContext context, {
    required Comparable? parentItemId,
    required FilterCriteria? filterCriteria,
    required Set<ID> allEffectedIds,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            label: "Parent Item ID",
            value: parentItemId?.toString() ?? "NULL (Root)",
            color: Colors.blue.shade50,
            textColor: Colors.blue.shade900,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSummaryCard(
            label: "Filter Criteria",
            value: filterCriteria == null ? "NULL" : "ACTIVE",
            color: filterCriteria == null
                ? Colors.grey.shade100
                : Colors.green.shade50,
            textColor: filterCriteria == null
                ? Colors.grey.shade800
                : Colors.green.shade900,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: allEffectedIds.isEmpty
                ? null
                : () => DebugIdListDialog.show<ID>(
                      context: context,
                      title: "Unique Effected IDs",
                      ids: allEffectedIds,
                    ),
            child: _buildSummaryCard(
              label: "Unique Effected IDs",
              value: "${allEffectedIds.length} IDs",
              color: Colors.orange.shade50,
              textColor: Colors.orange.shade900,
              trailingWidget: allEffectedIds.isNotEmpty
                  ? Icon(Icons.open_in_new,
                      size: 14, color: Colors.orange.shade900)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required Color color,
    required Color textColor,
    Widget? trailingWidget,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: textColor.withAlpha(180),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (trailingWidget != null) trailingWidget,
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the projected query execution plan card predicting the exact action the Block will take.
  Widget _buildPredictedPlanCard(
    BuildContext context,
    Block block,
    BlockQueryPlan<ID> queryPlan,
  ) {
    Color actionColor;
    String actionLabel;

    switch (queryPlan.action) {
      case null:
        actionColor = Colors.grey.shade700;
        actionLabel = "NONE (No Query Required)";
      case ResolvedQueryAction.performQuery:
        actionColor = Colors.teal.shade800;
        actionLabel =
            block.config.nativeQueryMode == BlockNativeQueryMode.fullQuery
                ? "PERFORM QUERY (Full Query)"
                : "PERFORM QUERY (Pageable Query)";
      case ResolvedQueryAction.performQueryByItemIds:
        actionColor = Colors.purple.shade800;
        actionLabel =
            "PERFORM QUERY BY ITEM IDS (${queryPlan.targetItemIds.length} IDs)";
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.purple.shade50.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_outlined,
                  size: 16, color: Colors.purple),
              const SizedBox(width: 6),
              const Text(
                "Predicted Execution Plan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.purple,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: actionColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: actionColor.withAlpha(80)),
                ),
                child: Text(
                  actionLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: actionColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildPlanDetailItem(
                  "Block Data State",
                  "${block.dataState.name.toUpperCase()} ${block.hasPendingInvalidation ? '(Stale Invalidated)' : ''}",
                ),
              ),
              Expanded(
                child: _buildPlanDetailItem(
                  "Query Strategy",
                  queryPlan.viewportSyncStrategy?.name ?? "N/A",
                ),
              ),
              Expanded(
                child: _buildPlanDetailItem(
                  "Native Query Mode",
                  block.config.nativeQueryMode.name,
                ),
              ),
            ],
          ),
          if (queryPlan.action ==
              ResolvedQueryAction.performQueryByItemIds) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 11, color: Colors.black),
                    children: [
                      const TextSpan(
                        text: "Target Item IDs to Query: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "${queryPlan.targetItemIds.length} IDs ",
                        style: TextStyle(
                          color: Colors.purple.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => DebugIdListDialog.show<ID>(
                    context: context,
                    title: "Target Item IDs to Query",
                    ids: queryPlan.targetItemIds,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility_outlined,
                            size: 13, color: Colors.purple.shade800),
                        const SizedBox(width: 3),
                        Text(
                          "View List",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade800,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlanDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  /// Builds an item card displaying details of a single [BlockReceivedEventInfo].
  Widget _buildEventInfoCard(
      BuildContext context, int index, BlockReceivedEventInfo<ID> eventInfo) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "#${index + 1}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Source: ${eventInfo.eventSourceType.name}",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.indigo.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              if (eventInfo.requiresMaxSyncStrategy)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.faColors.surface.dangerTonal,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: context.faColors.stroke.subtle),
                  ),
                  child: Text(
                    "MAX SYNC REQ",
                    style: TextStyle(
                      fontSize: 10,
                      color: context.faColors.ink.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 11, color: Colors.black),
                    children: [
                      const TextSpan(
                        text: "Data Types: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: eventInfo.dataTypes
                            .map((t) => t.toString())
                            .join(", "),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 11, color: Colors.black),
                  children: [
                    const TextSpan(
                      text: "Effected Item IDs: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: eventInfo.effectedItemIds.isEmpty
                          ? "[] (Global/Projected)"
                          : "${eventInfo.effectedItemIds.length} IDs ",
                      style: TextStyle(
                        color: eventInfo.effectedItemIds.isEmpty
                            ? Colors.grey.shade700
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              if (eventInfo.effectedItemIds.isNotEmpty)
                InkWell(
                  onTap: () => DebugIdListDialog.show<ID>(
                    context: context,
                    title: "Effected Item IDs (#${index + 1})",
                    ids: eventInfo.effectedItemIds,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    child:
                        Icon(Icons.open_in_new, size: 12, color: Colors.indigo),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
