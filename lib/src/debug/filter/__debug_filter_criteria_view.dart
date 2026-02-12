import 'package:flutter/material.dart';
import 'package:flutter_artist/src/debug/filter/widgets/_filter_criterion_view.dart';
import 'package:flutter_artist/src/debug/widgets/_json_view.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_left_right_container/left_right_container.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
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
  FilterCriterion<Object>? _selectedFilterCriterion;
  FilterCriteria? filterCriteria;

  @override
  void initState() {
    super.initState();
    filterCriteria = widget.filterModel.filterCriteria;
    _selectedFilterCriterion = filterCriteria?.filterCriterionList.firstOrNull;
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
          "<b>$filterModelClassName.createNewFilterCriteria()</b> method, and can be retrieved via the "
          "<b>$filterModelClassName.filterCriteria</b> property. "
          "Note: This property can be <b>null</b> if there is an error in the <b>$filterModelClassName</b>.",
      style: TextStyle(fontSize: 13),
    );
  }

  Widget _buildLeftRightFilterCriterion() {
    return LeftRightContainer(
      startPadding: EdgeInsets.all(5),
      endPadding: EdgeInsets.all(5),
      spacing: 20,
      fixedSizeWidth: 260,
      minSideWidth: 240,
      fixedSide: FixedSide.end,
      start: ListView(
        children: (filterCriteria?.filterCriterionList ?? [])
            .map(
              (c) => FilterCriterionView(
                filterCriterion: c,
                selected: c.filterCriterionName ==
                    _selectedFilterCriterion?.filterCriterionName,
                onPressed: (FilterCriterion<Object> filterCriterion) {
                  setState(() {
                    _selectedFilterCriterion = filterCriterion;
                  });
                },
              ),
            )
            .toList(),
      ),
      end: _buildFilterCriterionValue(),
    );
  }

  Widget _buildFilterCriterionValue() {
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
          _selectedFilterCriterion?.filterCriterionName ?? "-",
          style: TextStyle(fontSize: 13),
        ),
        SizedBox(height: 10),
        IconLabelSelectableText(
          label: "Data Type: ",
          text: _selectedFilterCriterion == null
              ? "-"
              : "<${_selectedFilterCriterion!.rawDataTypeName}>",
          labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        Divider(),
        Text(
          "Field Name:",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          _selectedFilterCriterion?.filterFieldName ?? "-",
          style: TextStyle(fontSize: 13),
        ),
        SizedBox(height: 15),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton.icon(
            onPressed: widget.onDebugFilterModelPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.all(3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            icon: Icon(
              FaIconConstants.filterModelDebugIconData,
              size: 15,
            ),
            label: Text(
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
        text: ' Field-Based JSON',
        closable: false,
        leading: (context, status) => Icon(
          Icons.data_object,
          color: Colors.black,
          size: 16,
        ),
        content: _buildJsonContent(),
      ),
    );
    tabs.add(
      TabData(
        text: ' Supported Criteria',
        closable: false,
        leading: (context, status) => Icon(
          Icons.policy_outlined,
          color: Colors.black,
          size: 16,
        ),
        content: _buildLeftRightFilterCriterion(),
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
    return JsonView(json: filterCriteria?.fieldBasedJSON ?? "");
  }
}
