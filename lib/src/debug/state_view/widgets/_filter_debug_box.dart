import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../options/_debug_filter_options.dart';
import '_debug_box.dart';

class FilterDebugBox extends BaseDebugBox {
  final FilterModel filterModel;
  final DebugFilterOptions options;

  const FilterDebugBox({
    super.key,
    required this.filterModel,
    required this.options,
  });

  @override
  List<Widget> getChildIconLabelTexts() {
    FilterModelStructure structure = filterModel.filterModelStructure;
    // List<MultiOptFilterCriterionModel> optCriteria =
    //     structure.allMultiOptCriterionModels;
    List<MultiOptFilterCriterionModel> optCriteria = [];
    //
    List<Widget> list1 = [
      if (options.showFilterUIActive)
        IconLabelText(
          label: "Filter UI Active?: ",
          text: "${filterModel.ui.hasActiveUIComponent()}",
          labelStyle: labelStyle0,
          textStyle: textStyle0,
        ),
      if (options.showInitiatedAtLeastOnce)
        IconLabelText(
          label: "Initiated At Least Once?: ",
          text: "${filterModel.initiatedAtLeastOnce}",
          labelStyle: labelStyle0,
          textStyle: textStyle0,
        ),
      // if (options.showFilterEnable)
      //   IconLabelText(
      //     label: "Filter Enable?: ",
      //     text: "${filterModel.isEnabled()}",
      //     labelStyle: labelStyle0,
      //     textStyle: textStyle0,
      //   ),
      if (options.showFilterDataState)
        IconLabelText(
          label: "Filter State: ",
          text: filterModel.dataState.name.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      // if (options.showFilterMode)
      //   IconLabelText(
      //     label: "Filter Mode: ",
      //     text: filterModel.filterMode.name.toString(),
      //     labelStyle: labelStyle,
      //     textStyle: textStyle,
      //   ),
      if (options.showFilterLoadCount)
        IconLabelText(
          label: "Filter Load Count: ",
          text: filterModel.loadCount.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showFilterActivityCount)
        IconLabelText(
          label: "Filter Activity Count: ",
          text: filterModel.filterActivityCount.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      // if (options.showFilterDirty)
      //   IconLabelText(
      //     label: "Filter Dirty: ",
      //     text: filterModel.isDirty().toString(),
      //     labelStyle: labelStyle0,
      //     textStyle: textStyle0,
      //   ),
    ];

    List<Widget> list2 = [
      if (options.showFilterCriteria && optCriteria.isNotEmpty)
        ...optCriteria.map(
          (optCriterion) => IconLabelText(
            label: "Load Count (${optCriterion.criterionNamePlus}): ",
            text: optCriterion.loadCount.toString(),
            labelStyle: labelStyle0,
            textStyle: textStyle0,
          ),
        ),
    ];
    return [
      ...list1,
      if (options.showFilterCriteria &&
          optCriteria.isNotEmpty &&
          list1.isNotEmpty)
        Divider(),
      if (options.showFilterCriteria && optCriteria.isNotEmpty) ...list2,
    ];
  }
}
