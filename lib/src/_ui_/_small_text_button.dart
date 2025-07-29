part of '../_fa_core.dart';

class _SmallTextButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;

  const _SmallTextButton({
    required this.child,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.all(0),
      ),
      child: child,
    );
  }
}
