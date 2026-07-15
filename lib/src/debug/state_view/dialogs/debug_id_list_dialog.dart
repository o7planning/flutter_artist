import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

/// A lightweight inspector dialog used to display a list of [ID] items dynamically.
class DebugIdListDialog<ID extends Comparable> extends StatelessWidget {
  final String title;
  final Iterable<ID> ids;

  const DebugIdListDialog({
    required this.title,
    required this.ids,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<ID> idList = ids.toList();

    return FaDialog(
      titleText: "$title (${idList.length})",
      preferredContentWidth: 420,
      preferredContentHeight: 340,
      contentPadding: const EdgeInsets.all(12),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: idList.isEmpty
                ? const Center(
                    child: Text(
                      "No IDs present.",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  )
                : ListView.separated(
                    itemCount: idList.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final idValue = idList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 4),
                        child: Row(
                          children: [
                            Text(
                              "#${index + 1}",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectableText(
                                idValue.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  static Future<void> show<ID extends Comparable>({
    required BuildContext context,
    required String title,
    required Iterable<ID> ids,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugIdListDialog<ID>(
          title: title,
          ids: ids,
        );
      },
    );
  }
}
