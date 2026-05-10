import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../utils/_copy_utils.dart';

class FloatingCopyButton extends StatelessWidget {
  final String? tooltip;
  final String Function() getText;

  const FloatingCopyButton({
    super.key,
    required this.getText,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Material(
      color: Colors.transparent,
      child: IconButton(
        onPressed: () {
          String text = getText();
          CopyUtils.copyToClipboard(context, text);
        },
        tooltip: tooltip ?? 'Copy',
        iconSize: 18,
        splashRadius: 20,
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(8),
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.surface.withValues(alpha: 0.6),
          hoverColor: colorScheme.primaryContainer.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
        ),
        icon: Icon(
          Icons.copy_all_rounded,
          color: context.faColors.action.ink.primary,
        ),
      ),
    );
  }
}
