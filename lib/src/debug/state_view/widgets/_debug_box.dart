import 'package:flutter/material.dart';

abstract class BaseDebugBox extends StatelessWidget {
  const BaseDebugBox({super.key});

  List<Widget> getChildIconLabelTexts(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> children = getChildIconLabelTexts(context);

    return Container(
      padding: const EdgeInsets.all(5),
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.isEmpty
            ? children
            : children.expand((w) => [w, const SizedBox(height: 5)]).toList()
          ..removeLast(),
      ),
    );
  }
}
