import 'package:flutter/material.dart';
import 'package:flutter_left_right_container/left_right_container.dart';

import '../../core/_core_/core.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/widgets/_custom_app_container.dart';
import '_block_or_scalar.dart';
import '_block_or_scalar_view.dart';
import '_shelf_structure_tree_view.dart';

class ActiveShelvesView extends StatefulWidget {
  const ActiveShelvesView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ActiveShelvesViewState();
  }
}

class _ActiveShelvesViewState extends State<ActiveShelvesView> {
  Shelf? selectedShelf;
  BlockOrScalar? selectedBlockOrScalar;
  late final List<Shelf> activeShelves;

  final double paddingHorizontal = 4;
  final double paddingVertical = 5;

  @override
  void initState() {
    super.initState();
    activeShelves = FlutterArtist.storage.activeShelves;
    selectedShelf = activeShelves.firstOrNull;
    _selectDefaultBlockOrScalar();
  }

  void _selectDefaultBlockOrScalar() {
    if (selectedShelf != null) {
      Scalar? scalar = selectedShelf!.scalars.firstOrNull;
      Block? block = selectedShelf!.blocks.firstOrNull;
      if (scalar != null) {
        selectedBlockOrScalar = BlockOrScalar.scalar(scalar);
      } else if (block != null) {
        selectedBlockOrScalar = BlockOrScalar.block(block);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LeftRightContainer(
      style: LeftRightContainerStyle(
        startPadding: EdgeInsets.all(5),
        endPadding: EdgeInsets.all(5),
      ),
      fixedSide: FixedSide.start,
      spacing: 5,
      arrowTopPosition: 35,
      fixedSizeWidth: 280,
      minSideWidth: 300,
      start: _buildLeft(),
      end: _buildRight(),
    );
  }

  Widget _buildShelfList() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ListView(
      children: activeShelves.map(
        (s) {
          final isSelected = selectedShelf?.name == s.name;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.3)
                      : Colors.transparent,
                  width: 0.5),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: 3,
                horizontal: 4,
              ),
              horizontalTitleGap: 0,
              minVerticalPadding: 0,
              minLeadingWidth: 22,
              minTileHeight: 0,
              dense: true,
              visualDensity: VisualDensity(vertical: -3, horizontal: -3),
              leading: Icon(
                FaIconConstants.shelfIconData,
                size: 14,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              title: Text(
                s.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedShelf = s;
                  _selectDefaultBlockOrScalar();
                });
              },
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildLeft() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: CustomAppContainer(
            padding: EdgeInsets.symmetric(
              vertical: paddingVertical,
              horizontal: paddingHorizontal,
            ),
            child: _buildShelfList(),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: _buildShelfStructureTreeView(),
        ),
      ],
    );
  }

  Widget _buildShelfStructureTreeView() {
    return CustomAppContainer(
      width: double.maxFinite,
      height: double.maxFinite,
      padding: EdgeInsets.symmetric(
        vertical: paddingVertical,
        horizontal: paddingHorizontal,
      ),
      child: selectedShelf == null
          ? SizedBox()
          : ShelfStructureTreeView(
              key: Key("Shelf-${selectedShelf?.name}"),
              shelf: selectedShelf!,
              selectedBlockOrScalar: selectedBlockOrScalar,
              onSelectBlockOrScalar: (BlockOrScalar blockOrScalar) {
                setState(() {
                  selectedBlockOrScalar = blockOrScalar;
                });
              },
            ),
    );
  }

  Widget _buildRight() {
    return selectedBlockOrScalar == null
        ? const SizedBox()
        : BlockOrScalarView(
            key: const PageStorageKey('PersistentTabbedView'),
            blockOrScalar: selectedBlockOrScalar!,
          );
  }
}
