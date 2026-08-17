import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../../../../core/_core_/core.dart';
import '../../../../core/enums/debug_btn_type.dart';
import '_base_info_widget.dart';

class BlockFilterCriteriaInfoWidget extends BaseInfoWidget {
  final Block block;

  const BlockFilterCriteriaInfoWidget({
    super.key,
    required this.block,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final FilterModel filterModel = block.registeredOrDefaultFilterModel;
    final FilterCriteria? filterModelFilterCriteria =
        filterModel.filterCriteria;
    final FilterCriteria? blockFilterCriteria = block.filterCriteria;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: IconLabelText(
            label: "Filter Criteria: ",
            text: blockFilterCriteria == null ? "null" : "[Not Null]",
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
        ),
        Tooltip(
          message: blockFilterCriteria == null
              ? ""
              : filterModelFilterCriteria == blockFilterCriteria
                  ? "The block is using the latest filtering criteria."
                  : "Warning: The block is using old filtering criteria.",
          child: SimpleSmallIconButton(
            iconData: Icons.view_agenda,
            iconSize: 14,
            iconColor: blockFilterCriteria == null
                ? context.faColors.action.ink.info
                : filterModelFilterCriteria == blockFilterCriteria
                    ? context.faColors.action.ink.success
                    : context.faColors.action.ink.error,
            onPressed: blockFilterCriteria == null
                ? null
                : () {
                    block.showDebugFilterCriteriaViewerDialog();
                  },
          ),
        ),
      ],
    );
  }

  @override
  String? getButtonTooltip() {
    final FilterModel filterModel = block.registeredOrDefaultFilterModel;
    final FilterCriteria? filterModelFilterCriteria =
        filterModel.filterCriteria;
    final FilterCriteria? blockFilterCriteria = block.filterCriteria;
    //
    return blockFilterCriteria == null
        ? ""
        : filterModelFilterCriteria == blockFilterCriteria
            ? "The block is using the latest filtering criteria."
            : "Warning: The block is using old filtering criteria.";
  }

  @override
  ButtonFunction? getButtonFunction() {
    final FilterCriteria? blockFilterCriteria = block.filterCriteria;
    //
    if (blockFilterCriteria == null) {
      return null;
    }
    return ButtonFunction(
      btnType: DebugBtnType.success,
      onPressed: (BuildContext context) {
        block.showDebugFilterCriteriaViewerDialog();
      },
    );
  }

  @override
  String getLabel() {
    return "Filter Criteria: ";
  }

  @override
  String? getLeftTooltip() {
    return null;
  }

  @override
  String getText() {
    final FilterCriteria? blockFilterCriteria = block.filterCriteria;
    //
    return blockFilterCriteria == null ? "null" : "[Not Null]";
  }
}
