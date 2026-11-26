part of '__widgets.dart';

class SimpleAccordion extends StatefulWidget {
  final List<SimpleAccordionSection> children;

  const SimpleAccordion({
    super.key,
    required this.children,
  });

  @override
  State<StatefulWidget> createState() {
    return _SimpleAccordionState();
  }
}

class _SimpleAccordionState extends State<SimpleAccordion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.children
          .expand(
            (w) =>
        [
          w,
          SizedBox(height: 5),
        ],
      )
          .toList(),
    );
  }
}
