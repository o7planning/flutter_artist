part of '../_fa_core.dart';

class _DevContainer extends StatelessWidget {
  final Widget child;

  const _DevContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(2),
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.deepOrangeAccent,
        ),
      ),
      child: child,
    );
  }
}
