import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/utils/_class_utils.dart';
import '../state_view/_debug_block_state_view.dart';
import '../state_view/options/_debug_block_options.dart';
import '../state_view/options/_debug_form_options.dart';
import '../state_view/options/_debug_pagination_options.dart';
import '../widgets/_html_info_view.dart';

class DebugBlockCriteriaView extends StatelessWidget {
  final Block block;

  const DebugBlockCriteriaView({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    FilterModel filterModel = block.registeredOrDefaultFilterModel;
    String blockClassName = getClassNameWithoutGenerics(block);
    String filterClassName = getClassNameWithoutGenerics(filterModel);
    //
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCriteriaShortDocument(
            filterClassName: filterClassName,
            blockClassName: blockClassName,
          ),
          SizedBox(height: 10),
          IconLabelSelectableText(
            icon: Icon(
              Icons.arrow_circle_right_outlined,
              size: 14,
            ),
            label: "$blockClassName.filterCriteria: ",
            text: block.filterCriteria == null ? "null" : "not null",
            labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            textStyle: TextStyle(
              fontSize: 13,
              color: block.filterCriteria == null ? Colors.red : Colors.indigo,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: DebugBlockStateView(
                block: block,
                vertical: false,
                debugBlockOptions: DebugBlockOptions(),
                debugFormOptions: DebugFormOptions(),
                debugPaginationOptions: DebugPaginationOptions(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaShortDocument({
    required String filterClassName,
    required String blockClassName,
  }) {
    return HtmlInfoView(
      infoAsHtml:
          "The <b>$filterClassName.filterCriteria</b> is used as a parameter to query the <b>$blockClassName</b>. "
          "If successful, it will be assigned to <b>$blockClassName.filterCriteria</b>. "
          "Otherwise, the <b>$blockClassName.filterCriteria</b> can be set to <b>null</b>, "
          "except in the case of <b>queryNextPage()</b>, <b>queryPreviousPage()</b> or <b>queryMore()</b>. "
          "The <b>$blockClassName.filterCriteria</b> can also be <b>null</b> "
          "if the <b>$blockClassName</b> is in the <b>'none'</b> or <b>'pending'</b> state.",
      style: TextStyle(fontSize: 13),
    );
  }
}
