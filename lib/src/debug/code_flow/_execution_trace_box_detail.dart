import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_trace_step_type.dart';
import '../../core/widgets/_iconed_checkbox.dart';
import '../../core/widgets/_simple_copy_button.dart';
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
  Map<TraceStepType, bool> traceStepTypeFilterMap = {};

  @override
  void initState() {
    super.initState();
    //
    for (TraceStepType traceStepType in TraceStepType.values) {
      traceStepTypeFilterMap.putIfAbsent(traceStepType, () {
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
        SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: _buildTraceStepList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilter() {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: checkAll,
            onChanged: (bool? value) {
              checkAll = value ?? false;
              traceStepTypeFilterMap.forEach((k, v) {
                traceStepTypeFilterMap[k] = checkAll;
              });
              setState(() {});
            },
          ),
          SizedBox(
            height: 16,
            child: VerticalDivider(),
          ),
          Expanded(
            child: _buildBreadCrumb(),
          ),
          SizedBox(
            height: 16,
            child: VerticalDivider(),
          ),
          SimpleCopyButton(
            getText: () {
              return widget.executionTrace.getText();
            },
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
      items: TraceStepType.values
          .map(
            (traceStepType) => BreadCrumbItem(
              content: Tooltip(
                message: traceStepType.desc,
                child: IconedCheckbox(
                  icon: Icon(
                    traceStepType.getIconData(),
                    size: 16,
                    color: traceStepType.getIconColor(context),
                  ),
                  value: traceStepTypeFilterMap[traceStepType] ?? true,
                  onChanged: (bool? value) {
                    setState(() {
                      traceStepTypeFilterMap[traceStepType] = value ?? false;
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
    final theme = Theme.of(context);
    final Shelf? shelf = widget.executionTrace.getShelf();
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shelf != null && executionTrace.isUserMethod)
          ShelfInfoView(shelf: shelf),
        if (shelf != null && executionTrace.isUserMethod) const Divider(),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
          ),
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
        .where((item) => (traceStepTypeFilterMap[item.traceStepType] ?? false))
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
