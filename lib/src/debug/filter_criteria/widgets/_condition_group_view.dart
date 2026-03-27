import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/_filter_connector.dart';
import '../../../core/icon/icon_constants.dart';
import '../../../core/widgets/_custom_app_container.dart';
import '../../../core/widgets/_simple_accordion.dart';
import '../../../core/widgets/_simple_accordion_section.dart';
import '../../widgets/_dynamic_value_view.dart';
import '../../widgets/_xdata_view.dart';

class ConditionGroupView extends StatelessWidget {
  final ConditionGroupModelImpl conditionGroupModel;

  const ConditionGroupView({
    super.key,
    required this.conditionGroupModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isOr = conditionGroupModel.connector == FilterConnector.or;
    final Color connectorColor =
        isOr ? colorScheme.tertiary : colorScheme.primary;

    return CustomAppContainer(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            dense: true,
            horizontalTitleGap: 8,
            leading: Icon(
              FaIconConstants.conditionGroupIconData,
              size: 20,
              color: connectorColor,
            ),
            title: IconLabelSelectableText(
              label: 'Condition Group Name: ',
              text: conditionGroupModel.groupName,
              textStyle: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogicBadge(
                    context,
                    label: "Connector: ",
                    value: conditionGroupModel.connector.text.toUpperCase(),
                    color: connectorColor,
                  ),
                  const SizedBox(height: 8),
                  IconLabelSelectableText(
                    label: "Supported Connectors: ",
                    text: conditionGroupModel.supportedConnectors
                        .map((o) => o.text.toUpperCase())
                        .join(", "),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    textStyle: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                      fontFamily: 'Courier',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 24),
          // Ở đây có thể thêm List các conditions con nếu cần,
          // nhưng hiện tại view này đang làm header cho Right Panel
        ],
      ),
    );
  }

  Widget _buildLogicBadge(BuildContext context,
      {required String label, required String value, required Color color}) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            )),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
