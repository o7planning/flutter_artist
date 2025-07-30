import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_fa_core.dart';
import '_block_debug_options.dart';

const double _debugBoxFontSize = 11.5;

abstract class BaseDebugBox extends StatelessWidget {
  final labelStyle0 = const TextStyle(
    color: Colors.indigo,
    fontWeight: FontWeight.bold,
    fontSize: _debugBoxFontSize,
  );

  final textStyle0 = const TextStyle(
    color: Colors.deepOrange,
    fontSize: _debugBoxFontSize,
  );

  final labelStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: _debugBoxFontSize,
  );

  final textStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: _debugBoxFontSize,
  );

  const BaseDebugBox({super.key});

  List<Widget> getChildIconLabelTexts();

  @override
  Widget build(BuildContext context) {
    List<Widget> children = getChildIconLabelTexts();
    return Container(
      padding: EdgeInsets.all(5),
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(width: 0.3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.isEmpty
            ? children
            : children
                .expand(
                  (w) => [
                    w,
                    const SizedBox(height: 5),
                  ],
                )
                .toList(),
      ),
    );
  }
}

class BlockDebugBox extends BaseDebugBox {
  final Block block;
  final BlockDebugOptions options;

  const BlockDebugBox({
    super.key,
    required this.block,
    required this.options,
  });

  @override
  List<IconLabelText> getChildIconLabelTexts() {
    return [
      if (options.showUIActive)
        IconLabelText(
          label: "UI Active?: ",
          text: "${block.hasActiveUIComponent()}",
          labelStyle: labelStyle0,
          textStyle: textStyle0,
        ),
      if (options.showLastQueryType)
        IconLabelText(
          label: "Last Query Type: ",
          text: block.lastQueryType.name.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
      if (options.showQueryDataState)
        IconLabelText(
          label: "Query State: ",
          text: block.queryDataState.name.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showLastQueryResultState)
        IconLabelText(
          label: "Last Query Result: ",
          text: block.lastQueryResultState?.name?.toString() ?? "",
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
          label: "Has Current Item?: ",
          text: (block.currentItem != null).toString(),
          labelStyle: labelStyle,
          textStyle: textStyle0,
        ),
    ];
  }
}
