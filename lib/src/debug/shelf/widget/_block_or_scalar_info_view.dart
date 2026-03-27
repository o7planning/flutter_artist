import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../../core/icon/icon_constants.dart';
import '../../constants/_debug_constants.dart';
import '../../storage/_block_or_scalar.dart';

class BlockOrScalarInfoView extends StatelessWidget {
  final BlockOrScalar blockOrScalar;

  const BlockOrScalarInfoView({super.key, required this.blockOrScalar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0,
      horizontalTitleGap: 5,
      dense: true,
      visualDensity: const VisualDensity(
        horizontal: -3,
        vertical: -3,
      ),
      leading: Icon(
        blockOrScalar.isBlock
            ? FaIconConstants.blockIconData
            : FaIconConstants.scalarIconData,
        size: 18,
        color: colorScheme.onSurface.withValues(alpha: 0.8),
      ),
      title: SelectableText.rich(
        style: TextStyle(fontSize: DebugConstants.blockOrScalaInfoFontSize),
        TextSpan(
          children: [
            WidgetSpan(child: SizedBox(width: 3)),
            TextSpan(
              text: blockOrScalar.blockOrScalarClassName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            TextSpan(
              text: blockOrScalar.blockOrScalarClassParametersDefinition,
              style: TextStyle(
                color: FaColorUtils.technicalHighlight(context),
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
      ),
      subtitle: blockOrScalar.description == null
          ? null
          : Text(
              blockOrScalar.description!,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
    );
  }
}
