part of '../_fa_core.dart';

class _SimpleAccordionSection extends StatelessWidget {
  final bool initiallyExpanded;
  final Widget headerTitle;
  final Widget? headerSubtitle;
  final Widget? content;

  const _SimpleAccordionSection({
    required this.initiallyExpanded,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        dense: true,
        visualDensity: const VisualDensity(
          vertical: -3,
          horizontal: -3,
        ),
        initiallyExpanded: initiallyExpanded,
        backgroundColor: Colors.indigo.withAlpha(30),
        collapsedBackgroundColor: Colors.indigo.withAlpha(20),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 1,
        ),
        title: headerTitle,
        subtitle: headerSubtitle,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.topLeft,
        enabled: content != null,
        children: content == null ? [] : [content!],
      ),
    );
  }
}
