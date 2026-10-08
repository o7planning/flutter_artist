import 'package:flutter/material.dart';
import '../../core/_core_/core.dart';
import '../../core/utils/__utils.dart';

/// A universal and transparent inspection view that takes any [ClassDefViewable] object,
/// automatically extracts its class name and generic type mapping using [getTypeNameWithoutGenerics],
/// and dynamically calculates label widths using [TextSizeUtils] for optimal layout spacing.
class ClassDefView extends StatelessWidget {
  final String title;
  final ClassDefViewable targetObject;

  const ClassDefView({
    required this.title,
    required this.targetObject,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Extract clean class name without generic artifacts using the correct framework helper.
    final String className =
        getTypeNameWithoutGenerics(targetObject.runtimeType);

    // Automatically retrieve generic parameters map from the ClassDefViewable contract.
    final Map<String, Type> genericsInfoMap = targetObject.getGenericsInfoMap();
    final List<MapEntry<String, Type>> entriesList =
        genericsInfoMap.entries.toList();

    // Dynamically calculate the maximum required width for parameter labels using TextSizeUtils.
    double maxLabelWidth = 100.0; // Minimum baseline width fallback
    const TextStyle labelStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    for (final entry in entriesList) {
      final Size size = TextSizeUtils.calculateTextSize(
        text: entry.key,
        style: labelStyle,
      );
      if (size.width > maxLabelWidth) {
        maxLabelWidth = size.width;
      }
    }
    // Add a safe padding buffer (e.g., 24px) so text never feels cramped against values.
    final double computedLabelWidth = maxLabelWidth + 24.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===================================================================
          // FIXED HEADER SECTION (Non-scrollable)
          // ===================================================================
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),

          // Class Name Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Class name: ",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Expanded(
                child: SelectableText(
                  className,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),

          if (entriesList.isNotEmpty) ...[
            const SizedBox(height: 8),
            Divider(
              height: 1,
              thickness: 0.5,
              color: theme.dividerColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 8),

            // Parameters Header Title (Fixed)
            Text(
              "Parameters:",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 6),

            // ===================================================================
            // SCROLLABLE PARAMETERS SECTION (Vertical scrolling inside dynamic box)
            // ===================================================================
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 220,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: entriesList.length,
                itemBuilder: (context, index) {
                  final entry = entriesList[index];
                  final String paramKey = entry.key;
                  final Type paramType = entry.value;
                  final String paramTypeName =
                      getTypeNameWithoutGenerics(paramType);

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dynamically allocated width based on the longest parameter key string
                        SizedBox(
                          width: computedLabelWidth,
                          child: Text(
                            paramKey,
                            style: labelStyle.copyWith(
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SelectableText(
                            paramTypeName,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
