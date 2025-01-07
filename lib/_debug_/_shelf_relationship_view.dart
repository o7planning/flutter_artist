part of '../flutter_artist.dart';

class _ShelfRelationshipView extends StatefulWidget {
  final _ShelfRelationshipController shelfRelationshipController;
  final Shelf? shelf;
  final Function(ShelfBlockType shelfBlockType) onSelectShelfBlockType;

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
  Block? selectedBlock;

  @override
  void initState() {
    super.initState();
    widget.shelfRelationshipController._setShelfBlockType =
        (ShelfBlockType shelfBlockType) {
      //
    };
  }

  void _selectDefaultBlockIfNeed() {
    if (widget.shelf == null) {
      selectedBlock = null;
    } else {
      String? blockName = selectedBlock?.name;
      if (blockName != null) {
        selectedBlock = widget.shelf!.findBlock(blockName);
      }
      selectedBlock ??= widget.shelf!.rootBlocks.firstOrNull;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shelf == null) {
      return const Center(
        child: Text("No Shelf Selected"),
      );
    }
    _selectDefaultBlockIfNeed();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 300,
          child: _ShelfStructureTreeView(
            key: Key("Tree-${getClassName(widget.shelf!)}"),
            shelf: widget.shelf!,
            selectedBlock: selectedBlock,
            onSelectBlock: (Block block) {
              setState(() {
                selectedBlock = block;
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
    List<ShelfBlockType> listeners = selectedBlock == null
        ? []
        : FlutterArtist.storage._getListenerBlocks(
            notifierBlock: selectedBlock!,
          );
    List<ShelfBlockType> notifiers = selectedBlock == null
        ? []
        : FlutterArtist.storage._getNotifierBlocks(
            listenerBlock: selectedBlock!,
          );
    //
    return _CustomAppContainer(
      height: double.maxFinite,
      child: selectedBlock == null
          ? const Center(
              child: Text(
                "No Block Selected",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShelfInfoView(shelf: selectedBlock?.shelf),
                const Divider(),
                if (listeners.isNotEmpty)
                  _buildListeners(selectedBlock!, listeners),
                const SizedBox(height: 10),
                if (notifiers.isNotEmpty)
                  _buildNotifiers(selectedBlock!, notifiers),
              ],
            ),
    );
  }

  void _onSelectFluBlockType(ShelfBlockType shelfBlockType) {
    Shelf? shelf = FlutterArtist.storage._findShelf(shelfBlockType.shelfType);
    if (shelf != null) {
      // TODO ...
    }

    widget.onSelectShelfBlockType(shelfBlockType);
  }

  Widget _buildListeners(Block block, List<ShelfBlockType> listeners) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(children: [
            const WidgetSpan(
              child: Icon(
                _changeSourceIconData,
                size: 16,
                color: _notifierColor,
              ),
            ),
            const WidgetSpan(
              child: SizedBox(width: 5),
            ),
            TextSpan(
              text: getClassName(block),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(
                text: " is Notifier Block, "
                    "when data changes on this block, it will notify the following Listener blocks:"),
          ]),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 10),
        ...listeners.map(
          (listener) => _ShelfBlockTypeWidget(
              shelfBlockType: listener,
              isListener: true,
              isNotifier: false,
              onTap: () {
                _onSelectFluBlockType(listener);
              }),
        ),
      ],
    );
  }

  Widget _buildNotifiers(Block block, List<ShelfBlockType> notifiers) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(children: [
            const WidgetSpan(
              child: Icon(
                _listenerIconData,
                size: 16,
                color: _listenerColor,
              ),
            ),
            const WidgetSpan(
              child: SizedBox(width: 5),
            ),
            TextSpan(
              text: getClassName(block),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(
                text: " is Listener Block, "
                    "This block will be refreshed if the data on the following blocks changes:"),
          ]),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 10),
        ...notifiers.map(
          (notifier) => _ShelfBlockTypeWidget(
              shelfBlockType: notifier,
              isListener: false,
              isNotifier: true,
              onTap: () {
                _onSelectFluBlockType(notifier);
              }),
        ),
      ],
    );
  }
}
