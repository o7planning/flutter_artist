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

class FilterCriterionModelView extends StatelessWidget {
  final FilterCriterionModel criterionModel;

  const FilterCriterionModelView({
    super.key,
    required this.criterionModel,
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
              criterionModel is SimpleFilterCriterionModel
                  ? FaIconConstants.simplePropOrCriterionIconData
                  : FaIconConstants.optPropOrCriterionIconData,
              size: 20,
            ),
            title: IconLabelSelectableText(
              label: criterionModel is SimpleFilterCriterionModel
                  ? 'Criterion Name Plus: '
                  : 'Multi Opt Criterion Name Plus: ',
              text: criterionModel.criterionNamePlus,
              textStyle: TextStyle(color: Colors.indigo),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconLabelSelectableText(
                  label: getClassNameWithoutGenerics(criterionModel),
                  text: "<${criterionModel.dataType.toString()}>",
                  labelStyle:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textStyle: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ),
          ),
          Divider(),
          if (criterionModel is MultiOptFilterCriterionModel)
            SizedBox(height: 5),
          if (criterionModel is MultiOptFilterCriterionModel)
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return RadioGroup(
                  onChanged: (_) {},
                  groupValue: (criterionModel as MultiOptFilterCriterionModel)
                      .selectionType,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Tooltip(
                        message: "Single Selection",
                        child: Radio(
                          value: SelectionType.single,
                        ),
                      ),
                      if (constraints.constrainWidth() > 200)
                        Text(
                          "Single Selection",
                          style: TextStyle(
                            fontSize: 13,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      SizedBox(width: 5),
                      Tooltip(
                        message: "Multi Selection",
                        child: Radio(
                          value: SelectionType.multi,
                        ),
                      ),
                      if (constraints.constrainWidth() > 200)
                        Expanded(
                          child: Text(
                            "Multi Selection",
                            style: TextStyle(
                              fontSize: 13,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: _buildDetails(criterionModel),
            ),
          ),
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
