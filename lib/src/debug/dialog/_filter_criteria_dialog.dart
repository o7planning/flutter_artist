import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../filter/__filter_criteria_debug_view.dart';

class FilterCriteriaDialog extends StatefulWidget {
  final FilterModel? filterModel;
  final Scalar? scalar;
  final Block? block;

  const FilterCriteriaDialog.block({
    required Block this.block,
    super.key,
  })  : scalar = null,
        filterModel = null;

  const FilterCriteriaDialog.scalar({
    required Scalar this.scalar,
    super.key,
  })  : block = null,
        filterModel = null;

  const FilterCriteriaDialog.filterModel({
    required FilterModel this.filterModel,
    super.key,
  })  : block = null,
        scalar = null;

  @override
  State<StatefulWidget> createState() {
    return _FilterCriteriaDialogState();
  }

  static Future<void> showFilterCriteriaDialog({
    required BuildContext context,
    required FilterModel filterModel,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterCriteriaDialog.filterModel(
          filterModel: filterModel,
        );
      },
    );
  }

  static Future<void> showBlockFilterCriteriaDialog({
    required BuildContext context,
    required Block block,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterCriteriaDialog.block(
          block: block,
        );
      },
    );
  }

  static Future<void> showScalarFilterCriteriaDialog({
    required BuildContext context,
    required Scalar scalar,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterCriteriaDialog.scalar(
          scalar: scalar,
        );
      },
    );
  }
}

class _FilterCriteriaDialogState extends State<FilterCriteriaDialog> {
  static const double fontSize = 13;

  String _title() {
    if (widget.scalar != null) {
      return "Current FilterCriteria of ${getClassName(widget.scalar!)}";
    } else if (widget.block != null) {
      return "Current FilterCriteria of ${getClassName(widget.block!)}";
    } else if (widget.filterModel != null) {
      return "Current FilterCriteria of ${getClassName(widget.filterModel!)}";
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    FaAlertDialog alert = FaAlertDialog(
      icon: Icon(
        FaIconConstants.filterCriteriaDebugIconData,
        size: 16,
      ),
      titleText: _title(),
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(context),
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    if (width > 620) {
      width = 600;
    } else {
      width = 0.9 * width;
    }
    if (height > 420) {
      height = 320;
    } else {
      height = height - 60;
    }
    //
    Widget child;
    if (widget.block != null) {
      child = FilterCriteriaDebugView.block(block: widget.block!);
    } else if (widget.scalar != null) {
      child = FilterCriteriaDebugView.scalar(scalar: widget.scalar!);
    } else if (widget.filterModel != null) {
      child = FilterCriteriaDebugView.filterModel(
        filterModel: widget.filterModel!,
      );
    } else {
      child = Center(
        child: Text("TODO"),
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}
