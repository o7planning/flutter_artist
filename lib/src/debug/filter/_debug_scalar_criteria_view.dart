import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/utils/_class_utils.dart';
import '../state_view/_debug_scalar_state_view.dart';
import '../state_view/options/_debug_scalar_options.dart';
import '../widgets/_html_info_view.dart';

class DebugScalarCriteriaView extends StatelessWidget {
  final Scalar scalar;

  const DebugScalarCriteriaView({super.key, required this.scalar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    FilterModel filterModel = scalar.registeredOrDefaultFilterModel;
    String scalarClassName = getClassNameWithoutGenerics(scalar);
    String filterClassName = getClassNameWithoutGenerics(filterModel);
    bool isCriteriaNull = scalar.filterCriteria == null;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCriteriaShortDocument(
            filterClassName: filterClassName,
            scalarClassName: scalarClassName,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: (isCriteriaNull ? colorScheme.error : colorScheme.primary)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color:
                    (isCriteriaNull ? colorScheme.error : colorScheme.primary)
                        .withValues(alpha: 0.2),
              ),
            ),
            child: IconLabelSelectableText(
              icon: Icon(
                isCriteriaNull
                    ? Icons.cancel_outlined
                    : Icons.check_circle_outline,
                size: 16,
                color: isCriteriaNull ? colorScheme.error : colorScheme.primary,
              ),
              label: "$scalarClassName.filterCriteria: ",
              text: isCriteriaNull ? "NULL" : "NOT NULL",
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isCriteriaNull ? colorScheme.error : colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: DebugScalarStateView(
                scalar: scalar,
                vertical: false,
                debugScalarOptions: DebugScalarOptions(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaShortDocument({
    required String filterClassName,
    required String scalarClassName,
  }) {
    return HtmlInfoView(
      infoAsHtml:
          "The <b>$filterClassName.filterCriteria</b> is used as a parameter to query the <b>$scalarClassName</b>. "
          "If successful, it will be assigned to <b>$scalarClassName.filterCriteria</b>. "
          "Otherwise, it can be <b>null</b>. "
          "It also resets to <b>null</b> if the Scalar is in <b>'none'</b> or <b>'pending'</b> state.",
    );
  }
}
