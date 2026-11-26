part of '__widgets.dart';


class SimpleOpenUrlButton extends StatelessWidget {
  final String? tooltip;
  final double iconSize;
  final String url;

  const SimpleOpenUrlButton({
    super.key,
    required this.url,
    this.iconSize = 18,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleSmallIconButton(
      iconData: Icons.open_in_new_rounded,
      iconSize: iconSize,
      iconColor: context.faColors.ink.label,
      onPressed: () async {
        await launchUrl(Uri.parse(url));
      },
    );
  }
}
