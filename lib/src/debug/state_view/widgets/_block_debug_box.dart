import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../../../core/_core_/core.dart';
import '../../utils/_debug.dart';
import '../options/_debug_block_options.dart';
import '_active_info_widget.dart';
import '_block_requery_info_widget.dart';
import '_debug_box.dart';
import '_debug_style_utils.dart';
import 'block_data_state_widget.dart';

class BlockDebugBox extends BaseDebugBox {
  final Block block;
  final DebugBlockOptions options;

  const BlockDebugBox({
    super.key,
    required this.block,
    required this.options,
  });

  @override
  List<Widget> getChildIconLabelTexts(BuildContext context) {
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
          labelStyle: DebugStyleUtils.getLabelStyle0(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
          checkAgain: () {
            //
          },
        ),
      if (options.showUiActive)
        ActiveInfoWidget(
          activeElementType: ActiveElementType.item,
          activeUiComponentName: activeUIItemRep,
          xActiveUiComponentName: xActiveUIItemRep,
          labelStyle: DebugStyleUtils.getLabelStyle0(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
          checkAgain: () {
            //
          },
        ),
      if (block.getItemType() == block.getItemDetailType())
        IconLabelText(
          label: "Behavior (*): ",
          text: block.config.itemAbsentRepresentativePolicy.name,
          labelStyle: DebugStyleUtils.getLabelStyle1(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (block.getItemType() == block.getItemDetailType())
        IconLabelText(
          label: "RefreshMode (*): ",
          text: block.config.unifiedItemRefreshPolicy.name,
          labelStyle: DebugStyleUtils.getLabelStyle1(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showLastQueryType)
        IconLabelText(
          label: "Last Query Type: ",
          text: block.lastQueryType.name.toString(),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showBlockDataState)
        BlockDataStateWidget(
          block: block,
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
          checkAgain: () {},
        ),
      if (options.showLastQueryResultState)
        IconLabelText(
          label: "Last Query Result: ",
          text: block.lastQueryResultState?.name.toString() ?? "",
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showPerformQueryCount)
        BlockQueryInfoWidget(
          block: block,
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showPerformLoadItemCount)
        IconLabelText(
          label: "Item Refresh Count: ",
          text: block.debug.performLoadItemDetailByIdCount.toString(),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle(context),
        ),
      if (options.showItemCount)
        IconLabelText(
          label: "Item Count: ",
          text: block.itemCount.toString(),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showCurrentItemChangeCount)
        IconLabelText(
          label: "Current Item Change Count: ",
          text: block.debug.currentItemChangeCount.toString(),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (block.filterModel != null && options.showFilterCriteria)
        IconLabelText(
          label: "Filter Criteria: ",
          text: block.filterCriteria == null ? "null" : "[Not Null]",
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (block.filterModel != null && options.showFilterCriteriaChangeCount)
        IconLabelText(
          label: "Filter Criteria Change Count: ",
          text: block.debug.filterCriteriaChangeCount.toString(),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showHasCurrentItem)
        IconLabelText(
          label: "Current Item: ",
          text: debugObj(block.currentItem),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
      if (options.showHasParentBlockCurrentItem)
        IconLabelText(
          label: "Parent Item: ",
          text: debugObj(block.parent?.currentItem),
          labelStyle: DebugStyleUtils.getLabelStyle(context),
          textStyle: DebugStyleUtils.getTextStyle0(context),
        ),
    ];
  }
}
