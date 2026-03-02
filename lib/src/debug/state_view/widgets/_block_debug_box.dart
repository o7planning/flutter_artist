import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../../utils/_debug.dart';
import '../options/_debug_block_options.dart';
import '_active_info_widget.dart';
import '_debug_box.dart';

class BlockDebugBox extends BaseDebugBox {
  final Block block;
  final DebugBlockOptions options;

  const BlockDebugBox({
    super.key,
    required this.block,
    required this.options,
  });

  @override
  List<Widget> getChildIconLabelTexts() {
    String? activeUIBlockRep = block.ui.findActiveUiComponentByBlockContext();
    String? xActiveUIIBlockRep = block.ui.findActiveUiComponentByBlockContext(
      alsoCheckChildren: true,
    );
    //

    String? activeUIItemRep = block.ui.findActiveUiComponentByItemContext();
    String? xActiveUIItemRep = block.ui.findActiveUiComponentByItemContext(
      alsoCheckChildren: true,
    );
    return [
      if (options.showUiActive)
        ActiveInfoWidget(
          activeElementType: ActiveElementType.block,
          activeUiComponentName: activeUIBlockRep,
          xActiveUiComponentName: xActiveUIIBlockRep,
          labelStyle: labelStyle0,
          textStyle: textStyle0,
          checkAgain: () {
            //
          },
        ),
      if (options.showUiActive)
        ActiveInfoWidget(
          activeElementType: ActiveElementType.item,
          activeUiComponentName: activeUIItemRep,
          xActiveUiComponentName: xActiveUIItemRep,
          labelStyle: labelStyle0,
          textStyle: textStyle0,
          checkAgain: () {
            //
          },
        ),
      if (block.getItemType() == block.getItemDetailType())
        IconLabelText(
          label: "Behavior (*): ",
          text: block.config.itemAbsentRepresentativePolicy.name,
          labelStyle: labelStyle1,
          textStyle: textStyle0,
        ),
      if (block.getItemType() == block.getItemDetailType())
        IconLabelText(
          label: "RefreshMode (*): ",
          text: block.config.unifiedItemRefreshPolicy.name,
          labelStyle: labelStyle1,
          textStyle: textStyle0,
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
      if (options.showPerformQueryCount)
        IconLabelText(
          label: "Query Count: ",
          text: block.performQueryCount.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showPerformLoadItemCount)
        IconLabelText(
          label: "Item Refresh Count: ",
          text: block.performLoadItemDetailByIdCount.toString(),
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
