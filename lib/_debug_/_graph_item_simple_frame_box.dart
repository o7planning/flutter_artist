part of '../flutter_artist.dart';

class _GraphItemSimpleFrameBox extends StatefulWidget {
  final bool isRoot;
  final bool isSelected;
  final bool isListener;
  final bool isNotifier;
  final String frameName;
  final Frame? frame;
  final Function()? onSelectFluToShowGraph;
  final Function()? onSelectFluToShowTreeView;

  const _GraphItemSimpleFrameBox({
    super.key,
    required this.isRoot,
    required this.isSelected,
    required this.isListener,
    required this.isNotifier,
    required this.frameName,
    required this.frame,
    required this.onSelectFluToShowGraph,
    required this.onSelectFluToShowTreeView,
  });

  @override
  State<_GraphItemSimpleFrameBox> createState() =>
      _GraphItemSimpleFrameBoxState();
}

class _GraphItemSimpleFrameBoxState extends State<_GraphItemSimpleFrameBox> {
  static const double extraWidth = 16;
  static const double frameIconWidth = 40;
  static const double frameIconHeight = 32;
  static const double spacing = 5;
  static const double padding = 5;
  static const double iconSize = 16;

  final TextStyle textStyle = const TextStyle(
    fontSize: _graphBoxFontSizeChildBox,
  );

  @override
  Widget build(BuildContext context) {
    Size textSize =
        _calculateTextSize(text: widget.frameName, style: textStyle);
    double boxWidth =
        extraWidth + 2 * padding + frameIconWidth + spacing + textSize.width;

    if (widget.isListener) {
      boxWidth += padding + iconSize;
    }
    if (widget.isNotifier) {
      boxWidth += padding + iconSize;
    }

    return SizedBox(
      width: boxWidth,
      child: Container(
        padding: const EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? _selectedGraphBoxBgColor
              : widget.frame == null //
                  ? _inactiveGraphBoxBgColor
                  : _activeGraphBoxBgColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            _graphBoxShadow,
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
                message: "Show Flu structure in the Graph",
                child: Image.asset(
                  "packages/flutter_artist/static-rs/flu.png",
                  width: frameIconWidth,
                  height: frameIconHeight,
                ),
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(
              child: InkWell(
                onTap: widget.onSelectFluToShowTreeView,
                child: Tooltip(
                  message: "Show Flu structure in the Tree",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      widget.frameName,
                      style: textStyle,
                    ),
                  ),
                ),
              ),
            ),
            if (widget.isNotifier) const SizedBox(width: spacing),
            if (widget.isNotifier)
              const Icon(
                _changeSourceIconData,
                size: iconSize,
                color: Colors.deepOrange,
              ),
            if (widget.isListener) const SizedBox(width: padding),
            if (widget.isListener)
              const Icon(
                _listenerIconData,
                size: iconSize,
                color: Colors.indigo,
              ),
          ],
        ),
      ],
    );
  }
}
