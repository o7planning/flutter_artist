import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_master_flow_item_type.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../../core/widgets/_iconed_checkbox.dart';
import '../dialog/_code_flow_settings_dialog.dart';
import '_master_flow_item_box.dart';
import '_master_flow_item_box_detail.dart';

class MasterFlowViewer extends StatefulWidget {
  const MasterFlowViewer({
    super.key,
  });

  @override
  State<MasterFlowViewer> createState() => _MasterFlowViewerState();
}

class _MasterFlowViewerState extends State<MasterFlowViewer> {
  bool checkAll = true;
  MasterFlowItem? selectedMasterFlowItem;

  final Map<MasterFlowItemType, bool> masterFlowItemTypeFilterMap = {};

  @override
  void initState() {
    super.initState();
    //
    for (MasterFlowItemType type in MasterFlowItemType.values) {
      masterFlowItemTypeFilterMap.putIfAbsent(type, () {
        return true;
      });
    }
    // masterFlowItemTypeFilterMap[MasterFlowItemType.libMethodCall] = false;
  }

  @override
  Widget build(BuildContext context) {
    List<MasterFlowItem> items = FlutterArtist.codeFlowLogger.masterFlowItems
        .where((item) =>
            (masterFlowItemTypeFilterMap[item.masterFlowItemType] ?? false))
        .toList();
    //
    if (!items.contains(selectedMasterFlowItem)) {
      selectedMasterFlowItem = items.isNotEmpty ? items.first : null;
    }
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilter(),
        const SizedBox(height: 5),
        Expanded(
          child: selectedMasterFlowItem == null
              ? const CustomAppContainer(
                  child: Center(
                    child: Text("No Item", style: TextStyle(fontSize: 13)),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 280,
                      child: _buildLeftList(items),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: MasterFlowItemDetailView(
                        masterFlowItem: selectedMasterFlowItem!,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildFilter() {
    return CustomAppContainer(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: checkAll,
            onChanged: (bool? value) {
              checkAll = value ?? false;
              masterFlowItemTypeFilterMap.forEach((k, v) {
                masterFlowItemTypeFilterMap[k] = checkAll;
              });
              setState(() {});
            },
          ),
          SizedBox(
            height: 20,
            child: VerticalDivider(),
          ),
          Expanded(
            child: _buildBreadCrumb(),
          ),
          SizedBox(
            height: 20,
            child: VerticalDivider(),
          ),
          Tooltip(
            message: "Settings",
            child: SimpleSmallIconButton(
              iconData: Icons.settings,
              iconSize: 18,
              onPressed: _showCodeFlowSetting,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadCrumb() {
    return BreadCrumb(
      divider: VerticalDivider(width: 10),
      overflow: ScrollableOverflow(
        keepLastDivider: false,
        reverse: false,
        direction: Axis.horizontal,
      ),
      items: MasterFlowItemType.values
          .map(
            (masterFlowItemType) => BreadCrumbItem(
              content: Tooltip(
                message: masterFlowItemType.desc,
                child: IconedCheckbox(
                  icon: Icon(
                    masterFlowItemType.getIconData(),
                    size: 16,
                    color: masterFlowItemType.getIconColor(false),
                  ),
                  value:
                      masterFlowItemTypeFilterMap[masterFlowItemType] ?? true,
                  onChanged: (bool? value) {
                    setState(() {
                      masterFlowItemTypeFilterMap[masterFlowItemType] =
                          value ?? false;
                    });
                  },
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildLeftList(List<MasterFlowItem> items) {
    return ListView(
      padding: const EdgeInsets.only(right: 10),
      children: items
          .map(
            (masterFlowItem) => MasterFlowItemBox(
              key: Key("LogItem-${masterFlowItem.id}"),
              masterFlowItem: masterFlowItem,
              selected: masterFlowItem == selectedMasterFlowItem,
              onTap: () {
                setState(() {
                  selectedMasterFlowItem = masterFlowItem;
                });
              },
            ),
          )
          .toList(),
    );
  }

  void _showCodeFlowSetting() {
    CodeFlowSettingsDialog.showCodeFlowSettingsDialog(context: context);
  }
}
