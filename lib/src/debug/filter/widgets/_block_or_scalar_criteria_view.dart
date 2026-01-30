import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../../core/_core_/core.dart';
import '../../../core/enums/_data_state.dart';
import '../../../core/icon/icon_constants.dart';
import '../../storage/_block_or_scalar.dart';

class BlockOrScalarCriteriaView extends StatelessWidget {
  final BlockOrScalar blockOrScalar;

  const BlockOrScalarCriteriaView({super.key, required this.blockOrScalar});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        minLeadingWidth: 24,
        horizontalTitleGap: 5,
        dense: true,
        visualDensity: const VisualDensity(
          horizontal: -3,
          vertical: -3,
        ),
        leading: Icon(
          blockOrScalar.isBlock
              ? FaIconConstants.blockIconData
              : FaIconConstants.scalarIconData,
          size: 18,
        ),
        title: Text(
          blockOrScalar.blockOrScalarClassName,
          style: TextStyle(fontSize: 13),
        ),
        subtitle: _buildStatusBar(blockOrScalar),
      ),
    );
  }

  Widget _buildStatusBar(BlockOrScalar blockOrScalar) {
    DataState dataState = blockOrScalar.dataState;
    FilterCriteria? filterCriteria = blockOrScalar.filterCriteria;
    //
    final labelStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
    final textStyle = TextStyle(fontSize: 11);
    //
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        child: BreadCrumb(
          divider: SizedBox(width: 10),
          overflow: ScrollableOverflow(
            keepLastDivider: false,
            reverse: false,
            direction: Axis.horizontal,
          ),
          items: [
            BreadCrumbItem(
              content: IconLabelText(
                labelStyle: labelStyle,
                textStyle: textStyle.copyWith(
                  color:
                      dataState == DataState.error ? Colors.red : Colors.black,
                ),
                label: 'Data State: ',
                text: dataState.name,
              ),
            ),
            BreadCrumbItem(
              content: IconLabelText(
                labelStyle: labelStyle,
                textStyle: textStyle.copyWith(
                  color: filterCriteria == null ? Colors.red : Colors.indigo,
                ),
                label: "Filter Criteria: ",
                text: filterCriteria == null ? 'null' : 'not null',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
