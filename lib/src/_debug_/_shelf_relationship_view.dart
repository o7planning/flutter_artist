part of '../../flutter_artist.dart';

class _ShelfRelationshipView extends StatefulWidget {
  final _ShelfRelationshipController shelfRelationshipController;
  final Shelf? shelf;
  final Function(ShelfBlockScalarType shelfBlockType) onSelectShelfBlockType;

  const _ShelfRelationshipView({
    required this.shelfRelationshipController,
    required this.shelf,
    required this.onSelectShelfBlockType,
  });

  @override
  State<StatefulWidget> createState() {
    return _ShelfRelationshipViewState();
  }
}

class _ShelfRelationshipViewState extends State<_ShelfRelationshipView> {
  _BlockOrScalar? selectedBlockOrScalar;

  @override
  void initState() {
    super.initState();
    widget.shelfRelationshipController._setShelfBlockType =
        (ShelfBlockScalarType shelfBlockType) {
      //
    };
  }

  void _selectDefaultBlockOrScalarIfNeed() {
    if (widget.shelf == null) {
      selectedBlockOrScalar = null;
    } else {
      if (selectedBlockOrScalar?.shelf != widget.shelf) {
        selectedBlockOrScalar = null;
      }
      String? blockName = selectedBlockOrScalar?.block?.name;
      String? scalarName = selectedBlockOrScalar?.scalar?.name;
      if (blockName != null) {
        Block block = widget.shelf!.findBlock(blockName)!;
        selectedBlockOrScalar = _BlockOrScalar.block(block);
      } else if (scalarName != null) {
        Scalar scalar = widget.shelf!.findScalar(scalarName)!;
        selectedBlockOrScalar = _BlockOrScalar.scalar(scalar);
      }
      if (selectedBlockOrScalar == null) {
        if (widget.shelf!.rootBlocks.isNotEmpty) {
          Block block = widget.shelf!.rootBlocks.first;
          selectedBlockOrScalar = _BlockOrScalar.block(block);
        } else if (widget.shelf!.scalars.isNotEmpty) {
          Scalar scalar = widget.shelf!.scalars.first;
          selectedBlockOrScalar = _BlockOrScalar.scalar(scalar);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shelf == null) {
      return const Center(
        child: Text("No Shelf Selected"),
      );
    }
    _selectDefaultBlockOrScalarIfNeed();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 300,
          child: _ShelfStructureTreeView(
            key: Key("Tree-${getClassName(widget.shelf!)}"),
            shelf: widget.shelf!,
            selectedBlockOrScalar: selectedBlockOrScalar,
            onSelectBlockOrScalar: (_BlockOrScalar blockOrScalar) {
              setState(() {
                selectedBlockOrScalar = blockOrScalar;
              });
            },
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: _buildRelatedBlockInfos(),
        ),
      ],
    );
  }

  Widget _buildRelatedBlockInfos() {
    List<ShelfBlockScalarType> listeners = [];
    List<ShelfBlockScalarType> eventSources = [];
    if (selectedBlockOrScalar?.block != null) {
      listeners = FlutterArtist.storage._getListenerShelfBlockScalarTypes(
        eventBlockOrScalar: _BlockOrScalar.block(selectedBlockOrScalar!.block!),
      );
      eventSources = FlutterArtist.storage._getEventShelfBlockTypes(
        listenerBlockOrScalar:
            _BlockOrScalar.block(selectedBlockOrScalar!.block!),
      );
    } else if (selectedBlockOrScalar?.scalar != null) {
      listeners = FlutterArtist.storage._getListenerShelfBlockScalarTypes(
        eventBlockOrScalar:
            _BlockOrScalar.scalar(selectedBlockOrScalar!.scalar!),
      );
      eventSources = FlutterArtist.storage._getEventShelfBlockTypes(
        listenerBlockOrScalar:
            _BlockOrScalar.scalar(selectedBlockOrScalar!.scalar!),
      );
    }
    //
    return _CustomAppContainer(
      height: double.maxFinite,
      child: selectedBlockOrScalar == null
          ? const Center(
              child: Text(
                "No Block or Scalar Selected",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShelfInfoView(shelf: selectedBlockOrScalar?.shelf),
                  const Divider(),
                  if (selectedBlockOrScalar != null)
                    _BlockOrScalarInfoView(
                      blockOrScalar: selectedBlockOrScalar!,
                    ),
                  if (selectedBlockOrScalar != null) const Divider(),
                  if (listeners.isNotEmpty)
                    _buildListeners(selectedBlockOrScalar!, listeners),
                  const SizedBox(height: 10),
                  if (eventSources.isNotEmpty)
                    _buildEventSources(selectedBlockOrScalar!, eventSources),
                ],
              ),
            ),
    );
  }

  void _onSelectFluBlockType(ShelfBlockScalarType shelfBlockType) {
    Shelf? shelf = FlutterArtist.storage._findShelf(shelfBlockType.shelfType);
    if (shelf != null) {
      // TODO ...
    }

    widget.onSelectShelfBlockType(shelfBlockType);
  }

  Widget _buildListeners(
    _BlockOrScalar blockOrScalar,
    List<ShelfBlockScalarType> listeners,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(
                  _eventSourceIconData,
                  size: 16,
                  color: _eventSourceIconColor,
                ),
              ),
              const WidgetSpan(
                child: SizedBox(width: 5),
              ),
              TextSpan(
                text: blockOrScalar.blockOrScalarClassName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (blockOrScalar.isBlock) TextSpan(text: " is "),
              if (blockOrScalar.isBlock)
                TextSpan(
                  text: "Event Block",
                  style: _eventSourceTextStyle,
                ),
              if (blockOrScalar.isBlock)
                TextSpan(
                  text: ". It emits an event when its item ",
                ),
              if (blockOrScalar.isBlock)
                TextSpan(
                  text: "(${blockOrScalar.block!.getItemTypeAsString()})",
                  style: _listenerTextStyle,
                ),
              if (blockOrScalar.isBlock)
                TextSpan(
                  text: " changes. "
                      "When data changes on this block, "
                      "it will notify the following Listener blocks or scalars:",
                ),
            ],
          ),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 10),
        ...listeners.map(
          (listener) => _ShelfBlockScalarTypeWidget(
              shelfBlockScalarType: listener,
              isListener: true,
              isEventSource: false,
              onTap: () {
                _onSelectFluBlockType(listener);
              }),
        ),
      ],
    );
  }

  Widget _buildEventSources(
      _BlockOrScalar blockOrScalar, List<ShelfBlockScalarType> notifiers) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(
                  _listenerIconData,
                  size: 16,
                  color: _listenerIconColor,
                ),
              ),
              const WidgetSpan(
                child: SizedBox(width: 5),
              ),
              TextSpan(
                text: blockOrScalar.blockOrScalarClassName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: " is "),
              TextSpan(
                text: blockOrScalar.isBlock
                    ? 'Listener Block'
                    : 'Listener Scalar',
                style: _listenerTextStyle,
              ),
              TextSpan(text: ". It listens for changes on Item types: "),
              TextSpan(
                text: "${blockOrScalar.listenItemTypesAsStrings}",
                style: _eventSourceTextStyle,
              ),
              TextSpan(
                text: ". This ${blockOrScalar.isBlock ? 'block' : 'scalar'} "
                    "will be refreshed if the data on the following blocks changes:",
              ),
            ],
          ),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 10),
        ...notifiers.map(
          (notifier) => _ShelfBlockScalarTypeWidget(
              shelfBlockScalarType: notifier,
              isListener: false,
              isEventSource: true,
              onTap: () {
                _onSelectFluBlockType(notifier);
              }),
        ),
      ],
    );
  }
}
