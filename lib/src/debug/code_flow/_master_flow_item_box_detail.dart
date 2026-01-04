import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_artist/src/debug/code_flow/_line_flow_item_box.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_line_flow_type.dart';
import '../../core/widgets/_iconed_checkbox.dart';
import '../shelf/widget/_shelf_info_view.dart';
import '_master_flow_func_trace_info_view.dart';
import '_master_flow_method_args_view.dart';
import '_master_flow_method_view.dart';

class MasterFlowItemDetailView extends StatefulWidget {
  final MasterFlowItem masterFlowItem;

  const MasterFlowItemDetailView({
    required this.masterFlowItem,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _MasterFlowItemDetailViewState();
  }
}

class _MasterFlowItemDetailViewState extends State<MasterFlowItemDetailView> {
  bool checkAll = true;
  Map<LineFlowType, bool> lineFlowTypeFilterMap = {};

  @override
  void initState() {
    super.initState();
    //
    for (LineFlowType lineFlowType in LineFlowType.values) {
      lineFlowTypeFilterMap.putIfAbsent(lineFlowType, () {
        return true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilter(),
        Divider(color: Colors.transparent, height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: _buildLineFlowItemList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilter() {
    return Card(
      margin: EdgeInsets.all(0),
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: checkAll,
              onChanged: (bool? value) {
                checkAll = value ?? false;
                lineFlowTypeFilterMap.forEach((k, v) {
                  lineFlowTypeFilterMap[k] = checkAll;
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
            SimpleSmallIconButton(
              iconData: Icons.copy_rounded,
              iconSize: 18,
              onPressed: () async {
                await Clipboard.setData(
                    ClipboardData(text: widget.masterFlowItem.getText()));
                // Optionally, show a SnackBar or other feedback to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied!')),
                );
              },
            ),
          ],
        ),
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
      items: LineFlowType.values
          .map(
            (lineFlowType) => BreadCrumbItem(
              content: Tooltip(
                message: lineFlowType.desc,
                child: IconedCheckbox(
                  icon: Icon(
                    lineFlowType.getIconData(),
                    size: 16,
                    color: lineFlowType.getIconColor(),
                  ),
                  value: lineFlowTypeFilterMap[lineFlowType] ?? true,
                  onChanged: (bool? value) {
                    setState(() {
                      lineFlowTypeFilterMap[lineFlowType] = value ?? false;
                    });
                  },
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMethodCallInfo(MethodCallMasterFlowItem masterFlowItem) {
    final Shelf? shelf = widget.masterFlowItem.getShelf();
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shelf != null && masterFlowItem.isUserMethod)
          ShelfInfoView(shelf: shelf),
        if (shelf != null && masterFlowItem.isUserMethod) const Divider(),
        Card(
          child: CodeFlowMethodView(masterFlowItem: masterFlowItem),
        ),
        if (!masterFlowItem.isLibMethod) const SizedBox(height: 5),
        if (!masterFlowItem.isLibMethod)
          CodeFlowFuncTraceInfoView(
            funcCallInfo: masterFlowItem.funcCallInfo,
          ),
        const SizedBox(height: 10),
        CodeFlowMethodArgsView(
          arguments: masterFlowItem.funcCallInfo.arguments,
        ),
      ],
    );
  }

  Widget _buildLineFlowItemList() {
    final List<LineFlowItem> lineFlowItems = widget.masterFlowItem.lineFlowItems
        .where((item) => (lineFlowTypeFilterMap[item.lineFlowType] ?? false))
        .toList();
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.masterFlowItem is MethodCallMasterFlowItem)
          _buildMethodCallInfo(
            widget.masterFlowItem as MethodCallMasterFlowItem,
          ),
        if (widget.masterFlowItem is MethodCallMasterFlowItem)
          SizedBox(height: 10),
        ...lineFlowItems
            .map(
              (e) => LineFlowItemBox(
                lineFlowItem: e,
              ),
            )
            .expand(
              (w) => [w, SizedBox(height: 5)],
            ),
      ],
    );
  }
}
