import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_left_right_container/left_right_container.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../utils/_tab_theme_utils.dart';
import '../widgets/_html_info_view.dart';
import '../widgets/_json_view.dart';
import 'widgets/_filter_criterion_view.dart';

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

  final fieldBasedJsonTabId = "Field-Based JSON";
  final supportedCriteriaTabId = "Supported Criteria";

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
      style: LeftRightContainerStyle(
        startPadding: EdgeInsets.all(5),
        endPadding: EdgeInsets.all(5),
      ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel("Criterion Base Name:"),
        Text(
          _selectedFilterCriterion?.filterCriterionName ?? "-",
          style: TextStyle(
              fontSize: 13, color: FaColorUtils.primaryAction(context)),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text("Data Type: ",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: FaColorUtils.primaryAction(context))),
            Text(
              _selectedFilterCriterion == null
                  ? "-"
                  : "<${_selectedFilterCriterion!.rawDataTypeName}>",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: FaColorUtils.technicalHighlight(context),
              ),
            ),
          ],
        ),
        const Divider(height: 20),
        _buildSectionLabel("Field Name:"),
        Text(
          _selectedFilterCriterion?.filterFieldName ?? "-",
          style: TextStyle(
              fontSize: 13,
              fontFamily: 'Courier',
              color: FaColorUtils.sourceCode(context)),
        ),
        const Spacer(),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton.icon(
            onPressed: widget.onDebugFilterModelPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            icon: Icon(FaIconConstants.filterModelDebugIconData, size: 16),
            label: const Text(
              "Debug Filter Model Inspector",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    List<TabData> tabs = [];

    tabs.add(
      TabData(
        id: fieldBasedJsonTabId,
        text: ' Field-Based JSON',
        closable: false,
        leading: (context, status) => Icon(
          Icons.data_object,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: 16,
        ),
        view: _buildJsonContent(),
      ),
    );
    tabs.add(
      TabData(
        id: supportedCriteriaTabId,
        text: ' Supported Criteria',
        closable: false,
        leading: (context, status) => Icon(
          Icons.policy_outlined,
          color: TabThemeUtils.getTabIconColor(context, status),
          size: 16,
        ),
        view: _buildLeftRightFilterCriterion(),
      ),
    );

    TabbedViewController _controller = TabbedViewController(tabs);
    TabbedView tabbedView = TabbedView(controller: _controller);

    TabbedViewThemeData themeData =
        TabThemeUtils.getTabbedViewThemeData(context);

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
