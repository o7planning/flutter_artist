import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_trace_step_type.dart';
import '../../core/widgets/_iconed_checkbox.dart';
import '../shelf/widget/_shelf_info_view.dart';
import '_code_flow_func_trace_info_view.dart';
import '_code_flow_method_args_view.dart';
import '_code_flow_method_view.dart';
import '_trace_step_box.dart';

class ExecutionTraceDetailView extends StatefulWidget {
  final ExecutionTrace executionTrace;

  const ExecutionTraceDetailView({
    required this.executionTrace,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _ExecutionTraceDetailViewState();
  }
}

class _ExecutionTraceDetailViewState extends State<ExecutionTraceDetailView> {
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
            child: _buildTraceStepList(),
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
                    ClipboardData(text: widget.executionTrace.getText()));
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

  Widget _buildMethodCallInfo(MethodCallExecutionTrace executionTrace) {
    final Shelf? shelf = widget.executionTrace.getShelf();
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shelf != null && executionTrace.isUserMethod)
          ShelfInfoView(shelf: shelf),
        if (shelf != null && executionTrace.isUserMethod) const Divider(),
        Card(
          child: CodeFlowMethodView(executionTrace: executionTrace),
        ),
        if (!executionTrace.isLibMethod) const SizedBox(height: 5),
        if (!executionTrace.isLibMethod)
          CodeFlowFuncTraceInfoView(
            funcCallInfo: executionTrace.funcCallInfo,
          ),
        const SizedBox(height: 10),
        CodeFlowMethodArgsView(
          arguments: executionTrace.funcCallInfo.arguments,
        ),
      ],
    );
  }

  Widget _buildTraceStepList() {
    final List<TraceStep> traceSteps = widget.executionTrace.traceSteps
        .where((item) => (lineFlowTypeFilterMap[item.lineFlowType] ?? false))
        .toList();
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.executionTrace is MethodCallExecutionTrace)
          _buildMethodCallInfo(
            widget.executionTrace as MethodCallExecutionTrace,
          ),
        if (widget.executionTrace is MethodCallExecutionTrace)
          SizedBox(height: 10),
        ...traceSteps
            .map(
              (e) => TraceStepBox(
                traceStep: e,
              ),
            )
            .expand(
              (w) => [w, SizedBox(height: 5)],
            ),
      ],
    );
  }
}
