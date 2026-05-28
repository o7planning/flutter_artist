import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../../../core/_core_/core.dart';

class FilterCriterionView extends StatelessWidget {
  final FilterCriterion filterCriterion;
  final bool selected;
  final Function(FilterCriterion filterCriterion) onPressed;

  const FilterCriterionView({
    super.key,
    required this.filterCriterion,
    required this.selected,
    required this.onPressed,
  });

  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
      color: selected
          ? context.faColors.action.fill.primaryTonal.selected
          : context.faColors.action.fill.primaryTonal,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
        side: selected
            ? BorderSide(
                color: context.faColors.action.stroke.primary, width: 0.5)
            : BorderSide.none,
      ),
      child: ListTile(
        onTap: () => onPressed(filterCriterion),
        dense: true,
        visualDensity: const VisualDensity(vertical: -3, horizontal: -3),
        minLeadingWidth: 0,
        minTileHeight: 0,
        minVerticalPadding: 0,
        horizontalTitleGap: 10,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        leading: SimpleSmallIconButton(
          iconData: Icons.verified,
          iconSize: 16,
          iconColor: selected
              ? context.faColors.action.ink.primary
              : context.faColors.action.ink.tertiaryQuiet,
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: context.faColors.ink.primary,
            ),
            children: [
              TextSpan(text: filterCriterion.filterCriterionName),
              const TextSpan(text: " "),
              TextSpan(
                text: "<${filterCriterion.rawDataType}>",
                style: TextStyle(
                  color: context.faColors.ink.highlight,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          filterCriterion.filterFieldName,
          style: TextStyle(
            fontSize: 12,
            color: context.faColors.ink.code,
          ),
        ),
      ),
    );
  }
}
