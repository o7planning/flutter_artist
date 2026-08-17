import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../../../../core/_core_/core.dart';
import '../../../../core/enums/debug_btn_type.dart';
import '_base_info_widget.dart';

class ScalarFilterCriteriaInfoWidget extends BaseInfoWidget {
  final Scalar scalar;

  const ScalarFilterCriteriaInfoWidget({
    super.key,
    required this.scalar,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final FilterModel filterModel = scalar.registeredOrDefaultFilterModel;
    final FilterCriteria? filterModelFilterCriteria =
        filterModel.filterCriteria;
    final FilterCriteria? scalarFilterCriteria = scalar.filterCriteria;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: IconLabelText(
            label: "Filter Criteria: ",
            text: scalarFilterCriteria == null ? "null" : "[Not Null]",
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
        ),
        Tooltip(
          message: scalarFilterCriteria == null
              ? ""
              : filterModelFilterCriteria == scalarFilterCriteria
                  ? "The scalar is using the latest filtering criteria."
                  : "Warning: The scalar is using old filtering criteria.",
          child: SimpleSmallIconButton(
            iconData: Icons.view_agenda,
            iconSize: 14,
            iconColor: scalarFilterCriteria == null
                ? context.faColors.action.ink.info
                : filterModelFilterCriteria == scalarFilterCriteria
                    ? context.faColors.action.ink.success
                    : context.faColors.action.ink.error,
            onPressed: scalarFilterCriteria == null
                ? null
                : () {
                    scalar.showDebugFilterCriteriaViewerDialog();
                  },
          ),
        ),
      ],
    );
  }

  @override
  String? getButtonTooltip() {
    final FilterModel filterModel = scalar.registeredOrDefaultFilterModel;
    final FilterCriteria? filterModelFilterCriteria =
        filterModel.filterCriteria;
    final FilterCriteria? scalarFilterCriteria = scalar.filterCriteria;
    //
    return scalarFilterCriteria == null
        ? ""
        : filterModelFilterCriteria == scalarFilterCriteria
            ? "The scalar is using the latest filtering criteria."
            : "Warning: The scalar is using old filtering criteria.";
  }

  @override
  ButtonFunction? getButtonFunction() {
    final FilterCriteria? scalarFilterCriteria = scalar.filterCriteria;
    //
    if (scalarFilterCriteria == null) {
      return null;
    }
    return ButtonFunction(
      btnType: DebugBtnType.success,
      onPressed: (BuildContext context) {
        scalar.showDebugFilterCriteriaViewerDialog();
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
    final FilterCriteria? scalarFilterCriteria = scalar.filterCriteria;
    //
    return scalarFilterCriteria == null ? "null" : "[Not Null]";
  }
}
