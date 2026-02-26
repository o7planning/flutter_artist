import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_execution_trace_type.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../../core/widgets/_iconed_checkbox.dart';
import '../dialog/_code_flow_settings_dialog.dart';
import '_execution_trace_box.dart';
import '_execution_trace_box_detail.dart';

class MasterFlowViewer extends StatefulWidget {
  const MasterFlowViewer({
    super.key,
  });

  @override
  State<MasterFlowViewer> createState() => _MasterFlowViewerState();
}

class _MasterFlowViewerState extends State<MasterFlowViewer> {
  bool checkAll = true;
  ExecutionTrace? selectedExecutionTrace;

  final Map<ExecutionTraceType, bool> executionTraceTypeFilterMap = {};

  @override
  void initState() {
    super.initState();
    //
    for (ExecutionTraceType type in ExecutionTraceType.values) {
      executionTraceTypeFilterMap.putIfAbsent(type, () {
        return true;
      });
    }
    // executionTraceTypeFilterMap[ExecutionTraceType.libMethodCall] = false;
  }

  @override
  Widget build(BuildContext context) {
    List<ExecutionTrace> items = FlutterArtist.codeFlowLogger.executionTraces
        .where((item) =>
            (executionTraceTypeFilterMap[item.executionTraceType] ?? false))
        .toList();
    //
    if (!items.contains(selectedExecutionTrace)) {
      selectedExecutionTrace = items.isNotEmpty ? items.first : null;
    }
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilter(),
        const SizedBox(height: 5),
        Expanded(
          child: selectedExecutionTrace == null
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
                      child: ExecutionTraceDetailView(
                        executionTrace: selectedExecutionTrace!,
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
              executionTraceTypeFilterMap.forEach((k, v) {
                executionTraceTypeFilterMap[k] = checkAll;
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
      items: ExecutionTraceType.values
          .map(
            (executionTraceType) => BreadCrumbItem(
              content: Tooltip(
                message: executionTraceType.desc,
                child: IconedCheckbox(
                  icon: Icon(
                    executionTraceType.getIconData(),
                    size: 16,
                    color: executionTraceType.getIconColor(false),
                  ),
                  value:
                      executionTraceTypeFilterMap[executionTraceType] ?? true,
                  onChanged: (bool? value) {
                    setState(() {
                      executionTraceTypeFilterMap[executionTraceType] =
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

  Widget _buildLeftList(List<ExecutionTrace> items) {
    return ListView(
      padding: const EdgeInsets.only(right: 10),
      children: items
          .map(
            (executionTrace) => ExecutionTraceBox(
              key: Key("LogItem-${executionTrace.id}"),
              executionTrace: executionTrace,
              selected: executionTrace == selectedExecutionTrace,
              onTap: () {
                setState(() {
                  selectedExecutionTrace = executionTrace;
                });
              },
            ),
          )
          .toList(),
    );
  }

  void _showCodeFlowSetting() {
    CodeFlowSettingsDialog.open(context: context);
  }
}
