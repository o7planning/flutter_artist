import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/_selection_type.dart';
import '../../../core/icon/icon_constants.dart';
import '../../../core/utils/_class_utils.dart';
import '../../../core/widgets/_custom_app_container.dart';

class FilterCriterionDefView extends StatelessWidget {
  final FilterCriterionDef criterion;

  const FilterCriterionDefView({
    super.key,
    required this.criterion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSimple = criterion is SimpleFilterCriterionDef;

    return CustomAppContainer(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            dense: true,
            horizontalTitleGap: 8,
            leading: Icon(
              isSimple
                  ? FaIconConstants.simplePropOrCriterionIconData
                  : FaIconConstants.optPropOrCriterionIconData,
              size: 20,
              color: colorScheme.primary,
            ),
            title: IconLabelSelectableText(
              label: isSimple
                  ? 'Criterion Base Name: '
                  : 'Multi Opt Criterion Base Name: ',
              text: criterion.criterionBaseName,
              textStyle: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: IconLabelSelectableText(
                label: getClassNameWithoutGenerics(criterion),
                text: " <${criterion.dataType.toString()}>",
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.tertiary,
                ),
              ),
            ),
          ),
          const Divider(height: 20),
          if (criterion is MultiOptFilterCriterionDef) ...[
            _buildSelectionTypeRow(
                context, criterion as MultiOptFilterCriterionDef),
            const Divider(height: 20),
          ],
          Expanded(
            child: SingleChildScrollView(
              child: _buildDetails(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionTypeRow(
      BuildContext context, MultiOptFilterCriterionDef def) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMulti = def.selectionType == SelectionType.multi;

    return Row(
      children: [
        _buildSelectionBadge(
          context,
          "SINGLE",
          !isMulti,
          Icons.radio_button_checked,
        ),
        const SizedBox(width: 12),
        _buildSelectionBadge(
          context,
          "MULTI",
          isMulti,
          Icons.check_box_rounded,
        ),
      ],
    );
  }

  Widget _buildSelectionBadge(
      BuildContext context, String label, bool isActive, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 14,
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isActive
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    bool needsConversion =
        !criterion.isSimpleDataType && !criterion.toFieldValueProvided;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconLabelSelectableText(
          label: "Field Name: ",
          text: criterion.fieldName,
          labelStyle: _labelStyle(context),
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
            color: colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 10),
        _buildInfoBlock(
          context,
          label: "toFieldValue(): ",
          value:
              criterion.toFieldValueProvided ? "[Provided]" : "[Not Provided]",
          isError: needsConversion,
          desc: criterion.isSimpleDataType
              ? "Simple data type <${criterion.dataType}>, conversion is handled automatically."
              : "Data type <${criterion.dataType}> requires a custom conversion function.",
        ),
        const SizedBox(height: 15),
        IconLabelSelectableText(
          label: "Description: ",
          text: criterion.description ?? "No description provided.",
          labelStyle: _labelStyle(context),
          textStyle: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBlock(BuildContext context,
      {required String label,
      required String value,
      required bool isError,
      required String desc}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: _labelStyle(context)),
            Text(value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isError ? colorScheme.error : colorScheme.onSurface,
                )),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isError
                ? colorScheme.errorContainer.withValues(alpha: 0.3)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: isError
                    ? colorScheme.error.withValues(alpha: 0.2)
                    : colorScheme.outlineVariant.withValues(alpha: 0.1)),
          ),
          child: Text(
            desc,
            style: TextStyle(
              fontSize: 11,
              color: isError ? colorScheme.error : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _labelStyle(BuildContext context) {
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
    );
  }
}
