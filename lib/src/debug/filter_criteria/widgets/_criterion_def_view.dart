import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/_selection_type.dart';
import '../../../core/icon/icon_constants.dart';
import '../../../core/utils/_class_utils.dart';
import '../../../core/widgets/_custom_app_container.dart';

class FilterCriterionDefView extends StatelessWidget {
  final FilterCriterionDef criterion;

  const FilterCriterionDefView({
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
          ListTile(
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity(horizontal: -3, vertical: -3),
            dense: true,
            horizontalTitleGap: 0,
            minVerticalPadding: 0,
            minLeadingWidth: 40,
            minTileHeight: 0,
            leading: Icon(
              criterion is SimpleFilterCriterionDef
                  ? FaIconConstants.simplePropOrCriterionIconData
                  : FaIconConstants.optPropOrCriterionIconData,
              size: 20,
            ),
            title: IconLabelSelectableText(
              label: criterion is SimpleFilterCriterionDef
                  ? 'Criterion Base Name: '
                  : 'Multi Opt Criterion Base Name: ',
              text: criterion.criterionBaseName,
              textStyle: TextStyle(color: Colors.indigo),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconLabelSelectableText(
                  label: getClassNameWithoutGenerics(criterion),
                  text: "<${criterion.dataType.toString()}>",
                  labelStyle:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textStyle: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ),
          ),
          Divider(),
          if (criterion is MultiOptFilterCriterionDef) SizedBox(height: 5),
          if (criterion is MultiOptFilterCriterionDef)
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Single Selection",
                      child: Radio(
                        value: (criterion as MultiOptFilterCriterionDef)
                                .selectionType ==
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
                        value: (criterion as MultiOptFilterCriterionDef)
                                .selectionType ==
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
          if (criterion is MultiOptFilterCriterionDef) Divider(),
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
        IconLabelSelectableText(
          label: "Field Name: ",
          text: criterion.fieldName,
          labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 5),
        IconLabelSelectableText(
          label: "toFieldValue(): ",
          text:
              criterion.toFieldValueProvided ? "[Provided]" : "[Not Provided]",
          labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight:
                criterion.isSimpleDataType || criterion.toFieldValueProvided
                    ? FontWeight.normal
                    : FontWeight.bold,
            color: criterion.isSimpleDataType || criterion.toFieldValueProvided
                ? Colors.black
                : Colors.deepOrange,
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.only(left: 10),
          child: criterion.isSimpleDataType
              ? SelectableText(
                  "The data type of this criterion is <${criterion.dataType}> (Simple data type), "
                  "so a conversion function is not necessary.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                )
              : SelectableText(
                  "The data type of this criterion is <${criterion.dataType}> (Not a simple data type), "
                  "so you need to provide a conversion function.",
                  style: TextStyle(
                    fontSize: 12,
                    color: criterion.isSimpleDataType ||
                            criterion.toFieldValueProvided
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
        ),
        SizedBox(height: 10),
        IconLabelSelectableText(
          label: "Description: ",
          text: criterion.description ?? "",
          labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          textStyle: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
