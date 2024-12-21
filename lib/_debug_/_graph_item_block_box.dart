part of '../flutter_artist.dart';

class _GraphItemBlockBox extends StatefulWidget {
  final Block block;
  final String? highlighBlockFilterName;

  final Function(String? filterName) refreshGraph;

  const _GraphItemBlockBox({
    required super.key,
    required this.block,
    required this.refreshGraph,
    required this.highlighBlockFilterName,
  });

  @override
  State<_GraphItemBlockBox> createState() => _GraphItemBlockBoxState();
}

class _GraphItemBlockBoxState extends State<_GraphItemBlockBox> {
  int filterColorIdx = 0;

  static const double minBoxWidth = 220;
  static const double extraWidth = 30;
  static const double lastLineBlockSpacing = 40;
  static const double spacing = 5;
  static const double padding = 5;

  static const double iconSize = 16;

  @override
  Widget build(BuildContext context) {
    bool hasActiveWidget =
        widget.block.hasActiveBlockFragmentWidget(alsoCheckChildren: false) ||
            (widget.block.blockForm?.hasActiveFormWidget() ?? false);
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
              "packages/flutter_artist/static-rs/block.png",
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
                      text: _getBlockNameText(),
                    ),
                    _IconLabelText(
                      style: _getBlockNameTextStyle(),
                      label: 'Class: ',
                      text: _getBlockClassNameText(),
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
          text: "Name: ${_getBlockNameText()}",
          style: _getBlockNameTextStyle(),
        ).width;
    //
    double blkLine2 = extraWidth +
        _graphBoxImageWidth +
        spacing +
        2 * padding +
        _calculateTextSize(
          text: "Class: ${_getBlockClassNameText()}",
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
          text: "BLOCK     ${widget.block.data.items.length.toString()}",
          style: _getSummaryTextStyle(),
        ).width;
    if (widget.block.blockForm != null) {
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
    BlockFilter? blockFilter = widget.block.blockFilter;
    Color color = Colors.white;
    if (blockFilter != null) {
      List<String> filterNames = widget.block.frame.filterNames
        ..sort((a, b) => a.compareTo(b));
      int idx = filterNames.indexOf(blockFilter.name);
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

  String _getBlockNameText() {
    return widget.block.name;
  }

  String _getBlockClassNameText() {
    return "${getClassName(widget.block)}<${widget.block.getItemTypeAsString()}, ${widget.block.getItemDetailTypeAsString()},..>";
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
    BlockFilter? blockFilter = widget.block.blockFilter;
    return blockFilter == null ? "[No Filter]" : blockFilter.name;
  }

  String _getFilterTextRow2() {
    BlockFilter? blockFilter = widget.block.blockFilter;
    String filterSnapshotType = widget.block.getFilterSnapshotTypeAsString();
    return "${blockFilter == null ? '' : getClassName(blockFilter)} [$filterSnapshotType]";
  }

  Widget _buildFilterInfo() {
    BlockFilter? blockFilter = widget.block.blockFilter;
    //
    Widget row = MouseRegion(
      onEnter: blockFilter == null
          ? null
          : (_) {
              widget.refreshGraph(blockFilter.name);
            },
      onExit: blockFilter == null
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
                _blockFilterIconData,
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
          color: widget.highlighBlockFilterName != null &&
                  blockFilter?.name == widget.highlighBlockFilterName
              ? _graphBoxHighlighFilterColor
              : Colors.grey,
        ),
        color: widget.highlighBlockFilterName != null &&
                blockFilter?.name == widget.highlighBlockFilterName
            ? _graphBoxHighlighFilterColor
            : Colors.transparent,
      ),
      child: blockFilter == null
          ? row
          : _tooltip(
              verticalOffset: -85,
              message: "FILTER: ${blockFilter.name} "
                  "- Class: ${getClassName(blockFilter)} "
                  "- Snapshot: ${widget.block.getFilterSnapshotTypeAsString()}",
              child: row,
            ),
    );
  }

  Widget _tooltip({
    required Widget child,
    required String message,
    double verticalOffset = 18,
  }) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.manual,
      verticalOffset: verticalOffset,
      message: message,
      textStyle: const TextStyle(fontSize: 13, color: Colors.white),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }

  Widget _buildDataStateRow() {
    return Row(
      children: [
        Expanded(
          child: _buildBlockDataState(widget.block),
        ),
        if (widget.block.blockForm != null) const SizedBox(width: 5),
        if (widget.block.blockForm != null)
          _buildFormDataState(widget.block.blockForm!),
      ],
    );
  }

  String _tooltipMessage(String name, String className, DataState dataState) {
    return "$name: $className - Data State: ${dataState.name.toUpperCase()} - "
        "Items: ${widget.block.data.items.length}";
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

  Widget _buildBlockDataState(Block block) {
    final DataState dataState = block.dataState;
    //
    return Container(
      padding: const EdgeInsets.all(3),
      color: _dataStateBgColor(block.dataState),
      child: _tooltip(
        message: _tooltipMessage("BLOCK", getClassName(block), dataState),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              _dataStateIconData(block.dataState),
              size: iconSize,
              color: _graphBoxTextColor,
            ),
            const SizedBox(width: 5),
            Text(
              "BLOCK",
              style: _getSummaryTextStyle(),
            ),
            const Spacer(),
            Text(
              widget.block.data.items.length.toString(),
              style: _getSummaryTextStyle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormDataState(BlockForm blockForm) {
    final DataState dataState = blockForm.dataState;
    //
    return Container(
      padding: const EdgeInsets.all(3),
      color: _dataStateBgColor(blockForm.dataState),
      child: _tooltip(
        message: _tooltipMessage("FORM", getClassName(blockForm), dataState),
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
    _showBlockUiComponentsDialog(
      context: context,
      block: widget.block,
    );
  }
}
