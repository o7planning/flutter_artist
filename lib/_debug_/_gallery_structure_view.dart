part of '../flutter_artist.dart';

class _GalleryStructureView extends StatefulWidget {
  final Function(Shelf shelf) onSelectShelfToShowGraph;

  const _GalleryStructureView({
    super.key,
    required this.onSelectShelfToShowGraph,
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
            onSelectShelfToShowGraph: widget.onSelectShelfToShowGraph,
            onSelectShelfToShowTreeView: (Shelf shelf) {
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
              Shelf? shelf = Storage._findShelf(shelfType);
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
