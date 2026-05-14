part of '../../core.dart';

abstract class _BaseControlBarState<OWNER extends Object,
        ITEM_TYPE extends Enum, W extends BaseControlBar<OWNER, ITEM_TYPE>>
    extends _ContextProviderViewState<W> {
  Decoration _getEffectiveDecoration(BuildContext context) {
    return widget.style.decoration ??
        BoxDecoration(
          color: context.faColors.bar.strong,
          borderRadius: BorderRadius.circular(8),
        );
  }

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      padding: widget.style.padding,
      height: widget.style.height,
      decoration: _getEffectiveDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.leftItems.isNotEmpty)
            _buildDecoratedGroup(widget.leftItems),
          const Spacer(),
          if (widget.rightItems.isNotEmpty)
            _buildDecoratedGroup(widget.rightItems),
        ],
      ),
    );
  }

  Widget _buildVerticalSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.style.itemSpacing),
      child: SizedBox(
        height: widget.style.dividerHeight,
        width: widget.style.dividerThickness,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.style.dividerColor ?? context.faColors.divider.subtle,
          ),
        ),
      ),
    );
  }

  Widget _buildDecoratedGroup(List<ControlBarItem<OWNER, ITEM_TYPE>> items) {
    final children = _buildItemGroup(items);
    if (children.isEmpty) return const SizedBox();

    return Container(
      decoration: widget.style.groupDecoration,
      padding: widget.style.groupPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  List<Widget> _buildItemGroup(List<ControlBarItem<OWNER, ITEM_TYPE>> items) {
    List<Widget?> rawWidgets = items.map((item) {
      if (item.type == BlockControlBarItemType.divider) {
        return const VerticalDivider(key: ValueKey('__divider_marker__'));
      }
      if (item.type == BlockControlBarItemType.custom &&
          item.customWidget != null) {
        return item.customWidget;
      }
      return buildStandardButton(item);
    }).toList();

    List<Widget> visibleWidgets = rawWidgets.whereType<Widget>().toList();
    if (visibleWidgets.isEmpty) return [];

    List<Widget> finalWidgets = [];

    for (int i = 0; i < visibleWidgets.length; i++) {
      Widget current = visibleWidgets[i];
      bool isCurrentDivider = _isDividerMarker(current);

      if (isCurrentDivider) {
        if (finalWidgets.isEmpty || i == visibleWidgets.length - 1) continue;
        if (_isSeparator(finalWidgets.last)) continue;
        finalWidgets.add(_buildVerticalSeparator());
        continue;
      }
      if (finalWidgets.isNotEmpty && !_isSeparator(finalWidgets.last)) {
        finalWidgets.add(SizedBox(width: widget.style.itemSpacing));
      }
      finalWidgets.add(current);
    }
    while (finalWidgets.isNotEmpty && _isSeparator(finalWidgets.last)) {
      finalWidgets.removeLast();
    }

    return finalWidgets;
  }

  bool _isSeparator(Widget widget) {
    if (widget is Padding && widget.child is SizedBox) {
      return true;
    }
    if (widget is VerticalDivider) return true;
    return false;
  }

  bool _isDividerMarker(Widget widget) {
    return widget is VerticalDivider &&
        widget.key == const ValueKey('__divider_marker__');
  }

  Widget? buildStandardButton(ControlBarItem<OWNER, ITEM_TYPE> item);
}
