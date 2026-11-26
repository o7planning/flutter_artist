part of '__widgets.dart';

class SimpleCopyButton extends StatelessWidget {
  final String? tooltip;
  final double iconSize;
  final String Function() getText;

  const SimpleCopyButton({
    super.key,
    required this.getText,
    this.iconSize = 18,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleSmallIconButton(
      iconData: Icons.copy_rounded,
      iconSize: iconSize,
      iconColor: theme.colorScheme.onSurfaceVariant,
      onPressed: () async {
        String text = getText();
        CopyUtils.copyToClipboard(context, text);
      },
    );
  }
}
