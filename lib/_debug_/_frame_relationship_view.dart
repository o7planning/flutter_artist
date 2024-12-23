part of '../flutter_artist.dart';

class _FrameRelationshipView extends StatefulWidget {
  final _FrameRelationshipController frameRelationshipController;
  final Frame? frame;
  final Function(FrameBlockType frameBlockType) onSelectFrameBlockType;

  const _FrameRelationshipView({
    required this.frameRelationshipController,
    required this.frame,
    required this.onSelectFrameBlockType,
  });

  @override
  State<StatefulWidget> createState() {
    return _FrameRelationshipViewState();
  }
}

class _FrameRelationshipViewState extends State<_FrameRelationshipView> {
  Block? selectedBlock;

  @override
  void initState() {
    super.initState();
    widget.frameRelationshipController._setFrameBlockType =
        (FrameBlockType frameBlockType) {
      //
    };
  }

  void _selectDefaultBlockIfNeed() {
    if (widget.frame == null) {
      selectedBlock = null;
    } else {
      String? blockName = selectedBlock?.name;
      if (blockName != null) {
        selectedBlock = widget.frame!.findBlock(blockName);
      }
      selectedBlock ??= widget.frame!.rootBlocks.firstOrNull;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.frame == null) {
      return const Center(
        child: Text("No Flu selected"),
      );
    }
    _selectDefaultBlockIfNeed();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 300,
          child: _FrameStructureTreeView(
            key: Key("Tree-${getClassName(widget.frame!)}"),
            frame: widget.frame!,
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
    List<FrameBlockType> listeners = selectedBlock == null
        ? []
        : FlutterArtist._getListenerBlocks(notifierBlock: selectedBlock!);
    List<FrameBlockType> notifiers = selectedBlock == null
        ? []
        : FlutterArtist._getNotifierBlocks(listenerBlock: selectedBlock!);
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
                _FrameInfoView(frame: selectedBlock?.frame),
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

  void _onSelectFluBlockType(FrameBlockType frameBlockType) {
    Frame? frame = FlutterArtist._findFrame(frameBlockType.frameType);
    if (frame != null) {
      // TODO ...
    }

    widget.onSelectFrameBlockType(frameBlockType);
  }

  Widget _buildListeners(Block block, List<FrameBlockType> listeners) {
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
          (listener) => _FrameBlockTypeWidget(
              frameBlockType: listener,
              isListener: true,
              isNotifier: false,
              onTap: () {
                _onSelectFluBlockType(listener);
              }),
        ),
      ],
    );
  }

  Widget _buildNotifiers(Block block, List<FrameBlockType> notifiers) {
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
          (notifier) => _FrameBlockTypeWidget(
              frameBlockType: notifier,
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
