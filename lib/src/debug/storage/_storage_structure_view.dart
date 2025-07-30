import 'package:flutter/material.dart';

import '../../core/_fa_core.dart';
import '_shelf_relationship_controller.dart';
import '_shelf_relationship_view.dart';
import '_storage_structure_graph_view.dart';

class StorageStructureView extends StatefulWidget {
  final Function(Shelf shelf) onSelectShelfToShowGraph;

  const StorageStructureView({
    super.key,
    required this.onSelectShelfToShowGraph,
  });

  @override
  State<StatefulWidget> createState() {
    return _StorageStructureViewState();
  }
}

class _StorageStructureViewState extends State<StorageStructureView> {
  final StorageStructureGraphController globalFluStructureGraphController =
      StorageStructureGraphController();

  final ShelfRelationshipController shelfRelationshipController =
      ShelfRelationshipController();

  Shelf? _selectedShelf;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130,
          child: StorageStructureGraphView(
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
          child: ShelfRelationshipView(
            shelfRelationshipController: shelfRelationshipController,
            shelf: _selectedShelf,
            onSelectShelfBlockType: (ShelfBlockScalarType shelfBlockType) {
              Type shelfType = shelfBlockType.shelfType;
              Shelf? shelf = FlutterArtist.storage.debugFindShelf(shelfType);
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
