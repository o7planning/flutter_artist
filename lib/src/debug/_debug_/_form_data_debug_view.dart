import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../core/_fa_core.dart';
import '../../core/_ui_/_shelf_block_scalar_type_widget.dart';
import '../../icon/icon_constants.dart';
import '../../widgets/_custom_app_container.dart';
import '../_tab_theme_utils.dart';
import '_block_or_scalar.dart';
import '_form_props_/_form_props_structure_view.dart';
import '_widget_/_info_view.dart';
import '_widget_/_json_view.dart';

class FormDataView extends StatefulWidget {
  final FormModel formModel;
  final String locationInfo;
  final Function() onPressedShelf;

  const FormDataView({
    required this.formModel,
    required this.locationInfo,
    required this.onPressedShelf,
    super.key,
  });

  @override
  State<FormDataView> createState() => _FormDataViewState();
}

class _FormDataViewState extends State<FormDataView> {
  static const double iconSize = 18;
  static const double fontSize = 13;

  static const int instantValueTab = 2;
  late int selectedTab = instantValueTab;

  late List<ShelfBlockScalarType> listeners;

  late TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
    //
    listeners = FlutterArtist.storage.getListenerShelfBlockScalarTypes(
      eventBlockOrScalar: BlockOrScalar.block(widget.formModel.block),
      external: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFormModelInfo(context),
        const SizedBox(height: 5),
        Expanded(
          child: _buildTabContainer(),
        ),
      ],
    );
  }

  String toJson(Map<String, dynamic> map) {
    String json;
    try {
      json = jsonEncode(
        map,
        toEncodable: (obj) => obj.toString(),
      );
      Map<String, dynamic> m2 = jsonDecode(json);
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String s = encoder.convert(m2);
      return s;
    } catch (e) {
      return "Error convert to JSON: $e";
    }
  }

  Color _getTabIconColor(TabStatus tabStatus) {
    return tabStatus == TabStatus.selected ? Colors.indigo : Colors.black;
  }

  Widget _buildTabContainer() {
    FormPropsStructure formPropsStructure = widget.formModel.formPropsStructure;
    //
    Map<String, dynamic> initial1Value = formPropsStructure.initialFormData;
    Map<String, dynamic> instantValue = formPropsStructure.currentFormData;

    //
    String initial1Json = toJson(initial1Value);
    String instantJson = toJson(instantValue);
    //

    List<TabData> tabs = [];

    tabs.add(
      TabData(
        text: ' Form Props Structure',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.formValueIconData,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabFormPropsStructure(),
      ),
    );
    tabs.add(
      TabData(
        text: ' Initial',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.formValueIconData,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabContent(
          info: "Initial Form values",
          json: initial1Json,
        ),
      ),
    );
    tabs.add(
      TabData(
        text: ' Current',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.formValueIconData,
          color: _getTabIconColor(status),
          size: iconSize,
        ),
        content: _buildTabContent(
          info: "The current values of the form (Will be passed to the "
              "${getClassName(widget.formModel)}.callApiCreateItem() "
              "or ${getClassName(widget.formModel)}.callApiUpdateItem() method).",
          json: instantJson,
        ),
      ),
    );

    tabs.add(
      TabData(
        text: ' ',
        closable: false,
        leading: (context, status) => Icon(
          FaIconConstants.effectIconData,
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

  Widget _buildTabFormPropsStructure() {
    return FormPropsStructureView(
      key: Key("FormPropsStructureTreeView"),
      formModel: widget.formModel,
    );
  }

  Widget _buildTabContent({
    required String info,
    required String json,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InfoView(info: info),
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
            InfoView(
                info:
                    "When you successfully add or modify a record on the '${getClassName(widget.formModel.block)}' block, "
                    "the listening blocks will be switched to the 'pending' state, "
                    "they will be lazily queried again when they are visible on the screen.\n"
                    "Here is a list of affected blocks or scalars:"),
            const Divider(height: 10),
            ...listeners.map(
              (listener) => ShelfBlockScalarTypeWidget(
                shelfBlockScalarType: listener,
                isListener: true,
                isEventSource: false,
                onTap: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormModelInfo(BuildContext context) {
    return CustomAppContainer(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreadCrumb(
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
                  onTap: widget.onPressedShelf,
                  child: IconLabelText(
                    style: const TextStyle(fontSize: fontSize),
                    icon: Image.asset(
                      "packages/flutter_artist/static-rs/shelf.png",
                      width: 24,
                      height: 20,
                    ),
                    label: '',
                    text: getClassName(widget.formModel.block.shelf),
                  ),
                ),
              ),
              BreadCrumbItem(
                content: IconLabelText(
                  style: const TextStyle(fontSize: fontSize),
                  icon: const Icon(
                    FaIconConstants.blockIconData,
                    size: iconSize,
                  ),
                  label: '',
                  text: getClassName(widget.formModel.block),
                ),
              ),
              BreadCrumbItem(
                content: IconLabelText(
                  style: const TextStyle(fontSize: fontSize),
                  icon: const Icon(
                    FaIconConstants.formModelIconData,
                    size: iconSize,
                  ),
                  label: '',
                  text: getClassName(widget.formModel),
                ),
              ),
            ],
          ),
          const Divider(),
          IconLabelText(
            style: const TextStyle(fontSize: fontSize),
            icon: const Icon(
              FaIconConstants.locationIconData,
              size: iconSize,
              color: Colors.black54,
            ),
            label: "Location: ",
            text: widget.locationInfo,
            suffixIcon: SimpleSmallIconButton(
              iconData: FaIconConstants.copyToClipboardIconData,
              iconSize: 14,
              iconColor: Colors.black54,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: widget.locationInfo));
                var snackBar = const SnackBar(content: Text("Copied!"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
        ],
      ),
    );
  }
}
