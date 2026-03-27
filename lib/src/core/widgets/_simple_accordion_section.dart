import 'package:flutter/material.dart';

class SimpleAccordionSection extends StatelessWidget {
  final bool initiallyExpanded;
  final Widget headerTitle;
  final Widget? headerSubtitle;
  final Widget? content;

  const SimpleAccordionSection({
    super.key,
    required this.initiallyExpanded,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color expandedBg = colorScheme.primary.withValues(alpha: 0.08);
    final Color collapsedBg = colorScheme.primary.withValues(alpha: 0.04);

    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        dense: true,
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -3,
        ),
        initiallyExpanded: initiallyExpanded,
        backgroundColor: expandedBg,
        collapsedBackgroundColor: collapsedBg,
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 0,
        ),
        minTileHeight: 32,
        title: DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: 13,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          child: headerTitle,
        ),
        subtitle: headerSubtitle,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.topLeft,
        enabled: content != null,
        children: content == null
            ? []
            : [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: content!,
                )
              ],
      ),
    );
  }
}
