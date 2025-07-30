import 'package:flutter/material.dart';

import '../../core/_core/code.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../constants/_debug_constants.dart';
import '_block_or_scalar.dart';
import '_shelf_relationship_controller.dart';
import '_shelf_structure_tree_view.dart';
import 'widgets/_block_or_scalar_info_view.dart';
import 'widgets/_shelf_block_scalar_type_widget.dart';
import 'widgets/_shelf_info_view.dart';

class ShelfRelationshipView extends StatefulWidget {
  final ShelfRelationshipController shelfRelationshipController;
  final Shelf? shelf;
  final Function(ShelfBlockScalarType shelfBlockType) onSelectShelfBlockType;

  const ShelfRelationshipView({
    super.key,
    required this.shelfRelationshipController,
    required this.shelf,
    required this.onSelectShelfBlockType,
  });

  @override
  State<StatefulWidget> createState() {
    return _ShelfRelationshipViewState();
  }
}

class _ShelfRelationshipViewState extends State<ShelfRelationshipView> {
  BlockOrScalar? selectedBlockOrScalar;

  @override
  void initState() {
    super.initState();
    widget.shelfRelationshipController.setShelfBlockType =
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
        selectedBlockOrScalar = BlockOrScalar.block(block);
      } else if (scalarName != null) {
        Scalar scalar = widget.shelf!.findScalar(scalarName)!;
        selectedBlockOrScalar = BlockOrScalar.scalar(scalar);
      }
      if (selectedBlockOrScalar == null) {
        if (widget.shelf!.rootBlocks.isNotEmpty) {
          Block block = widget.shelf!.rootBlocks.first;
          selectedBlockOrScalar = BlockOrScalar.block(block);
        } else if (widget.shelf!.scalars.isNotEmpty) {
          Scalar scalar = widget.shelf!.scalars.first;
          selectedBlockOrScalar = BlockOrScalar.scalar(scalar);
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
          child: ShelfStructureTreeView(
            key: Key("Tree-${getClassName(widget.shelf!)}"),
            shelf: widget.shelf!,
            selectedBlockOrScalar: selectedBlockOrScalar,
            onSelectBlockOrScalar: (BlockOrScalar blockOrScalar) {
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
      listeners = FlutterArtist.storage.getListenerShelfBlockScalarTypes(
        eventBlockOrScalar: BlockOrScalar.block(selectedBlockOrScalar!.block!),
        external: true,
      );
      eventSources = FlutterArtist.storage.getEventShelfBlockTypes(
        listenerBlockOrScalar:
            BlockOrScalar.block(selectedBlockOrScalar!.block!),
      );
    } else if (selectedBlockOrScalar?.scalar != null) {
      listeners = FlutterArtist.storage.getListenerShelfBlockScalarTypes(
        eventBlockOrScalar:
            BlockOrScalar.scalar(selectedBlockOrScalar!.scalar!),
        external: true,
      );
      eventSources = FlutterArtist.storage.getEventShelfBlockTypes(
        listenerBlockOrScalar:
            BlockOrScalar.scalar(selectedBlockOrScalar!.scalar!),
      );
    }
    //
    return CustomAppContainer(
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
                  ShelfInfoView(shelf: selectedBlockOrScalar?.shelf),
                  const Divider(),
                  if (selectedBlockOrScalar != null)
                    BlockOrScalarInfoView(
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
    Shelf? shelf =
        FlutterArtist.storage.debugFindShelf(shelfBlockType.shelfType);
    if (shelf != null) {
      // TODO ...
    }

    widget.onSelectShelfBlockType(shelfBlockType);
  }

  Widget _buildListeners(
    BlockOrScalar blockOrScalar,
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
                  FaIconConstants.eventSourceIconData,
                  size: 16,
                  color: DebugConstants.eventSourceIconColor,
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
                  style: DebugConstants.eventSourceTextStyle,
                ),
              if (blockOrScalar.isBlock)
                TextSpan(
                  text: ". It emits an event when its item ",
                ),
              if (blockOrScalar.isBlock)
                TextSpan(
                  text: "(${blockOrScalar.block!.getItemType()})",
                  style: DebugConstants.listenerTextStyle,
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
          (listener) => ShelfBlockScalarTypeWidget(
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
      BlockOrScalar blockOrScalar, List<ShelfBlockScalarType> notifiers) {
    final bool external = true;
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(
                  FaIconConstants.listenerIconData,
                  size: 16,
                  color: DebugConstants.listenerIconColor,
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
                style: DebugConstants.listenerTextStyle,
              ),
              TextSpan(text: ". It listens for changes on Item types: "),
              TextSpan(
                text:
                    "${blockOrScalar.getListenItemTypesAsStrings(external: external)}",
                style: DebugConstants.eventSourceTextStyle,
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
          (notifier) => ShelfBlockScalarTypeWidget(
            shelfBlockScalarType: notifier,
            isListener: false,
            isEventSource: true,
            onTap: () {
              _onSelectFluBlockType(notifier);
            },
          ),
        ),
      ],
    );
  }
}
