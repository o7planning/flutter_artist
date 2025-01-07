part of '../flutter_artist.dart';

class _StorageStructureView extends StatefulWidget {
  final Function(Shelf shelf) onSelectShelfToShowGraph;

  const _StorageStructureView({
    super.key,
    required this.onSelectShelfToShowGraph,
  });

  @override
  State<StatefulWidget> createState() {
    return _StorageStructureViewState();
  }
}

class _StorageStructureViewState extends State<_StorageStructureView> {
  final _StorageStructureGraphController globalFluStructureGraphController =
      _StorageStructureGraphController();

  final _ShelfRelationshipController shelfRelationshipController =
      _ShelfRelationshipController();

  Shelf? _selectedShelf;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130,
          child: _StorageStructureGraphView(
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
              Shelf? shelf = FlutterArtist.storage._findShelf(shelfType);
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
