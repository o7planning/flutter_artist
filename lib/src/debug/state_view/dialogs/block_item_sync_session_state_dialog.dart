import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../../core/_core_/core.dart';

class DebugBlockItemSyncSessionStateDialog<ID extends Comparable>
    extends StatelessWidget {
  final String title;
  final Block<ID, Identifiable<ID>, Identifiable<ID>, FilterInput,
      FilterCriteria, FormInput, AdditionalFormRelatedData> block;
  final DebugBlockItemSyncSessionState<ID>? itemSyncSessionState;

  const DebugBlockItemSyncSessionStateDialog({
    required this.title,
    required this.block,
    required this.itemSyncSessionState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final receivedEvents = itemSyncSessionState?.receivedEventInfos ?? const [];
    final ID? activeItemId = block.currentItemId;
    final bool isStale = itemSyncSessionState?.isStale ?? false;
    final bool willRefresh = isStale && activeItemId != null;

    final FaDialog alert = FaDialog(
      titleText: title,
      contentPadding: const EdgeInsets.all(12),
      preferredContentWidth: 700,
      preferredContentHeight: 480,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Current Active Item Summary Section
          _buildItemSummarySection(
            context,
            activeItemId: activeItemId,
            sessionTargetId: itemSyncSessionState?.targetItemId,
            isStale: isStale,
          ),
          const SizedBox(height: 10),

          // 2. Projected Action Plan Card for Current Item
          _buildItemPredictedPlanCard(
            context,
            willRefresh: willRefresh,
            activeItemId: activeItemId,
          ),
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
                    "Accumulated Item Refresh Events",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(width: 6),
                  if (itemSyncSessionState == null)
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

          // 4. Events List Section
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

  /// Summary header cards describing current item target and session binding.
  Widget _buildItemSummarySection(
    BuildContext context, {
    required ID? activeItemId,
    required ID? sessionTargetId,
    required bool isStale,
  }) {
    final bool isBound =
        sessionTargetId != null && sessionTargetId == activeItemId;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            label: "Active Current Item ID",
            value: activeItemId?.toString() ?? "NULL (None)",
            color: Colors.blue.shade50,
            textColor: Colors.blue.shade900,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSummaryCard(
            label: "Session Bound Target ID",
            value: sessionTargetId?.toString() ?? "NULL",
            color: isBound ? Colors.indigo.shade50 : Colors.grey.shade100,
            textColor: isBound ? Colors.indigo.shade900 : Colors.grey.shade800,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSummaryCard(
            label: "Item Freshness State",
            value: isStale ? "STALE (Needs Refresh)" : "FRESH (Synchronized)",
            color: isStale ? Colors.orange.shade50 : Colors.green.shade50,
            textColor: isStale ? Colors.orange.shade900 : Colors.green.shade900,
          ),
        ),
      ],
    );
  }

  /// Predicted Plan Card predicting if performLoadItemDetailById will execute.
  Widget _buildItemPredictedPlanCard(
    BuildContext context, {
    required bool willRefresh,
    required ID? activeItemId,
  }) {
    final Color actionColor =
        willRefresh ? Colors.amber.shade900 : Colors.grey.shade700;
    final String actionLabel = willRefresh
        ? "RELOAD ITEM DETAIL (performLoadItemDetailById)"
        : "IDLE (Preserve In-Memory Item)";

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.amber.shade50.withAlpha(80),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.refresh_rounded,
                  size: 16, color: Colors.amber.shade800),
              const SizedBox(width: 6),
              Text(
                "Predicted Item Execution Plan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.amber.shade900,
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
                  "Target Item ID to Refresh",
                  activeItemId?.toString() ?? "N/A",
                ),
              ),
              Expanded(
                child: _buildPlanDetailItem(
                  "Execution Unit Trigger",
                  willRefresh ? "BlockSetCurrentItemIntent(force)" : "None",
                ),
              ),
              Expanded(
                child: _buildPlanDetailItem(
                  "Reaction Scope",
                  "BlockReactionTarget.currentItem",
                ),
              ),
            ],
          ),
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

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required Color color,
    required Color textColor,
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
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: textColor.withAlpha(180),
              fontWeight: FontWeight.bold,
            ),
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

  Widget _buildEmptyEventsBanner() {
    final bool isPristine = itemSyncSessionState == null;
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
                  ? "Clean Item State (No Active Session)"
                  : "No refresh events accumulated for current item.",
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
                  ? "Current active item is fully synchronized with background notifications."
                  : "Session exists but no mutation broadcasts targeted this specific item.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventInfoCard(
    BuildContext context,
    int index,
    BlockReceivedEventInfo<ID> eventInfo,
  ) {
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
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Source: ${eventInfo.eventSourceType.name}",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.amber.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 11, color: Colors.black),
              children: [
                const TextSpan(
                  text: "Trigger Data Types: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: eventInfo.dataTypes.map((t) => t.toString()).join(", "),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 11, color: Colors.black),
              children: [
                const TextSpan(
                  text: "Broadcast Item IDs: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: eventInfo.effectedItemIds.isEmpty
                      ? "[] (Global/Wildcard)"
                      : eventInfo.effectedItemIds.join(", "),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
