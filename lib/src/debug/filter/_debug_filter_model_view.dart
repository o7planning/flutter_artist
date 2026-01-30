import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../filter_criteria/_filter_condition_groups_view.dart';
import '../filter_criteria/_filter_criteria_structure_criteria_base_view.dart';
import '../filter_criteria/_filter_criteria_structure_view.dart';
import '../storage/_block_or_scalar.dart';
import '../utils/_tab_theme_utils.dart';
import '../widgets/_html_info_view.dart';
import '../widgets/_json_view.dart';
import 'widgets/_block_or_scalar_criteria_view.dart';

class DebugFilterModelView extends StatefulWidget {
  final FilterModel filterModel;
  final Function() onPressedShelfStructure;
  final Function() onPressedFilterCriteria;

  const DebugFilterModelView({
    required this.filterModel,
    required this.onPressedShelfStructure,
    required this.onPressedFilterCriteria,
    super.key,
  });

  @override
  State<DebugFilterModelView> createState() => _DebugFilterModelViewState();
}

class _DebugFilterModelViewState extends State<DebugFilterModelView> {
  static const double iconSize = 18;
  static const double fontSize = 13;

  static const int instantValueTab = 2;
  late int selectedTab = instantValueTab;

  late List<ShelfBlockScalarType> listeners;

  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
    listeners = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFilterModelBar(context),
        const SizedBox(height: 5),
        Expanded(
          child: _buildTabContainer(),
        ),
      ],
    );
  }

  Color _getTabIconColor(TabStatus tabStatus) {
    return tabStatus == TabStatus.selected ? Colors.indigo : Colors.black;
  }

  Widget _buildTabContainer() {
    FilterModelStructure filterModelStructure =
        widget.filterModel.filterModelStructure;

    Map<String, dynamic> initial1Value =
        filterModelStructure.debugInitialCriteriaValues;

    Map<String, dynamic> instantValue = filterModelStructure.debugInstantValues;

    Map<String, dynamic> currentValue =
        filterModelStructure.debugCurrentCriteriaValues;

    String initial1Json = MapUtils.toJson(map: initial1Value);
    String currentJson = MapUtils.toJson(map: currentValue);

    final ConditionGroupModelImpl rootFilterCriteriaGroupModel =
        widget.filterModel.filterModelStructure.rootConditionGroupModel;

    String conditionJsonX =
        rootFilterCriteriaGroupModel.toFilterCriteriaGroupXVal().toJson();

    String conditionJsonBase =
        rootFilterCriteriaGroupModel.toFilterCriteriaGroupVal().toJson();

    //

    List<TabData> tabs = [];

    tabs.add(
      TabData(
        text: ' Base',
        closable: false,
        leading: (context, status) => Icon(
          Icons.shopping_bag_outlined,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabFilterModelStructureBase(),
      ),
    );
    tabs.add(
      TabData(
        text: ' ~',
        closable: false,
        leading: (context, status) => Icon(
          Icons.shopping_bag_outlined,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabFilterCriteriaStructure(),
      ),
    );
    tabs.add(
      TabData(
        text: ' Groups',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.conditionGroupIconData,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabFilterModelStructureGroupsView(),
      ),
    );
    tabs.add(
      TabData(
        text: ' Initial',
        closable: false,
        leading: (context, status) => Icon(
          Icons.list,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabContent(
          infoAsHtml: "Initial Filter values",
          json: initial1Json,
        ),
      ),
    );
    tabs.add(
      TabData(
        text: ' Current',
        closable: false,
        leading: (context, status) => Icon(
          Icons.list,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabContent(
          infoAsHtml: "The current values of the filter (Will be passed to the "
              "<b>${getClassName(widget.filterModel)}.createNewFilterCriteria()</b> method).",
          json: currentJson,
        ),
      ),
    );

    tabs.add(
      TabData(
        text: ' JSON~',
        closable: false,
        leading: (context, status) => Icon(
          Icons.data_object,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabContent(
          infoAsHtml: "<b>Filter Condition Structure.</b>.",
          json: conditionJsonX,
        ),
      ),
    );
    tabs.add(
      TabData(
        text: ' JSON',
        closable: false,
        leading: (context, status) => Icon(
          Icons.data_object,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabContent(
          infoAsHtml: "<b>Criterion Structures</b>",
          json: conditionJsonBase,
        ),
      ),
    );
    tabs.add(
      TabData(
        text: ' ',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.usageIconData,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildFormEventListenerInfo(),
      ),
    );
    //
    _controller = TabbedViewController(tabs);
    TabbedView tabbedView = TabbedView(controller: _controller);

    TabbedViewThemeData themeData = TabThemeUtils.getTabbedViewThemeData();

    TabbedViewTheme tabbedViewTheme = TabbedViewTheme(
      data: themeData,
      child: tabbedView,
    );

    //
    return tabbedViewTheme;
  }

  Widget _buildTabFilterModelStructureGroupsView() {
    return FilterConditionGroupsView(
      key: Key("FilterModelStructureGroupsView"),
      filterModel: widget.filterModel,
    );
  }

  Widget _buildTabFilterModelStructureBase() {
    return FilterModelStructureCriteriaBaseView(
      key: Key("FilterModelStructureCriteriaBaseView"),
      filterModel: widget.filterModel,
    );
  }

  Widget _buildTabFilterCriteriaStructure() {
    return FilterCriteriaStructureView(
      key: Key("FilterCriteriaStructureView"),
      filterModel: widget.filterModel,
    );
  }

  Widget _buildTabContent({
    required String infoAsHtml,
    required String json,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HtmlInfoView(
            infoAsHtml: infoAsHtml,
            style: TextStyle(fontSize: 13),
          ),
          const Divider(height: 10),
          Expanded(
            child: JsonView(json: json),
          ),
        ],
      ),
    );
  }

  Widget _buildFormEventListenerInfo() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HtmlInfoView(
              infoAsHtml:
                  "List and status of <b>Block(s)</b> and <b>Scalar(s)</b> using this filter:",
              style: TextStyle(fontSize: 13),
            ),
            const Divider(height: 10),
            ...widget.filterModel.blocks
                .map((block) => BlockOrScalarCriteriaView(
                      blockOrScalar: BlockOrScalar.block(block),
                    )),
            ...widget.filterModel.scalars
                .map((scalar) => BlockOrScalarCriteriaView(
                      blockOrScalar: BlockOrScalar.scalar(scalar),
                    )),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterModelBar(BuildContext context) {
    return CustomAppContainer(
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BreadCrumb(
              divider: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
              overflow: ScrollableOverflow(
                keepLastDivider: false,
                reverse: false,
                direction: Axis.horizontal,
              ),
              items: [
                BreadCrumbItem(
                  content: InkWell(
                    onTap: widget.onPressedShelfStructure,
                    child: IconLabelText(
                      style: const TextStyle(fontSize: fontSize),
                      icon: Image.asset(
                        "packages/flutter_artist/static-rs/shelf.png",
                        width: 24,
                        height: 20,
                      ),
                      label: '',
                      text: getClassName(widget.filterModel.shelf),
                    ),
                  ),
                ),
                BreadCrumbItem(
                  content: IconLabelText(
                    style: const TextStyle(fontSize: fontSize),
                    icon: const Icon(
                      FaIconConstants.filterModelIconData,
                      size: iconSize,
                    ),
                    label: '',
                    text: getClassName(widget.filterModel),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Tooltip(
            message: "Debug Filter Criteria Viewer",
            child: SimpleSmallIconButton(
              iconData: FaIconConstants.filterCriteriaIconData,
              iconSize: 18,
              onPressed: widget.onPressedFilterCriteria,
            ),
          ),
        ],
      ),
    );
  }
}
