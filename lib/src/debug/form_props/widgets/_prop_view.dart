import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/icon/icon_constants.dart';
import '../../../core/widgets/_custom_app_container.dart';
import '../../../core/widgets/_simple_accordion.dart';
import '../../../core/widgets/_simple_accordion_section.dart';
import '../../widgets/_dynamic_value_view.dart';
import '../../widgets/_xdata_view.dart';
import '_prop_error_view.dart';

class FormPropView extends StatelessWidget {
  final bool formInitialDataReady;
  final Prop prop;

  const FormPropView({
    super.key,
    required this.prop,
    required this.formInitialDataReady,
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
              prop is SimpleProp
                  ? FaIconConstants.simplePropOrCriterionIconData
                  : FaIconConstants.optPropOrCriterionIconData,
              size: 18,
            ),
            label: prop is SimpleProp ? 'Prop Name: ' : 'Multi Opt Prop Name: ',
            text: prop.propName,
          ),
          if (prop is MultiOptProp) SizedBox(height: 5),
          if (prop is MultiOptProp)
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Single Selection",
                      child: Radio(
                        value: (prop as MultiOptProp).singleSelection,
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
                        value: !(prop as MultiOptProp).singleSelection,
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
            if (prop.formErrorInfo != null)
              SimpleAccordionSection(
                initiallyExpanded: true,
                headerTitle: Text(
                  "Error Info:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerSubtitle: null,
                content: FormErrorPropView(
                  formInitialDataReady: formInitialDataReady,
                  formErrorInfo: prop.formErrorInfo!,
                ),
              ),
            SimpleAccordionSection(
              initiallyExpanded: true,
              headerTitle: Text(
                "Initial Value:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              headerSubtitle: _headerSubtitle(prop.initialValue),
              content: DynamicValueView(value: prop.initialValue),
            ),
            SimpleAccordionSection(
              initiallyExpanded: true,
              headerTitle: Text(
                "Current Value:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              headerSubtitle: _headerSubtitle(prop.currentValue),
              content: DynamicValueView(value: prop.currentValue),
            ),
            if (prop is MultiOptProp)
              SimpleAccordionSection(
                initiallyExpanded: true,
                headerTitle: Text(
                  "Initial XData:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerSubtitle: _headerSubtitle(prop.initialXData),
                content: XDataView(xData: prop.initialXData),
              ),
            if (prop is MultiOptProp)
              SimpleAccordionSection(
                initiallyExpanded: true,
                headerTitle: Text(
                  "Current XData:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerSubtitle: _headerSubtitle(prop.currentXData),
                content: XDataView(xData: prop.currentXData),
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
