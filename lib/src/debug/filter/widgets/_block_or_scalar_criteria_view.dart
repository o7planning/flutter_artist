import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/_data_state.dart';
import '../../../core/icon/icon_constants.dart';
import '../../storage/_block_or_scalar.dart';

class BlockOrScalarCriteriaView extends StatelessWidget {
  final BlockOrScalar blockOrScalar;

  const BlockOrScalarCriteriaView({super.key, required this.blockOrScalar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        minLeadingWidth: 0,
        horizontalTitleGap: 12,
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: Icon(
          blockOrScalar.isBlock
              ? FaIconConstants.blockIconData
              : FaIconConstants.scalarIconData,
          size: 18,
          color: colorScheme.primary.withValues(alpha: 0.8),
        ),
        title: Text(
          blockOrScalar.blockOrScalarClassName,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: _buildStatusBar(context, blockOrScalar),
        ),
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context, BlockOrScalar blockOrScalar) {
    final colorScheme = Theme.of(context).colorScheme;
    DataState dataState = blockOrScalar.dataState;
    FilterCriteria? filterCriteria = blockOrScalar.filterCriteria;

    final labelStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface.withValues(alpha: 0.5),
    );
    final textStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w500);

    return Wrap(
      spacing: 12,
      children: [
        _buildStatusItem(
          context,
          label: 'Data State: ',
          value: dataState.name.toUpperCase(),
          valueColor: dataState == DataState.error
              ? colorScheme.error
              : (dataState == DataState.ready
                  ? Colors.green
                  : colorScheme.onSurface),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
        _buildStatusItem(
          context,
          label: "Filter Criteria: ",
          value: filterCriteria == null ? 'NULL' : 'NOT NULL',
          valueColor:
              filterCriteria == null ? colorScheme.error : colorScheme.primary,
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      ],
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required String label,
    required String value,
    required Color valueColor,
    required TextStyle labelStyle,
    required TextStyle textStyle,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: textStyle.copyWith(color: valueColor)),
      ],
    );
  }
}
