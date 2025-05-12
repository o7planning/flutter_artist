part of '../../flutter_artist.dart';

class CustomControlBarItem extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  final Function()? navigate;

  const CustomControlBarItem({
    super.key,
    required this.child,
    required this.onPressed,
    this.navigate,
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
    if (navigate != null) {
      navigate!();
    }
  }
}
