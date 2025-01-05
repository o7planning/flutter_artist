part of '../flutter_artist.dart';

class CustomControlBarItem extends StatelessWidget {
  final EdgeInsets padding;
  final Block block;
  final String? description;
  final Widget child;
  final Function() onPressed;

  const CustomControlBarItem({
    super.key,
    required this.padding,
    required this.block,
    this.description,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: child,
    );
  }
}
