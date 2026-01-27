import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
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
    return CustomAppContainer(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity(horizontal: -3, vertical: -3),
            dense: true,
            horizontalTitleGap: 0,
            minVerticalPadding: 0,
            minLeadingWidth: 40,
            minTileHeight: 0,
            leading: Icon(
              FaIconConstants.conditionGroupIconData,
              size: 20,
            ),
            title: IconLabelSelectableText(
              label: 'Condition Group Name: ',
              text: conditionGroupModel.groupName,
              textStyle: TextStyle(color: Colors.indigo),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconLabelSelectableText(
                  label: "Connector: ",
                  text: conditionGroupModel.connector.text,
                  labelStyle:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textStyle: TextStyle(fontSize: 12, color: Colors.blue),
                ),
                IconLabelSelectableText(
                  label: "Supported Connectors: ",
                  text: conditionGroupModel.supportedConnectors
                      .map((o) => o.text)
                      .toList()
                      .toString(),
                  labelStyle:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildDetails(FilterCriterionModel criterionModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SimpleAccordion(
          children: [
            SimpleAccordionSection(
              initiallyExpanded: true,
              headerTitle: Text(
                "Initial Value:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              headerSubtitle: _headerSubtitle(criterionModel.initialValue),
              content: DynamicValueView(value: criterionModel.initialValue),
            ),
            SimpleAccordionSection(
              initiallyExpanded: true,
              headerTitle: Text(
                "Current Value:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              headerSubtitle: _headerSubtitle(criterionModel.currentValue),
              content: DynamicValueView(value: criterionModel.currentValue),
            ),
            if (criterionModel is MultiOptFilterCriterionModel)
              SimpleAccordionSection(
                initiallyExpanded: true,
                headerTitle: Text(
                  "Initial XData:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerSubtitle: _headerSubtitle(criterionModel.initialXData),
                content: XDataView(xData: criterionModel.initialXData),
              ),
            if (criterionModel is MultiOptFilterCriterionModel)
              SimpleAccordionSection(
                initiallyExpanded: true,
                headerTitle: Text(
                  "Current XData:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerSubtitle: _headerSubtitle(criterionModel.currentXData),
                content: XDataView(xData: criterionModel.currentXData),
              ),
          ],
        ),
      ],
    );
  }

  Text? _headerSubtitle(dynamic value) {
    return value == null
        ? null
        : Text(
            " - ${value!.runtimeType.toString()}",
            style: TextStyle(
              fontSize: 12,
            ),
          );
  }
}
