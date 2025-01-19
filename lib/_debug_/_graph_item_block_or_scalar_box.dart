part of '../flutter_artist.dart';

class _GraphItemBlockOrScalarBox extends StatefulWidget {
  final _BlockOrScalar blockOrScalar;
  final String? highlighDataFilterName;

  final Function(String? filterName) refreshGraph;

  const _GraphItemBlockOrScalarBox({
    required super.key,
    required this.blockOrScalar,
    required this.refreshGraph,
    required this.highlighDataFilterName,
  });

  @override
  State<_GraphItemBlockOrScalarBox> createState() =>
      _GraphItemBlockOrScalarBoxState();
}

class _GraphItemBlockOrScalarBoxState
    extends State<_GraphItemBlockOrScalarBox> {
  int filterColorIdx = 0;

  static const double minBoxWidth = 220;
  static const double extraWidth = 30;
  static const double lastLineBlockSpacing = 40;
  static const double spacing = 5;
  static const double padding = 5;

  static const double iconSize = 16;

  @override
  Widget build(BuildContext context) {
    bool hasActiveWidget = widget.blockOrScalar.hasActiveUiComponent();
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
                  ? _activeGraphBoxBgColor
                  : _inactiveGraphBoxBgColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                _graphBoxShadow,
              ],
            ),
            child: _buildMainContent(),
          ),
          if (hasActiveWidget)
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                icon: const Icon(_infoIconData, size: 16),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              widget.blockOrScalar.isBlock
                  ? "packages/flutter_artist/static-rs/block.png"
                  : "packages/flutter_artist/static-rs/scalar.png",
              width: _graphBoxImageWidth,
              height: _graphBoxImageHeight,
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _IconLabelText(
                      style: _getBlockNameTextStyle(),
                      label: 'Name: ',
                      text: _getBlockOrScalarNameText(),
                    ),
                    _buildTooltip(
                      message:
                          "Class: ${widget.blockOrScalar.blockOrScalarClassName}\n"
                          "Parameters: ${widget.blockOrScalar.blockOrScalarClassParametersDefinition}",
                      child: _IconLabelText(
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
        ),
        const SizedBox(height: 5),
        _buildFilterInfo(),
        const SizedBox(height: 2),
        _buildFilterColor(),
        const SizedBox(height: 3),
        _buildDataStateRow(),
      ],
    );
  }

  double _calculateBoxWidth() {
    double blkLine1 = extraWidth +
        _graphBoxImageWidth +
        spacing +
        2 * padding +
        _calculateTextSize(
          text: "Name: ${_getBlockOrScalarNameText()}",
          style: _getBlockNameTextStyle(),
        ).width;
    //
    double blkLine2 = extraWidth +
        _graphBoxImageWidth +
        spacing +
        2 * padding +
        _calculateTextSize(
          text: "Class: ${_getBlockOrScalarClassNameText()}",
          style: _getBlockNameTextStyle(),
        ).width;
    //
    double filterLine1 = extraWidth +
        2 * padding +
        _calculateTextSize(
          text: _getFilterTextRow1(),
          style: _getFilterTextStyle(),
        ).width;
    //
    double filterLine2 = extraWidth +
        2 * padding +
        _calculateTextSize(
          text: _getFilterTextRow2(),
          style: _getFilterTextStyle(),
        ).width;
    //
    double lastLine = _calculateLastLineWidth();
    //
    double m = max(max(blkLine1, blkLine2), max(filterLine1, filterLine2));
    return max(m, lastLine);
  }

  double _calculateLastLineWidth() {
    double width = extraWidth +
        2 * padding +
        iconSize +
        lastLineBlockSpacing +
        _calculateTextSize(
          text:
              "${widget.blockOrScalar.isBlock ? 'BLOCK' : 'SCALAR'}     ${widget.blockOrScalar.itemCount.toString()}",
          style: _getSummaryTextStyle(),
        ).width;
    if (widget.blockOrScalar.block?.blockForm != null) {
      width += spacing +
          iconSize +
          _calculateTextSize(
            text: "FORM",
            style: _getSummaryTextStyle(),
          ).width;
    }
    return width;
  }

  Widget _buildFilterColor() {
    DataFilter? dataFilter = widget.blockOrScalar.dataFilter;
    Color color = Colors.white;
    if (dataFilter != null) {
      List<String> filterNames = widget.blockOrScalar.shelf.filterNames
        ..sort((a, b) => a.compareTo(b));
      //
      int idx = filterNames.indexOf(dataFilter.name);
      color = _filterColors.length > idx //
          ? _filterColors[idx]
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
      Block block = widget.blockOrScalar.block!;
      return "$className<${block.getItemIdTypeAsString()}, ${block.getItemTypeAsString()}, ${block.getItemDetailTypeAsString()}, S, SF>";
    } else {
      Scalar scalar = widget.blockOrScalar.scalar!;
      return "$className<${scalar.getValueTypeAsString()}, S>";
    }
  }

  TextStyle _getSummaryTextStyle() {
    return const TextStyle(
      fontSize: _graphBoxFontSizeChildBox,
      overflow: TextOverflow.ellipsis,
      color: _graphBoxTextColor,
    );
  }

  TextStyle _getBlockNameTextStyle() {
    return const TextStyle(
      fontSize: _graphBoxFontSizeChildBox,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _getFilterTextStyle() {
    return const TextStyle(
      fontSize: _graphBoxFontSizeChildBox,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _getFilterTextRow1() {
    DataFilter? dataFilter = widget.blockOrScalar.dataFilter;
    return dataFilter == null ? "[No Filter]" : dataFilter.name;
  }

  String _getFilterTextRow2() {
    DataFilter? dataFilter = widget.blockOrScalar.dataFilter;
    String filterCriteriaType =
        widget.blockOrScalar.getFilterCriteriaTypeAsString();
    return "${dataFilter == null ? '' : getClassName(dataFilter)} [$filterCriteriaType]";
  }

  Widget _buildFilterInfo() {
    DataFilter? dataFilter = widget.blockOrScalar.dataFilter;
    //
    Widget row = MouseRegion(
      onEnter: dataFilter == null
          ? null
          : (_) {
              widget.refreshGraph(dataFilter.name);
            },
      onExit: dataFilter == null
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
                _dataFilterIconData,
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
          color: widget.highlighDataFilterName != null &&
                  dataFilter?.name == widget.highlighDataFilterName
              ? _graphBoxHighlighFilterColor
              : Colors.grey,
        ),
        color: widget.highlighDataFilterName != null &&
                dataFilter?.name == widget.highlighDataFilterName
            ? _graphBoxHighlighFilterColor
            : Colors.transparent,
      ),
      child: dataFilter == null
          ? row
          : _buildCustomTooltip(
              verticalOffset: -85,
              message: "FILTER: ${dataFilter.name} \n"
                  "Class: ${getClassName(dataFilter)} "
                  "| Criteria: ${widget.blockOrScalar.getFilterCriteriaTypeAsString()}",
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
        if (widget.blockOrScalar.block?.blockForm != null)
          const SizedBox(width: 5),
        if (widget.blockOrScalar.block?.blockForm != null)
          _buildFormDataState(widget.blockOrScalar.block!.blockForm!),
      ],
    );
  }

  String _formTooltipMessage(
    BlockForm blockForm,
  ) {
    String className = getClassName(blockForm);
    final DataState dataState = blockForm.dataState;
    final bool active = blockForm.hasActiveFormWidget();
    //
    return "FORM: $className \n"
        "Data State: ${dataState.name.toUpperCase()} "
        "| Visibility: ${active ? 'VISIBLE' : 'HIDDEN'} "
        "| Mode: ${blockForm.data.formMode.name.toUpperCase()}";
  }

  String _blockOrScalarTooltipMessage(
      _BlockOrScalar blockOrScalar, DataState dataState, bool active) {
    String className = blockOrScalar.blockOrScalarClassName;
    return "${blockOrScalar.isBlock ? 'BLOCK' : 'SCALAR'}: $className \n"
        "Data State: ${dataState.name.toUpperCase()} "
        "| Visibility: ${active ? 'VISIBLE' : 'HIDDEN'} "
        "| Items: ${blockOrScalar.itemCount}";
  }

  IconData _dataStateIconData(DataState dataState) {
    switch (dataState) {
      case DataState.pending:
        return _dataStatePendingIconData;
      case DataState.ready:
        return _dataStateReadyIconData;
      case DataState.error:
        return _dataStateErrorIconData;
    }
  }

  IconData _visibilityIconData(bool visible) {
    switch (visible) {
      case true:
        return _visibitityTrueIconData;
      case false:
        return _visibitityFalseIconData;
    }
  }

  Color _dataStateBgColor(DataState dataState) {
    switch (dataState) {
      case DataState.pending:
        return _graphBoxDataStatePendingBgColor;
      case DataState.ready:
        return _graphBoxDataStateReadyBgColor;
      case DataState.error:
        return _graphBoxDataStateErrorBgColor;
    }
  }

  Widget _buildBlockDataState(_BlockOrScalar blockOrScalar) {
    final DataState dataState = blockOrScalar.dataState;
    bool active = blockOrScalar.hasActiveUiComponent();
    //
    return Container(
      padding: const EdgeInsets.all(3),
      color: _dataStateBgColor(dataState),
      child: _buildCustomTooltip(
        message: _blockOrScalarTooltipMessage(blockOrScalar, dataState, active),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              _dataStateIconData(dataState),
              size: iconSize,
              color: _graphBoxTextColor,
            ),
            const SizedBox(width: 2),
            Icon(
              _visibilityIconData(active),
              size: iconSize,
              color: _graphBoxTextColor,
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

  Widget _buildFormDataState(BlockForm blockForm) {
    return Container(
      padding: const EdgeInsets.all(3),
      color: _dataStateBgColor(blockForm.dataState),
      child: _buildCustomTooltip(
        message: _formTooltipMessage(
          blockForm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              _dataStateIconData(blockForm.dataState),
              size: 16,
              color: _graphBoxTextColor,
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
