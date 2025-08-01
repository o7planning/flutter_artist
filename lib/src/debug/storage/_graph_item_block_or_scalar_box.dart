import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_data_state.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../../core/utils/_text_size_utils.dart';
import '../../core/utils/_tooltip_utils.dart';
import '../constants/_debug_constants.dart';
import '_block_or_scalar.dart';

class GraphItemBlockOrScalarBox extends StatefulWidget {
  final BlockOrScalar blockOrScalar;
  final String? highlighFilterModelName;

  final bool showClassParameters;

  final Function(String? filterName) refreshGraph;

  const GraphItemBlockOrScalarBox({
    required super.key,
    required this.blockOrScalar,
    required this.refreshGraph,
    required this.highlighFilterModelName,
    required this.showClassParameters,
  });

  @override
  State<GraphItemBlockOrScalarBox> createState() =>
      GraphItemBlockOrScalarBoxState();
}

class GraphItemBlockOrScalarBoxState extends State<GraphItemBlockOrScalarBox> {
  int filterColorIdx = 0;

  static const double minBoxWidth = 220;
  static const double extraWidth = 30;
  static const double lastLineBlockSpacing = 40;
  static const double spacing = 5;
  static const double padding = 5;

  static const double iconSize = 16;

  @override
  Widget build(BuildContext context) {
    bool hasActiveWidget = widget.blockOrScalar.hasActiveUIComponent();
    //
    double boxWidth = _calculateBoxWidth();

    return SizedBox(
      width: boxWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: hasActiveWidget //
                  ? DebugConstants.activeGraphBoxBgColor
                  : DebugConstants.inactiveGraphBoxBgColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                DebugConstants.graphBoxShadow,
              ],
            ),
            child: _buildMainContent(),
          ),
          if (hasActiveWidget)
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                icon: const Icon(FaIconConstants.infoIconData, size: 16),
                onPressed: _showBlockUiComponentDialog,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBlockOrScalarShortInfo(),
        if (widget.showClassParameters) Divider(height: 8),
        if (widget.showClassParameters) _buildBlockOrScalarParams(),
        const SizedBox(height: 5),
        _buildFilterInfo(),
        const SizedBox(height: 2),
        _buildFilterColor(),
        const SizedBox(height: 3),
        _buildDataStateRow(),
      ],
    );
  }

  String _line3ClassParamsDefinition() {
    return widget.blockOrScalar.blockOrScalarClassParametersDefinition;
  }

  Widget _buildBlockOrScalarParams() {
    return Text(
      _line3ClassParamsDefinition(),
      style: _getBlockClassParameterTextStyle(),
    );
  }

  Widget _buildBlockOrScalarShortInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          widget.blockOrScalar.isBlock
              ? "packages/flutter_artist/static-rs/block.png"
              : "packages/flutter_artist/static-rs/scalar.png",
          width: DebugConstants.graphBoxImageWidth,
          height: DebugConstants.graphBoxImageHeight,
        ),
        const SizedBox(width: spacing),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconLabelText(
                  style: _getBlockNameTextStyle(),
                  label: 'Name: ',
                  text: _getBlockOrScalarNameText(),
                ),
                TooltipUtils.buildTooltip(
                  message:
                      "${widget.blockOrScalar.isBlock ? 'BLOCK' : 'SCALAR'}: ${widget.blockOrScalar.blockOrScalarClassName}\n"
                      "${widget.blockOrScalar.blockOrScalarClassParametersDefinition}",
                  child: IconLabelText(
                    style: _getBlockNameTextStyle(),
                    label: 'Class: ',
                    text: _getBlockOrScalarClassNameText(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _calculateBoxWidth() {
    double blkLine1 = extraWidth +
        DebugConstants.graphBoxImageWidth +
        spacing +
        2 * padding +
        TextSizeUtils.calculateTextSize(
          text: "Name: ${_getBlockOrScalarNameText()}",
          style: _getBlockNameTextStyle(),
        ).width;
    //
    double blkLine2 = extraWidth +
        DebugConstants.graphBoxImageWidth +
        spacing +
        2 * padding +
        TextSizeUtils.calculateTextSize(
          text: "Class: ${_getBlockOrScalarClassNameText()}",
          style: _getBlockNameTextStyle(),
        ).width;
    //
    double blkLine3 = widget.showClassParameters
        ? extraWidth +
            2 * padding +
            TextSizeUtils.calculateTextSize(
              text: _line3ClassParamsDefinition(),
              style: _getBlockClassParameterTextStyle(),
            ).width
        : 0;
    //
    double filterLine1 = extraWidth +
        2 * padding +
        TextSizeUtils.calculateTextSize(
          text: _getFilterTextRow1(),
          style: _getFilterTextStyle(),
        ).width;
    //
    double filterLine2 = extraWidth +
        2 * padding +
        TextSizeUtils.calculateTextSize(
          text: _getFilterTextRow2(),
          style: _getFilterTextStyle(),
        ).width;
    //
    double lastLine = _calculateLastLineWidth();
    //
    var list = [
      blkLine1,
      blkLine2,
      blkLine3,
      filterLine1,
      filterLine2,
      lastLine
    ];
    return list.fold(0, (a, b) => max(a, b));
  }

  double _calculateLastLineWidth() {
    double width = extraWidth +
        2 * padding +
        iconSize +
        lastLineBlockSpacing +
        TextSizeUtils.calculateTextSize(
          text:
              "${widget.blockOrScalar.isBlock ? 'BLOCK' : 'SCALAR'}     ${widget.blockOrScalar.itemCount.toString()}",
          style: _getSummaryTextStyle(),
        ).width;
    if (widget.blockOrScalar.block?.formModel != null) {
      width += spacing +
          iconSize +
          TextSizeUtils.calculateTextSize(
            text: "FORM",
            style: _getSummaryTextStyle(),
          ).width;
    }
    return width;
  }

  Widget _buildFilterColor() {
    FilterModel? filterModel = widget.blockOrScalar.filterModel;
    Color color = Colors.white;
    if (filterModel != null) {
      List<String> filterNames = widget.blockOrScalar.shelf.filterNames
        ..sort((a, b) => a.compareTo(b));
      //
      int idx = filterNames.indexOf(filterModel.name);
      color = DebugConstants.filterColors.length > idx //
          ? DebugConstants.filterColors[idx]
          : Colors.transparent;
    }

    //
    return Container(
      width: double.maxFinite,
      height: 5,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }

  String _getBlockOrScalarNameText() {
    return widget.blockOrScalar.name;
  }

  String _getBlockOrScalarClassNameText() {
    String className = widget.blockOrScalar.blockOrScalarClassName;
    if (widget.blockOrScalar.isBlock) {
      return className;
    } else {
      return className;
    }
  }

  TextStyle _getSummaryTextStyle() {
    return TextStyle(
      fontSize: DebugConstants.graphBoxFontSizeChildBox,
      overflow: TextOverflow.ellipsis,
      color: DebugConstants.graphBoxTextColor,
    );
  }

  TextStyle _getBlockNameTextStyle() {
    return TextStyle(
      fontSize: DebugConstants.graphBoxFontSizeChildBox,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _getBlockClassParameterTextStyle() {
    return TextStyle(
      fontSize: DebugConstants.graphBoxFontSizeChildBox,
      color: DebugConstants.classParametersColor,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _getFilterTextStyle() {
    return TextStyle(
      fontSize: DebugConstants.graphBoxFontSizeChildBox,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _getFilterTextRow1() {
    FilterModel? filterModel = widget.blockOrScalar.filterModel;
    return filterModel == null ? "[No Filter]" : filterModel.name;
  }

  String _getFilterTextRow2() {
    FilterModel? filterModel = widget.blockOrScalar.filterModel;

    return "${filterModel == null ? '' : getClassName(filterModel)} "
        "${widget.showClassParameters ? widget.blockOrScalar.filterClassParametersDefinition : ''}";
  }

  Widget _buildFilterInfo() {
    FilterModel? filterModel = widget.blockOrScalar.filterModel;
    //
    Widget row = MouseRegion(
      onEnter: filterModel == null
          ? null
          : (_) {
              widget.refreshGraph(filterModel.name);
            },
      onExit: filterModel == null
          ? null
          : (_) {
              widget.refreshGraph(null);
            },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                FaIconConstants.filterModelIconData,
                size: 16,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  _getFilterTextRow1(),
                  style: _getFilterTextStyle(),
                ),
              ),
            ],
          ),
          const Divider(height: 6),
          Text(
            _getFilterTextRow2(),
            style: _getFilterTextStyle(),
          ),
        ],
      ),
    );
    //
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: widget.highlighFilterModelName != null &&
                  filterModel?.name == widget.highlighFilterModelName
              ? DebugConstants.graphBoxHighlighFilterColor
              : Colors.grey,
        ),
        color: widget.highlighFilterModelName != null &&
                filterModel?.name == widget.highlighFilterModelName
            ? DebugConstants.graphBoxHighlighFilterColor
            : Colors.transparent,
      ),
      child: filterModel == null
          ? row
          : TooltipUtils.buildCustomTooltip(
              verticalOffset: -85,
              message: "FILTER: ${getClassName(filterModel)} \n"
                  "${widget.blockOrScalar.filterClassParametersDefinition}",
              child: row,
            ),
    );
  }

  Widget _buildDataStateRow() {
    return Row(
      children: [
        Expanded(
          child: _buildBlockDataState(widget.blockOrScalar),
        ),
        if (widget.blockOrScalar.block?.formModel != null)
          const SizedBox(width: 5),
        if (widget.blockOrScalar.block?.formModel != null)
          _buildFormDataState(widget.blockOrScalar.block!.formModel!),
      ],
    );
  }

  String _formTooltipMessage(
    FormModel formModel,
  ) {
    String className = getClassName(formModel);
    final DataState dataState = formModel.formDataState;
    final bool active = formModel.ui.hasActiveUIComponent();
    //
    return "FORM MODEL: $className \n"
        "Data State: ${dataState.name.toUpperCase()} "
        "| Visibility: ${active ? 'VISIBLE' : 'HIDDEN'} "
        "| Mode: ${formModel.formMode.name.toUpperCase()}";
  }

  String _blockOrScalarTooltipMessage(
      BlockOrScalar blockOrScalar, DataState dataState, bool active) {
    String className = blockOrScalar.blockOrScalarClassName;
    return "${blockOrScalar.isBlock ? 'BLOCK' : 'SCALAR'}: $className \n"
        "Data State: ${dataState.name.toUpperCase()} "
        "| Visibility: ${active ? 'VISIBLE' : 'HIDDEN'} "
        "| Items: ${blockOrScalar.itemCount}";
  }

  IconData _dataStateIconData(DataState dataState) {
    switch (dataState) {
      case DataState.pending:
        return FaIconConstants.dataStatePendingIconData;
      case DataState.ready:
        return FaIconConstants.dataStateReadyIconData;
      case DataState.error:
        return FaIconConstants.dataStateErrorIconData;
      case DataState.none:
        return FaIconConstants.dataStateNoneIconData;
    }
  }

  IconData _visibilityIconData(bool visible) {
    switch (visible) {
      case true:
        return FaIconConstants.visibleTrueIconData;
      case false:
        return FaIconConstants.visibleFalseIconData;
    }
  }

  Color _dataStateBgColor(DataState dataState) {
    switch (dataState) {
      case DataState.pending:
        return DebugConstants.graphBoxDataStatePendingBgColor;
      case DataState.ready:
        return DebugConstants.graphBoxDataStateReadyBgColor;
      case DataState.error:
        return DebugConstants.graphBoxDataStateErrorBgColor;
      case DataState.none:
        return DebugConstants.graphBoxDataStateNoneBgColor;
    }
  }

  Widget _buildBlockDataState(BlockOrScalar blockOrScalar) {
    final DataState dataState = blockOrScalar.dataState;
    bool active = blockOrScalar.hasActiveUIComponent();
    //
    return Container(
      padding: const EdgeInsets.all(3),
      color: _dataStateBgColor(dataState),
      child: TooltipUtils.buildCustomTooltip(
        message: _blockOrScalarTooltipMessage(blockOrScalar, dataState, active),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              _dataStateIconData(dataState),
              size: iconSize,
              color: DebugConstants.graphBoxTextColor,
            ),
            const SizedBox(width: 2),
            Icon(
              _visibilityIconData(active),
              size: iconSize,
              color: DebugConstants.graphBoxTextColor,
            ),
            const SizedBox(width: 5),
            Text(
              widget.blockOrScalar.isBlock ? 'BLOCK' : 'SCALAR',
              style: _getSummaryTextStyle(),
            ),
            const Spacer(),
            Text(
              blockOrScalar.itemCount.toString(),
              style: _getSummaryTextStyle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormDataState(FormModel formModel) {
    return Container(
      padding: const EdgeInsets.all(3),
      color: _dataStateBgColor(formModel.formDataState),
      child: TooltipUtils.buildCustomTooltip(
        message: _formTooltipMessage(
          formModel,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              _dataStateIconData(formModel.formDataState),
              size: 16,
              color: DebugConstants.graphBoxTextColor,
            ),
            const SizedBox(width: 5),
            Text(
              "FORM",
              style: _getSummaryTextStyle(),
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockUiComponentDialog() {
    // TODO: _showBlockUiComponentDialog
    // _showBlockUiComponentsDialog(
    //   context: context,
    //   block: widget.block,
    // );
  }
}
