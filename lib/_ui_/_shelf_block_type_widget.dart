part of '../flutter_artist.dart';

class _ShelfBlockTypeWidget extends StatelessWidget {
  final Function()? onTap;
  final ShelfBlockScalarType shelfBlockType;
  final bool isListener;
  final bool isNotifier;

  const _ShelfBlockTypeWidget({
    required this.onTap,
    required this.shelfBlockType,
    required this.isListener,
    required this.isNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 0,
      ),
      child: ListTile(
        minLeadingWidth: 0,
        horizontalTitleGap: 10,
        dense: true,
        visualDensity: const VisualDensity(vertical: -3, horizontal: -3),
        leading: Icon(
          isListener ? _listenerIconData : _changeSourceIconData,
          size: 16,
          color: isListener ? _listenerColor : _notifierColor,
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
              content: _buildBlock(),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildShelf() {
    Shelf? shelf = FlutterArtist.storage._findShelf(shelfBlockType.shelfType);
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

  Widget _buildBlock() {
    return Text(
      shelfBlockType.blockType.toString(),
      style: const TextStyle(fontSize: 12),
    );
  }
}
