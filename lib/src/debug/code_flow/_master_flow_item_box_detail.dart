import 'package:flutter/material.dart';
import 'package:flutter_artist/src/debug/code_flow/_line_flow_item_box.dart';

import '../../core/_core_/core.dart';
import '../storage/widgets/_shelf_info_view.dart';
import '_master_flow_func_trace_info_view.dart';
import '_master_flow_method_args_view.dart';
import '_master_flow_method_view.dart';

class MasterFlowItemDetailView extends StatelessWidget {
  final MasterFlowItem masterFlowItem;

  const MasterFlowItemDetailView({
    required this.masterFlowItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Shelf? shelf = masterFlowItem.getShelf();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (masterFlowItem.isMethodCall()) _buildMethodCallInfo(),
        if (masterFlowItem.isMethodCall()) SizedBox(height: 10),
        _buildLineFlowItemList(),
      ],
    );
  }

  Widget _buildMethodCallInfo() {
    final Shelf? shelf = masterFlowItem.getShelf();
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shelf != null) ShelfInfoView(shelf: shelf),
        if (shelf != null) const Divider(),
        Card(
          child: CodeFlowMethodView(masterFlowItem: masterFlowItem),
        ),
        if (masterFlowItem.funcCallInfo != null) const SizedBox(height: 5),
        if (masterFlowItem.funcCallInfo != null)
          CodeFlowFuncTraceInfoView(
            funcCallInfo: masterFlowItem.funcCallInfo!,
          ),
        const SizedBox(height: 10),
        CodeFlowMethodArgsView(
          arguments: masterFlowItem.funcCallInfo?.arguments,
        ),
        const SizedBox(height: 10),
        _buildLineFlowItemList(),
      ],
    );
  }

  Widget _buildLineFlowItemList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: masterFlowItem.lineFlowItems
          .map(
            (e) => LineFlowItemBox(
              lineFlowItem: e,
            ),
          )
          .expand(
            (w) => [w, SizedBox(height: 5)],
          )
          .toList(),
    );
  }
}
