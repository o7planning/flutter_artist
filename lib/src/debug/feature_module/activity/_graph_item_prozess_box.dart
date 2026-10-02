import 'package:flutter/material.dart';

import '../../../core/_core_/core.dart';
import '../../../core/utils/_class_utils.dart';
import '../../constants/_debug_constants.dart';

class GraphItemProzessBox extends StatelessWidget {
  final Prozess prozess;

  const GraphItemProzessBox({
    super.key,
    required this.prozess,
  });

  @override
  Widget build(BuildContext context) {
    bool hasActiveWidget = prozess.ui.hasVisibleViews();

    return SizedBox(
      width: 260,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: hasActiveWidget
              ? DebugConstants.activeGraphBoxBgColor(context)
              : DebugConstants.inactiveGraphBoxBgColor(context),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            DebugConstants.graphBoxShadow(context),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_tree_outlined,
                  size: DebugConstants.graphBoxIconSize,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prozess.name,
                        style: TextStyle(
                          fontSize: DebugConstants.graphBoxFontSizeChildBox,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        getClassName(prozess),
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 10),
            if (prozess.stages.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "No stages available",
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
              )
            else
              ...prozess.stages.map(
                (stage) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.subdirectory_arrow_right,
                        size: 12,
                        color: Colors.teal,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          stage.name,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: DebugConstants.graphBoxTextColor(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
