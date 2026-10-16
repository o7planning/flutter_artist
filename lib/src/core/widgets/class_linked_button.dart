import 'package:flutter/material.dart';

import '../../debug/dialog/class_definition_inspector_dialog.dart';
import '../_core_/core.dart';
import '../utils/__utils.dart';

/// A reusable clickable text widget styled as a code link that opens a
/// [ClassDefinitionInspectorDialog] for any given target object.
class ClassLinkedButton extends StatelessWidget {
  final ClassDefViewable targetObject;
  final String? customDisplayClassName;
  final String dialogTitle;
  final double fontSize;

  const ClassLinkedButton({
    required this.targetObject,
    this.customDisplayClassName,
    this.dialogTitle = "Class Definition View",
    this.fontSize = 12,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String className =
        customDisplayClassName ?? getClassNameWithoutGenerics(targetObject);

    return InkWell(
      onTap: () {
        ClassDefinitionInspectorDialog.show(
          context: context,
          title: dialogTitle,
          targetObject: targetObject as ClassDefViewable,
        );
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                className,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: colorScheme.primary.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.open_in_new_rounded,
              size: fontSize + 1,
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
