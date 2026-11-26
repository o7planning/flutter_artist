import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/_core_/_enums_/_enums.dart';
import '../../../core/icon/icon_constants.dart';
import '../../../core/utils/__utils.dart';
import '../../../core/widgets/__widgets.dart';
import '../../widgets/_dynamic_value_view.dart';
import '../../widgets/_xdata_view.dart';

class TildeFilterCriterionView extends StatelessWidget {
  final TildeFilterCriterionModel criterion;

  const TildeFilterCriterionView({
    super.key,
    required this.criterion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPlain = criterion is PlainTildeFilterCriterionModel;

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
              isPlain
                  ? FaIconConstants.plainPropOrCriterionIconData
                  : FaIconConstants.managedPropOrCriterionIconData,
              size: 20,
              color: colorScheme.primary,
            ),
            title: IconLabelText(
              label: isPlain
                  ? 'Criterion Name Tilde: '
                  : 'Multi Opt Criterion Name Tilde: ',
              text: criterion.tildeCriterionName,
              // CHIÊU 1: Hít màu Primary đậm đà
              textStyle: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _buildSubtitle(context),
            ),
          ),
          const Divider(height: 20),
          if (criterion is ManagedOptTildeFilterCriterionModel) ...[
            _buildSelectionTypeRow(
                context, criterion as ManagedOptTildeFilterCriterionModel),
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

  Widget _buildSubtitle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconLabelText(
          label: getClassNameWithoutGenerics(criterion),
          text: " <${criterion.dataType.toString()}>",
          labelStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withValues(alpha: 0.6)),
          textStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: colorScheme.tertiary),
        ),
        if (criterion is ManagedOptTildeFilterCriterionModel) ...[
          const SizedBox(height: 4),
          _buildSubtitleItem(
              context,
              "Policy: ",
              (criterion as ManagedOptTildeFilterCriterionModel)
                  .defaultSettingPolicy
                  .name),
          const SizedBox(height: 4),
          _buildSubtitleItem(
              context,
              "Suffix: ",
              (criterion as ManagedOptTildeFilterCriterionModel)
                      .parentMatchSuffix ??
                  "null"),
        ]
      ],
    );
  }

  Widget _buildSubtitleItem(BuildContext context, String label, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconLabelText(
      label: label,
      text: text,
      labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface.withValues(alpha: 0.5)),
      textStyle: TextStyle(fontSize: 11, color: colorScheme.secondary),
    );
  }

  Widget _buildSelectionTypeRow(
      BuildContext context, ManagedOptTildeFilterCriterionModel def) {
    final isMulti = def.selectionMode == ManagedOptSelectionMode.multi;
    return Row(
      children: [
        _buildSelectionBadge(
            context, "SINGLE SELECTION", !isMulti, Icons.radio_button_checked),
        const SizedBox(width: 10),
        _buildSelectionBadge(
            context, "MULTI SELECTION", isMulti, Icons.check_box_rounded),
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
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        SimpleAccordion(
          children: [
            _buildAccordionSection(
                context,
                "Initial Value",
                criterion.initialValue,
                DynamicValueView(value: criterion.initialValue)),
            _buildAccordionSection(
                context,
                "Current Value",
                criterion.currentValue,
                DynamicValueView(value: criterion.currentValue)),
            if (criterion is ManagedOptTildeFilterCriterionModel) ...[
              _buildAccordionSection(
                  context,
                  "Initial XData",
                  (criterion as ManagedOptTildeFilterCriterionModel)
                      .initialXData,
                  XDataView(
                      xData: (criterion as ManagedOptTildeFilterCriterionModel)
                          .initialXData)),
              _buildAccordionSection(
                  context,
                  "Current XData",
                  (criterion as ManagedOptTildeFilterCriterionModel)
                      .currentXData,
                  XDataView(
                      xData: (criterion as ManagedOptTildeFilterCriterionModel)
                          .currentXData)),
            ],
          ],
        ),
      ],
    );
  }

  SimpleAccordionSection _buildAccordionSection(
      BuildContext context, String title, dynamic value, Widget content) {
    final colorScheme = Theme.of(context).colorScheme;
    return SimpleAccordionSection(
      initiallyExpanded: true,
      headerTitle: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: colorScheme.onSurface),
      ),
      headerSubtitle: value == null
          ? null
          : Text(
              " - ${value.runtimeType.toString()}",
              style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic),
            ),
      content: content,
    );
  }
}
