import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/_selection_type.dart';
import '../../../core/icon/icon_constants.dart';
import '../../../core/utils/_class_utils.dart';
import '../../../core/widgets/_custom_app_container.dart';
import '../../../core/widgets/_simple_accordion.dart';
import '../../../core/widgets/_simple_accordion_section.dart';
import '../../widgets/_dynamic_value_view.dart';
import '../../widgets/_xdata_view.dart';

class FilterConditionModelView extends StatelessWidget {
  final ConditionModelImpl conditionModel;

  const FilterConditionModelView({
    super.key,
    required this.conditionModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final TildeFilterCriterionModel criterionModel =
        conditionModel.tildeFilterCriterionModel;
    final isSimple = criterionModel is SimpleTildeFilterCriterionModel;

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
              label: isSimple ? 'Criterion: ' : 'Multi Opt Criterion: ',
              text: conditionModel.tildeCriterionName,
              textStyle: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _buildSubtitle(context, criterionModel),
            ),
          ),
          const Divider(height: 20),
          if (criterionModel is MultiOptTildeFilterCriterionModel) ...[
            _buildSelectionTypeRow(context, criterionModel),
            const Divider(height: 20),
          ],
          Expanded(
            child: SingleChildScrollView(
              child: _buildDetails(context, criterionModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, TildeFilterCriterionModel model) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconLabelSelectableText(
          label: getClassNameWithoutGenerics(model),
          text: " <${model.dataType.toString()}>",
          labelStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withValues(alpha: 0.6)),
          textStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: colorScheme.tertiary),
        ),
        const SizedBox(height: 6),
        _buildOperatorRow(
            context, "Active Operator: ", conditionModel.operator.name,
            isPrimary: true),
        const SizedBox(height: 4),
        _buildOperatorRow(context, "Supported: ",
            conditionModel.supportedOperators.map((o) => o.text).join(", ")),
      ],
    );
  }

  Widget _buildOperatorRow(BuildContext context, String label, String text,
      {bool isPrimary = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconLabelSelectableText(
      label: label,
      text: text,
      labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface.withValues(alpha: 0.5)),
      textStyle: TextStyle(
        fontSize: 11,
        fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
        color: isPrimary ? colorScheme.secondary : colorScheme.onSurfaceVariant,
        fontFamily: 'Courier',
      ),
    );
  }

  Widget _buildSelectionTypeRow(
      BuildContext context, MultiOptTildeFilterCriterionModel model) {
    final isMulti = model.selectionType == SelectionType.multi;
    return Row(
      children: [
        _buildBadge(context, "SINGLE", !isMulti, Icons.radio_button_checked),
        const SizedBox(width: 10),
        _buildBadge(context, "MULTI", isMulti, Icons.check_box_rounded),
      ],
    );
  }

  Widget _buildBadge(
      BuildContext context, String label, bool isActive, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
            color: isActive ? colorScheme.primary : colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 14,
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context, TildeFilterCriterionModel model) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SimpleAccordion(
          children: [
            _buildSection(context, "Initial Value", model.initialValue),
            _buildSection(context, "Current Value", model.currentValue),
            if (model is MultiOptTildeFilterCriterionModel) ...[
              _buildSection(context, "Initial XData", model.initialXData),
              _buildSection(context, "Current XData", model.currentXData),
            ],
          ],
        ),
      ],
    );
  }

  SimpleAccordionSection _buildSection(
      BuildContext context, String title, dynamic value) {
    final colorScheme = Theme.of(context).colorScheme;
    return SimpleAccordionSection(
      initiallyExpanded: true,
      headerTitle: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: colorScheme.onSurface)),
      headerSubtitle: value == null
          ? null
          : Text(" - ${value.runtimeType}",
              style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic)),
      content: value is Map || value is List
          ? DynamicValueView(value: value)
          : (value is XData
              ? XDataView(xData: value)
              : DynamicValueView(value: value)),
    );
  }
}
