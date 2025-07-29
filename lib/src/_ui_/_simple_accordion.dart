part of '../_fa_core.dart';

class _SimpleAccordion extends StatefulWidget {
  final List<_SimpleAccordionSection> children;

  const _SimpleAccordion({
    required this.children,
  });

  @override
  State<StatefulWidget> createState() {
    return __SimpleAccordionState();
  }
}

class __SimpleAccordionState extends State<_SimpleAccordion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.children
          .expand(
            (w) => [
              w,
              SizedBox(height: 5),
            ],
          )
          .toList(),
    );
  }
}
