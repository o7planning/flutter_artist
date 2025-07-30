import 'package:flutter/material.dart';

import '../../../core/_core/core.dart';
import '../../../core/icon/icon_constants.dart';
import '../../constants/_debug_constants.dart';

class GraphItemSimpleShelfBox extends StatefulWidget {
  final bool isRoot;
  final bool isSelected;
  final bool isListener;
  final bool isEventSource;
  final String shelfName;
  final Shelf? shelf;
  final Function()? onSelectFluToShowGraph;
  final Function()? onSelectFluToShowTreeView;

  const GraphItemSimpleShelfBox({
    super.key,
    required this.isRoot,
    required this.isSelected,
    required this.isListener,
    required this.isEventSource,
    required this.shelfName,
    required this.shelf,
    required this.onSelectFluToShowGraph,
    required this.onSelectFluToShowTreeView,
  });

  @override
  State<GraphItemSimpleShelfBox> createState() =>
      GraphItemSimpleShelfBoxState();
}

class GraphItemSimpleShelfBoxState extends State<GraphItemSimpleShelfBox> {
  static const double extraWidth = 16;
  static const double shelfIconWidth = 40;
  static const double shelfIconHeight = 32;
  static const double spacing = 5;
  static const double padding = 5;
  static const double iconSize = 16;

  final TextStyle textStyle = TextStyle(
    fontSize: DebugConstants.graphBoxFontSizeChildBox,
  );

  @override
  Widget build(BuildContext context) {
    Size textSize = TextSizeUtils.calculateTextSize(
        text: widget.shelfName, style: textStyle);
    double boxWidth =
        extraWidth + 2 * padding + shelfIconWidth + spacing + textSize.width;

    if (widget.isListener) {
      boxWidth += padding + iconSize;
    }
    if (widget.isEventSource) {
      boxWidth += padding + iconSize;
    }

    return SizedBox(
      width: boxWidth,
      child: Container(
        padding: const EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? DebugConstants.selectedGraphBoxBgColor
              : widget.shelf == null //
                  ? DebugConstants.inactiveGraphBoxBgColor
                  : DebugConstants.activeGraphBoxBgColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            DebugConstants.graphBoxShadow,
          ],
        ),
        child: _buildRootBoxContent(),
      ),
    );
  }

  Widget _buildRootBoxContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
              ),
              onPressed: widget.onSelectFluToShowGraph,
              child: Tooltip(
                message: "Show Shelf structure in the Graph",
                child: Image.asset(
                  "packages/flutter_artist/static-rs/shelf.png",
                  width: shelfIconWidth,
                  height: shelfIconHeight,
                ),
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: InkWell(
                onTap: widget.onSelectFluToShowTreeView,
                child: Tooltip(
                  message: "Show Shelf structure in the Tree",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      widget.shelfName,
                      style: textStyle,
                    ),
                  ),
                ),
              ),
            ),
            if (widget.isEventSource) const SizedBox(width: spacing),
            if (widget.isEventSource)
              const Icon(
                FaIconConstants.eventSourceIconData,
                size: iconSize,
                color: Colors.deepOrange,
              ),
            if (widget.isListener) const SizedBox(width: padding),
            if (widget.isListener)
              const Icon(
                FaIconConstants.listenerIconData,
                size: iconSize,
                color: Colors.indigo,
              ),
          ],
        ),
      ],
    );
  }
}
