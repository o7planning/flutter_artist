part of '../flutter_artist.dart';

class _ShelfBlockScalarTypeWidget extends StatelessWidget {
  final Function()? onTap;
  final ShelfBlockScalarType shelfBlockScalarType;
  final bool isListener;
  final bool isEventSource;

  const _ShelfBlockScalarTypeWidget({
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
          isListener ? _listenerIconData : _eventSourceIconData,
          size: 16,
          color: isListener ? _listenerIconColor : _eventSourceIconColor,
        ),
        title: BreadCrumb(
          divider: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              _breadcrumbIconData,
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
    Shelf? shelf =
        FlutterArtist.storage._findShelf(shelfBlockScalarType.shelfType);
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
      tooltipMessage = shelfBlockScalarType.blockClassDefinition ?? "";
    } else {
      w = Text(
        shelfBlockScalarType.scalarType.toString(),
        style: const TextStyle(fontSize: 12),
      );
      tooltipMessage = shelfBlockScalarType.scalarClassDefinition ?? "";
    }
    return Tooltip(
      message: tooltipMessage,
      child: w,
    );
  }
}
