import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../utils/_debug.dart';
import '_active_info_widget.dart';
import '_block_debug_options.dart';
import '_debug_box.dart';

class BlockDebugBox extends BaseDebugBox {
  final Block block;
  final BlockDebugOptions options;

  const BlockDebugBox({
    super.key,
    required this.block,
    required this.options,
  });

  @override
  List<Widget> getChildIconLabelTexts() {
    String? activeUIBlockRep =
        block.ui.findActiveUIComponentBlockRepresentative();
    String? xActiveUIIBlockRep =
        block.ui.findActiveUIComponentBlockRepresentative(
      alsoCheckChildren: true,
    );
    //

    String? activeUIItemRep =
        block.ui.findActiveUIComponentItemRepresentative();
    String? xActiveUIItemRep = block.ui.findActiveUIComponentItemRepresentative(
      alsoCheckChildren: true,
    );
    return [
      if (options.showUIActive)
        ActiveInfoWidget(
          activeElementType: ActiveElementType.block,
          activeUIComponentName: activeUIBlockRep,
          xActiveUIComponentName: xActiveUIIBlockRep,
          labelStyle: labelStyle0,
          textStyle: textStyle0,
          checkAgain: () {
            //
          },
        ),
      if (options.showUIActive)
        ActiveInfoWidget(
          activeElementType: ActiveElementType.item,
          activeUIComponentName: activeUIItemRep,
          xActiveUIComponentName: xActiveUIItemRep,
          labelStyle: labelStyle0,
          textStyle: textStyle0,
          checkAgain: () {
            //
          },
        ),
      if (options.showLastQueryType)
        IconLabelText(
          label: "Last Query Type: ",
          text: block.lastQueryType.name.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
      if (options.showBlockDataState)
        IconLabelText(
          label: "Data State: ",
          text: block.dataState.name.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showLastQueryResultState)
        IconLabelText(
          label: "Last Query Result: ",
          text: block.lastQueryResultState?.name.toString() ?? "",
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
      if (options.showCallApiQueryCount)
        IconLabelText(
          label: "Query Count: ",
          text: block.callApiQueryCount.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showCallApiRefreshItemCount)
        IconLabelText(
          label: "Item Refresh Count: ",
          text: block.callApiLoadItemDetailByIdCount.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showItemCount)
        IconLabelText(
          label: "Item Count: ",
          text: block.itemCount.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
      if (options.showCurrentItemChangeCount)
        IconLabelText(
          label: "Current Item Change Count: ",
          text: block.currentItemChangeCount.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
      if (block.filterModel != null && options.showFilterCriteria)
        IconLabelText(
          label: "Filter Criteria: ",
          text: block.filterCriteria == null ? "null" : "[Not Null]",
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
      if (block.filterModel != null && options.showFilterCriteriaChangeCount)
        IconLabelText(
          label: "Filter Criteria Change Count: ",
          text: block.filterCriteriaChangeCount.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
      if (options.showHasCurrentItem)
        IconLabelText(
          label: "Current Item: ",
          text: debugObj(block.currentItem),
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
    ];
  }
}
