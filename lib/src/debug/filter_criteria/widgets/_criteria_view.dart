import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_fa_core.dart';
import '../../../icon/icon_constants.dart';
import '../../../widgets/_custom_app_container.dart';
import '../../../widgets/_simple_accordion.dart';
import '../../../widgets/_simple_accordion_section.dart';
import '../../widgets/_dynamic_value_view.dart';
import '../../widgets/_xdata_view.dart';

class FilterCriterionView extends StatelessWidget {
  final Criterion criterion;

  const FilterCriterionView({
    super.key,
    required this.criterion,
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
          IconLabelText(
            icon: Icon(
              criterion is SimpleCriterion
                  ? FaIconConstants.simplePropOrCriterionIconData
                  : FaIconConstants.optPropOrCriterionIconData,
              size: 18,
            ),
            label: criterion is SimpleCriterion
                ? 'Criterion Name: '
                : 'Multi Opt Criterion Name: ',
            text: criterion.criterionName,
          ),
          if (criterion is MultiOptCriterion) SizedBox(height: 5),
          if (criterion is MultiOptCriterion)
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Single Selection",
                      child: Radio(
                        value: (criterion as MultiOptCriterion).singleSelection,
                        onChanged: null,
                        groupValue: true,
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
                        value:
                            !(criterion as MultiOptCriterion).singleSelection,
                        onChanged: null,
                        groupValue: true,
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
                );
              },
            ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: _buildDetails(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
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
              headerSubtitle: _headerSubtitle(criterion.initialValue),
              content: DynamicValueView(value: criterion.initialValue),
            ),
            SimpleAccordionSection(
              initiallyExpanded: true,
              headerTitle: Text(
                "Current Value:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              headerSubtitle: _headerSubtitle(criterion.currentValue),
              content: DynamicValueView(value: criterion.currentValue),
            ),
            if (criterion is MultiOptCriterion)
              SimpleAccordionSection(
                initiallyExpanded: true,
                headerTitle: Text(
                  "Initial XData:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerSubtitle: _headerSubtitle(criterion.initialXData),
                content: XDataView(xData: criterion.initialXData),
              ),
            if (criterion is MultiOptCriterion)
              SimpleAccordionSection(
                initiallyExpanded: true,
                headerTitle: Text(
                  "Current XData:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerSubtitle: _headerSubtitle(criterion.currentXData),
                content: XDataView(xData: criterion.currentXData),
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
            " - ${value!.runtimeType?.toString()}" ?? "",
            style: TextStyle(
              fontSize: 12,
            ),
          );
  }
}
