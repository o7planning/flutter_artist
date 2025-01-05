part of '../flutter_artist.dart';

class CustomControlBarItem extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  final Function()? route;

  const CustomControlBarItem({
    super.key,
    required this.child,
    required this.onPressed,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onPressed,
      child: child,
    );
  }

  void _onPressed() {
    onPressed();
    if (route != null) {
      route!();
    }
  }
}
