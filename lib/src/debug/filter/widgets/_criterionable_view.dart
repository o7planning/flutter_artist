import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';

class CriterionableView extends StatelessWidget {
  final Criterionable criterionable;
  final bool selected;
  final Function(Criterionable criterionable) onPressed;

  const CriterionableView({
    super.key,
    required this.criterionable,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
      color: selected ? Colors.indigo.withAlpha(40) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: ListTile(
        onTap: () {
          onPressed(criterionable);
        },
        dense: true,
        visualDensity: VisualDensity(vertical: -3, horizontal: -3),
        minLeadingWidth: 0,
        minTileHeight: 0,
        minVerticalPadding: 0,
        horizontalTitleGap: 10,
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        leading: SimpleSmallIconButton(
          iconData: Icons.verified,
          iconSize: 16,
        ),
        title: Text(
          "${criterionable.criterionBaseName} <${criterionable.baseDataType}>",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          criterionable.jsonCriterionName,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
