part of '../core.dart';

class _QuickSuggestionButtonsBar extends StatelessWidget {
  final List<_QuickSuggestionButton> children;

  const _QuickSuggestionButtonsBar({required this.children});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: children,
    );
  }
}
