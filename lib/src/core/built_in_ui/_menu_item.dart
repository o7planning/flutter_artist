import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '_sorting_options.dart';
import '_tile.dart';

/// A stateful menu item that listens to SortModel changes to refresh
/// even when inside a PopupMenu overlay.
class SortMenuItem extends StatefulWidget {
  final SortCriterion criterion;
  final SortModel sortModel;
  final SortPanelStyle style;
  final SortIconBuilder? iconBuilder;
  final VoidCallback? onUpdate;

  const SortMenuItem({
    super.key,
    required this.criterion,
    required this.sortModel,
    required this.style,
    this.iconBuilder,
    this.onUpdate,
  });

  @override
  State<SortMenuItem> createState() => _SortMenuItemState();
}

class _SortMenuItemState extends State<SortMenuItem> {
  @override
  void initState() {
    super.initState();
    // Start listening to the model so we refresh when ANY change occurs
    widget.sortModel.addListener(_handleModelChange);
  }

  @override
  void dispose() {
    // Crucial: remove listener when the menu is closed
    widget.sortModel.removeListener(_handleModelChange);
    super.dispose();
  }

  void _handleModelChange() {
    print("_handleModelChange @@@@@@@@@@@");
    if (mounted) {
      setState(() {}); // Trigger local rebuild of the menu item
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.criterion.direction != null;

    return InkWell(
      onTap: () {
        // Toggle the criterion - this will trigger the listener above
        toggleCriterion(widget.sortModel, widget.criterion);
        if (widget.onUpdate != null) widget.onUpdate!();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.criterion.text,
                style: widget.style.getTextStyle(context, isActive),
              ),
            ),
            const SizedBox(width: 12),
            (widget.iconBuilder ?? defaultSortIcon)(
              context,
              widget.criterion.direction,
              false,
              widget.style.sortIconSize,
              null,
            ),
          ],
        ),
      ),
    );
  }
}
