import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '../enums/_sort_direction.dart';
import '_sort_panel_helper.dart';
import '_sorting_options.dart';
import 'sort_dialog_panel_style.dart';

class SortDialogContent extends StatefulWidget {
  final SortModel sortModel;
  final SortDialogPanelStyle style;

  const SortDialogContent({
    super.key,
    required this.sortModel,
    required this.style,
  });

  @override
  State<SortDialogContent> createState() => SortDialogContentState();
}

class SortDialogContentState extends State<SortDialogContent> {
  late List<SortCriterion> _localCriteria;

  @override
  void initState() {
    super.initState();
    _localCriteria = widget.sortModel.copiedCriteria;
  }

  /// Expose the current arrangement for the Parent Dialog to Apply
  List<SortCriterion> get currentArrangement => _localCriteria;

  void resetLocalCriteria() {
    setState(() {
      for (var c in _localCriteria) {
        c.updateDirectionIfCopied(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 400,
      child: ReorderableListView.builder(
        itemCount: _localCriteria.length,
        proxyDecorator: (child, index, animation) {
          return Material(
            elevation: 4,
            color: SortPanelHelper.getBackgroundColor(context)
                .withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8),
            child: child,
          );
        },
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) newIndex -= 1;
            final item = _localCriteria.removeAt(oldIndex);
            _localCriteria.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final criterion = _localCriteria[index];
          final isActive = criterion.direction != null;
          final bool canToggle = !criterion.directionalSelectionOnly;

          return ListTile(
            key: ValueKey('dialog_item_${criterion.criterionName}'),
            onTap: canToggle
                ? () {
                    setState(() {
                      criterion.updateDirectionIfCopied(
                        isActive
                            ? null
                            : (criterion.initialDirection ?? SortDirection.asc),
                      );
                    });
                  }
                : null,
            leading: Tooltip(
              message: isActive ? 'Active' : 'Non-active',
              child: Transform.scale(
                scale: widget.style.switchScale,
                child: Switch.adaptive(
                  value: isActive,
                  activeTrackColor: SortPanelHelper.getTextColor(context, true),
                  onChanged: canToggle
                      ? (val) {
                          setState(() {
                            criterion.updateDirectionIfCopied(
                              val
                                  ? (criterion.initialDirection ??
                                      SortDirection.asc)
                                  : null,
                            );
                          });
                        }
                      : null,
                ),
              ),
            ),
            title: Text(
              criterion.text,
              style: widget.style.getTextStyle(context, isActive),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: 'Change sorting direction.',
                  child: buildSortButton(
                    context: context,
                    sortModel: widget.sortModel,
                    criterion: criterion,
                    enabled: true,
                    isDragging: false,
                    iconSize: widget.style.sortIconSize,
                    draggingColor: widget.style.draggingColor,
                    onToggle: () {
                      setState(() {
                        criterion
                            .updateDirectionIfCopied(criterion.nextDirection);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Tooltip(
                  message: 'Drag to change the priority order.',
                  child: Icon(
                    Icons.drag_handle,
                    color: SortPanelHelper.getIconColor(context, false),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
