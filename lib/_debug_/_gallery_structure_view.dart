part of '../flutter_artist.dart';

class _GalleryStructureView extends StatefulWidget {
  final Function(Shelf shelf) onSelectFrameToShowGraph;

  const _GalleryStructureView({
    super.key,
    required this.onSelectFrameToShowGraph,
  });

  @override
  State<StatefulWidget> createState() {
    return _GalleryStructureViewState();
  }
}

class _GalleryStructureViewState extends State<_GalleryStructureView> {
  final _GalleryStructureGraphController globalFluStructureGraphController =
      _GalleryStructureGraphController();

  final _ShelfRelationshipController shelfRelationshipController =
      _ShelfRelationshipController();

  Shelf? _selectedShelf;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130,
          child: _GalleryStructureGraphView(
            controller: globalFluStructureGraphController,
            onSelectFrameToShowGraph: widget.onSelectFrameToShowGraph,
            onSelectFrameToShowTreeView: (Shelf shelf) {
              setState(() {
                _selectedShelf = shelf;
              });
            },
          ),
        ),
        const Divider(),
        Expanded(
          child: _ShelfRelationshipView(
            shelfRelationshipController: shelfRelationshipController,
            shelf: _selectedShelf,
            onSelectShelfBlockType: (ShelfBlockType shelfBlockType) {
              Type shelfType = shelfBlockType.shelfType;
              Shelf? shelf = FlutterArtist._findShelf(shelfType);
              if (shelf != null) {
                globalFluStructureGraphController.setSelectedShelf(shelf);
              }
            },
          ),
        ),
      ],
    );
  }
}
