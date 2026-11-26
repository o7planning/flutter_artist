part of '../_built_in_ui.dart';

/// Built-in, zero-dependency tabular [LovView] powered by a sticky header
/// and a virtualized [ListView.builder].
///
/// Supports two usage styles:
/// 1. **Inline**: Pass [columns] directly into the constructor.
/// 2. **Reusable subclass**: Extend [DefaultLovView] and override [defineColumns].
class DefaultLovView<ITEM extends Identifiable<Comparable>>
    extends LovView<LovModel<Comparable, ITEM, FilterPatch, FilterCriteria>> {
  final List<LovColumn<ITEM>>? columns;
  final double headerHeight;
  final double rowHeight;
  final String emptyText;

  /// Optional callback invoked when a row is double-tapped (e.g., quick confirm
  /// in [LovSelectionMode.single]).
  final void Function(BuildContext context, ITEM item)? onRowDoubleTap;

  const DefaultLovView({
    super.key,
    required super.lovModel,
    this.columns,
    this.headerHeight = 34,
    this.rowHeight = 36,
    this.emptyText = 'No items found.',
    this.onRowDoubleTap,
    super.config,
  });

  /// Override in subclasses to declare reusable column definitions.
  @protected
  List<LovColumn<ITEM>> defineColumns() => const [];

  List<LovColumn<ITEM>> get _effectiveColumns => columns ?? defineColumns();

  bool get _isMulti => lovModel.selectionMode == LovSelectionMode.multiple;

  @override
  Widget buildContent(BuildContext context) {
    final List<LovColumn<ITEM>> cols = _effectiveColumns;
    if (cols.isEmpty) {
      return const ErrorMessageView(
        message: 'DefaultLovView requires at least one LovColumn '
            '(via constructor `columns` or overriding `defineColumns()`).',
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.faColors.divider.subtle),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          _buildHeaderRow(context, cols),
          if (lovModel.isQuerying)
            const LinearProgressIndicator(minHeight: 2)
          else
            Divider(
                height: 1,
                thickness: 1,
                color: context.faColors.divider.subtle),
          Expanded(
            child: _buildBody(context, cols),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context, List<LovColumn<ITEM>> cols) {
    final bool allVisibleSelected = _isMulti &&
        lovModel.isNotEmpty &&
        lovModel.items.every((item) => lovModel.isSelectedItem(item));

    return Container(
      height: headerHeight,
      color: context.faColors.bar.strong,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          if (_isMulti)
            SizedBox(
              width: 36,
              child: Checkbox(
                value: allVisibleSelected,
                visualDensity: VisualDensity.compact,
                onChanged: lovModel.isEmpty
                    ? null
                    : (bool? checked) {
                        if (checked == true) {
                          lovModel.selectAllItems();
                        } else {
                          for (final item in lovModel.items) {
                            lovModel.setSelectedItem(item, selected: false);
                          }
                        }
                      },
              ),
            ),
          ...cols.map((col) => _wrapColumnBox(
                col: col,
                child: Align(
                  alignment: col.alignment,
                  child: Text(
                    col.title,
                    style: col.headerStyle ??
                        const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<LovColumn<ITEM>> cols) {
    final List<ITEM> items = lovModel.items;

    if (items.isEmpty) {
      if (lovModel.isQuerying) {
        return const Center(child: CircularProgressIndicator());
      }
      return Center(
        child: Text(
          emptyText,
          style: TextStyle(color: context.faColors.ink.secondary),
        ),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        thickness: 0.5,
        color: context.faColors.divider.subtle,
      ),
      itemBuilder: (BuildContext context, int index) {
        final ITEM item = items[index];
        final bool selected = lovModel.isSelectedItem(item);
        return _buildDataRow(
          context: context,
          cols: cols,
          item: item,
          selected: selected,
        );
      },
    );
  }

  Widget _buildDataRow({
    required BuildContext context,
    required List<LovColumn<ITEM>> cols,
    required ITEM item,
    required bool selected,
  }) {
    return Material(
      color: selected
          ? context.faColors.surface.item.selected
          : context.faColors.surface.item,
      child: InkWell(
        onTap: () {
          if (_isMulti) {
            lovModel.toggleSelectItem(item);
          } else {
            lovModel.setSelectedItem(item, selected: true);
          }
        },
        onDoubleTap: () {
          if (!_isMulti) {
            lovModel.setSelectedItem(item, selected: true);
          }
          onRowDoubleTap?.call(context, item);
        },
        child: Container(
          height: rowHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              if (_isMulti)
                SizedBox(
                  width: 36,
                  child: Checkbox(
                    value: selected,
                    visualDensity: VisualDensity.compact,
                    onChanged: (bool? checked) {
                      lovModel.setSelectedItem(item, selected: checked == true);
                    },
                  ),
                ),
              ...cols.map((col) => _wrapColumnBox(
                    col: col,
                    child: Align(
                      alignment: col.alignment,
                      child: col.cellBuilder != null
                          ? col.cellBuilder!(context, item)
                          : Text(
                              col.valueGetter!(item),
                              style: col.cellStyle ??
                                  const TextStyle(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wrapColumnBox({
    required LovColumn<ITEM> col,
    required Widget child,
  }) {
    final Widget padded = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: child,
    );
    if (col.width != null) {
      return SizedBox(width: col.width, child: padded);
    }
    return Expanded(flex: col.flex, child: padded);
  }
}
