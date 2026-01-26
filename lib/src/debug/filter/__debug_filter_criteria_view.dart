import 'package:flutter/material.dart';
import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/debug/filter/widgets/_criterionable_view.dart';
import 'package:flutter_artist/src/debug/widgets/_json_view.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_left_right_container/left_right_container.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/icon/icon_constants.dart';
import '../utils/_tab_theme_utils.dart';
import '../widgets/_html_info_view.dart';

class FilterCriteriaView extends StatefulWidget {
  final FilterModel filterModel;
  final Function() onDebugFilterModelPressed;

  const FilterCriteriaView({
    super.key,
    required this.filterModel,
    required this.onDebugFilterModelPressed,
  });

  @override
  State<StatefulWidget> createState() {
    return _FilterCriteriaViewState();
  }
}

class _FilterCriteriaViewState extends State<FilterCriteriaView> {
  Criterionable? _selectedCriterionable;
  FilterCriteria? filterCriteria;

  @override
  void initState() {
    super.initState();
    filterCriteria = widget.filterModel.filterCriteria;
    _selectedCriterionable = filterCriteria?.criterionableList.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCriteriaShortDocument(
            filterModelClassName:
                getClassNameWithoutGenerics(widget.filterModel),
            criteriaClassName: getClassNameWithoutGenerics(filterCriteria),
          ),
          SizedBox(height: 10),
          Expanded(
            child: _buildTabs(),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaShortDocument({
    required String filterModelClassName,
    required String criteriaClassName,
  }) {
    return HtmlInfoView(
      infoAsHtml: "The <b>$criteriaClassName</b> object is created by the "
          "<b>$filterModelClassName.toFilterCriteriaObject()</b> method, and can be retrieved via the "
          "<b>$filterModelClassName.filterCriteria</b> property. "
          "Note: This property can be <b>null</b> if there is an error in the <b>$filterModelClassName</b>.",
      style: TextStyle(fontSize: 13),
    );
  }

  Widget _buildLeftRightCriterionable() {
    return LeftRightContainer(
      startPadding: EdgeInsets.all(5),
      endPadding: EdgeInsets.all(5),
      spacing: 20,
      fixedSizeWidth: 260,
      minSideWidth: 240,
      fixedSide: FixedSide.end,
      start: ListView(
        children: (filterCriteria?.criterionableList ?? [])
            .map(
              (c) => CriterionableView(
                criterionable: c,
                selected: c.criterionBaseName ==
                    _selectedCriterionable?.criterionBaseName,
                onPressed: (Criterionable<dynamic> criterionable) {
                  setState(() {
                    _selectedCriterionable = criterionable;
                  });
                },
              ),
            )
            .toList(),
      ),
      end: _buildCriterionableValue(),
    );
  }

  Widget _buildCriterionableValue() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Criterion Base Name:",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          _selectedCriterionable?.criterionBaseName ?? "-",
          style: TextStyle(fontSize: 13),
        ),
        SizedBox(height: 10),
        IconLabelSelectableText(
          label: "Data Type: ",
          text: _selectedCriterionable == null
              ? "-"
              : "<${_selectedCriterionable!.baseDataTypeName}>",
          labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        Divider(),
        Text(
          "Json Criterion Name:",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          _selectedCriterionable?.jsonCriterionName ?? "-",
          style: TextStyle(fontSize: 13),
        ),
        SizedBox(height: 15),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: widget.onDebugFilterModelPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.all(3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child: Text(
              "Debug Filter Model Viewer",
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    List<TabData> tabs = [];

    tabs.add(
      TabData(
        text: ' Supported Criteria',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.formValueIconData,
          color: Colors.black,
          size: 16,
        ),
        content: _buildLeftRightCriterionable(),
      ),
    );
    tabs.add(
      TabData(
        text: ' Backendable JSON Criteria',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.formValueIconData,
          color: Colors.black,
          size: 16,
        ),
        content: _buildJsonContent(),
      ),
    );
    TabbedViewController _controller = TabbedViewController(tabs);
    TabbedView tabbedView = TabbedView(controller: _controller);

    TabbedViewThemeData themeData = TabThemeUtils.getTabbedViewThemeData();

    TabbedViewTheme tabbedViewTheme = TabbedViewTheme(
      data: themeData,
      child: tabbedView,
    );
    return tabbedViewTheme;
  }

  Widget _buildJsonContent() {
    return JsonView(json: filterCriteria?.jsonCriteria ?? "");
  }
}
