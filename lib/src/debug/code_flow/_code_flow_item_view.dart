import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_labeled_radio.dart';
import '../storage/widgets/_shelf_info_view.dart';
import '_code_flow_func_trace_info_view.dart';
import '_code_flow_info_error_view.dart';
import '_code_flow_method_args_view.dart';
import '_code_flow_method_view.dart';

class CodeFlowItemView extends StatelessWidget {
  final CodeFlowItem codeFlowItem;

  const CodeFlowItemView({
    required this.codeFlowItem,
    required super.key,
  });

  @override
  Widget build(BuildContext context) {
    Shelf? shelf = codeFlowItem.getShelf();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            LabeledRadio<bool>(
              label: "Dev Code",
              value: true,
              groupValue: codeFlowItem.isDevCode,
              onChanged: null,
            ),
            LabeledRadio<bool>(
              label: "Lib Code",
              value: true,
              groupValue: codeFlowItem.isLibCode,
              onChanged: null,
            ),
          ],
        ),
        const Divider(),
        if (codeFlowItem.isMethodCall() && shelf != null)
          ShelfInfoView(shelf: shelf),
        if (codeFlowItem.isMethodCall() && shelf != null) const Divider(),
        if (codeFlowItem.isMethodCall())
          Card(
            child: CodeFlowMethodView(
              codeFlowItem: codeFlowItem,
              textSelectable: true,
              selected: false,
              onTap: null,
            ),
          ),
        if (codeFlowItem.isMethodCallWithTrace()) const SizedBox(height: 5),
        if (codeFlowItem.isMethodCallWithTrace())
          CodeFlowFuncTraceInfoView(
            funcCallInfo: codeFlowItem.funcCallInfo!,
          ),
        if (codeFlowItem.isMethodCall()) const SizedBox(height: 10),
        if (codeFlowItem.isMethodCall())
          CodeFlowMethodArgsView(
            arguments: codeFlowItem.funcCallInfo?.arguments,
          ),
        if (codeFlowItem.isInfo() || codeFlowItem.isError())
          CodeFlowInfoErrorView(
            codeFlowItem: codeFlowItem,
            textOverflow: TextOverflow.visible,
            selected: false,
            onTap: null,
          )
      ],
    );
  }
}
