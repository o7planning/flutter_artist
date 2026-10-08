import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../class_def/_class_def_views.dart';

/// A generalized inspection dialog that accepts any [ClassDefViewable] target object,
/// wraps it automatically inside a [ClassDefView], and presents it cleanly.
class ClassDefinitionInspectorDialog extends StatelessWidget {
  final String title;
  final ClassDefViewable targetObject;

  const ClassDefinitionInspectorDialog({
    required this.title,
    required this.targetObject,
    super.key,
  });

  /// Opens the inspector dialog to inspect class architectures and generics for a given target.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required ClassDefViewable targetObject,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => ClassDefinitionInspectorDialog(
        title: title,
        targetObject: targetObject,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Derive a clean default header title if the passed title is empty.
    final String resolvedTitle =
        title.isEmpty ? "Class Definition View" : title;

    return FaDialog(
      titleText: resolvedTitle,
      iconData: Icons.class_rounded,
      preferredContentWidth: 560,
      preferredContentHeight: null,
      contentPadding: const EdgeInsets.all(8),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClassDefView(
              title: resolvedTitle,
              targetObject: targetObject,
            ),
          ],
        ),
      ),
    );
  }
}
