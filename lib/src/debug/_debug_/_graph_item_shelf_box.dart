import 'package:flutter/material.dart';
import 'package:flutter_artist/src/debug/_debug_/_debug_constants.dart';

import '../../core/_fa_core.dart';
import '../../icon/icon_constants.dart';

class GraphItemShelfBox extends StatefulWidget {
  final Function() gotoStorage;
  final Shelf shelf;

  const GraphItemShelfBox({
    super.key,
    required this.gotoStorage,
    required this.shelf,
  });

  @override
  State<GraphItemShelfBox> createState() => GraphItemShelfBoxState();
}

class GraphItemShelfBoxState extends State<GraphItemShelfBox> {
  static const double _graphBoxImageWidth = 40;
  static const double _graphBoxImageHeight = 32;

  static const double iconSize = 18;

  static const double extraWidth = 40;
  static const double spacing = 5;
  static const double padding = 5;

  @override
  Widget build(BuildContext context) {
    double boxWidth = _calculateBoxWidth();

    return SizedBox(
      width: boxWidth,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: DebugConstants.rootGraphBoxBgColor,
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
            Image.asset(
              "packages/flutter_artist/static-rs/shelf.png",
              width: _graphBoxImageWidth,
              height: _graphBoxImageHeight,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Text(
                        _getShelfName(),
                        style: _getTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
                minimumSize: Size.zero,
              ),
              onPressed: widget.gotoStorage,
              child: const Icon(
                FaIconConstants.uptoStorageIconData,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ],
        ),
      ],
    );
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      fontSize: DebugConstants.graphBoxFontSizeRootBox,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _getShelfName() {
    return getClassName(widget.shelf);
  }

  double _calculateBoxWidth() {
    return extraWidth +
        _graphBoxImageWidth +
        2 * spacing +
        2 * padding +
        iconSize +
        _calculateTextSize(
          text: _getShelfName(),
          style: _getTextStyle(),
        ).width;
  }
}
