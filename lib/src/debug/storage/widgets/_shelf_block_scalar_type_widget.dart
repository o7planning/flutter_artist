import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../../../core/_fa_core.dart';
import '../../../icon/icon_constants.dart';
import '../../constants/_debug_constants.dart';

class ShelfBlockScalarTypeWidget extends StatelessWidget {
  final Function()? onTap;
  final ShelfBlockScalarType shelfBlockScalarType;
  final bool isListener;
  final bool isEventSource;

  const ShelfBlockScalarTypeWidget({
    super.key,
    required this.onTap,
    required this.shelfBlockScalarType,
    required this.isListener,
    required this.isEventSource,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 0,
      ),
      color: shelfBlockScalarType.isBlock ? Colors.white : Colors.yellow[50],
      child: ListTile(
        minLeadingWidth: 0,
        horizontalTitleGap: 10,
        dense: true,
        visualDensity: const VisualDensity(vertical: -3, horizontal: -3),
        leading: Icon(
          isListener
              ? FaIconConstants.listenerIconData
              : FaIconConstants.eventSourceIconData,
          size: 16,
          color: isListener
              ? DebugConstants.listenerIconColor
              : DebugConstants.eventSourceIconColor,
        ),
        title: BreadCrumb(
          divider: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              FaIconConstants.breadcrumbIconData,
              size: 16,
            ),
          ),
          items: [
            BreadCrumbItem(
              content: _buildShelf(),
            ),
            BreadCrumbItem(
              content: _buildBlockOrScalar(),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildShelf() {
    Shelf? shelf = FlutterArtist.storage.debugFindShelf(
      shelfBlockScalarType.shelfType,
    );
    String? shelfName = shelf?.name;
    String? description = shelf?.description;

    Widget w = Text(
      shelfName ?? " - ",
      style: const TextStyle(fontSize: 12),
    );
    return description == null
        ? w
        : Tooltip(
            message: description,
            child: w,
          );
  }

  Widget _buildBlockOrScalar() {
    String tooltipMessage = "";
    Widget w;
    if (shelfBlockScalarType.isBlock) {
      w = Text(
        shelfBlockScalarType.blockType.toString(),
        style: const TextStyle(fontSize: 12),
      );
      tooltipMessage = "BLOCK: ${shelfBlockScalarType.className}\n"
          "${shelfBlockScalarType.classParameterDefinition}";
    } else {
      w = Text(
        shelfBlockScalarType.scalarType.toString(),
        style: const TextStyle(fontSize: 12),
      );
      tooltipMessage = "SCALAR: ${shelfBlockScalarType.className}\n"
          "${shelfBlockScalarType.classParameterDefinition}";
    }
    return Tooltip(
      message: tooltipMessage,
      child: w,
    );
  }
}
