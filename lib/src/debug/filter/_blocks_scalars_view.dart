import 'package:flutter/material.dart';

import '../../core/_fa_core.dart';
import '../../core/enums/_data_state.dart';
import '../../core/icon/icon_constants.dart';
import '../constants/_debug_constants.dart';

class BlocksScalarsView extends StatelessWidget {
  final FilterModel filterModel;

  const BlocksScalarsView({
    super.key,
    required this.filterModel,
  });

  Widget _buildItem({
    required IconData iconData,
    required String blockOrScalarClassName,
    required DataState dataState,
  }) {
    return Card(
      child: ListTile(
        minLeadingWidth: 0,
        dense: true,
        visualDensity: VisualDensity(vertical: -3, horizontal: -3),
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          iconData,
          size: 16,
        ),
        title: Text(
          blockOrScalarClassName,
          style: TextStyle(fontSize: DebugConstants.debugFontSize),
        ),
        trailing: Tooltip(
          message: "Data State: ${dataState.name}",
          child: Icon(
            dataState.iconData,
            color: dataState.color,
            size: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...filterModel.blocks.map(
          (block) => _buildItem(
            iconData: FaIconConstants.blockIconData,
            blockOrScalarClassName: getClassName(block),
            dataState: block.queryDataState,
          ),
        ),
        ...filterModel.scalars.map(
          (scalar) => _buildItem(
            iconData: FaIconConstants.scalarIconData,
            blockOrScalarClassName: getClassName(scalar),
            dataState: scalar.queryDataState,
          ),
        ),
      ],
    );
  }
}
