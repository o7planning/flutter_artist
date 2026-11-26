import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';

class XDataView extends StatelessWidget {
  final XData? xData;

  const XDataView({
    super.key,
    required this.xData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color bgColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
        : theme.colorScheme.surfaceContainerLow;

    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.1), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (xData == null)
            Text(
              'null',
              style: TextStyle(
                color: theme.colorScheme.error.withValues(alpha: 0.7),
                fontFamily: 'Courier',
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            )
          else ...[
            SelectableText(
              xData!.data.toString(),
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Courier',
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
