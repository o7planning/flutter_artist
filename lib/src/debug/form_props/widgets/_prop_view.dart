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
import '_prop_error_view.dart';

class FormPropView extends StatelessWidget {
  final bool formInitialDataReady;
  final FormProp prop;

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
          ListTile(
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity(horizontal: -3, vertical: -3),
            dense: true,
            horizontalTitleGap: 0,
            minVerticalPadding: 0,
            minLeadingWidth: 40,
            minTileHeight: 0,
            leading: Icon(
              prop is SimpleFormProp
                  ? FaIconConstants.simplePropOrCriterionIconData
                  : FaIconConstants.optPropOrCriterionIconData,
              size: 20,
            ),
            title: IconLabelText(
              label: prop is SimpleFormProp
                  ? 'Prop Name: '
                  : 'Multi Opt Prop Name: ',
              text: prop.propName,
              textStyle: TextStyle(color: Colors.indigo),
            ),
            subtitle: IconLabelText(
              label: getClassNameWithoutGenerics(prop),
              text: "<${prop.dataType.toString()}>",
              labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textStyle: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
          Divider(),
          if (prop is MultiOptFormProp) SizedBox(height: 5),
          if (prop is MultiOptFormProp)
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Single Selection",
                      child: Radio(
                        value: (prop as MultiOptFormProp).selectionType ==
                            SelectionType.single,
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
                        value: (prop as MultiOptFormProp).selectionType ==
                            SelectionType.multi,
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
            if (prop is MultiOptFormProp)
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
            if (prop is MultiOptFormProp)
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
            " - ${value!.runtimeType.toString()}",
            style: TextStyle(
              fontSize: 12,
            ),
          );
  }
}
