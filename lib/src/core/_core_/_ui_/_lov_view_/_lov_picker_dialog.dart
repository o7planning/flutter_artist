part of '../../core.dart';

/// Internal dialog return wrapper distinguishing "confirmed (possibly empty)"
/// from "cancelled" (`null` returned by `showDialog`).
class _LovDialogResult<ITEM extends Identifiable<Comparable>> {
  final List<ITEM> selectedItems;

  const _LovDialogResult({required this.selectedItems});
}

/// Internal modal dialog hosting an optional [FilterPanel], the primary [LovView],
/// an optional pagination bar, and confirmation actions inside a [FaDialog].
class _LovPickerDialog<ITEM extends Identifiable<Comparable>>
    extends StatelessWidget {
  final LovModel lovModel;
  final FilterPanel? filterPanel;
  final LovView lovView;
  final Widget? pagination;
  final LovFieldStyle style;

  const _LovPickerDialog({
    required this.lovModel,
    required this.filterPanel,
    required this.lovView,
    required this.pagination,
    required this.style,
  });

  static Future<_LovDialogResult<ITEM>?>
      show<ITEM extends Identifiable<Comparable>>({
    required BuildContext context,
    required LovModel lovModel,
    required FilterPanel? filterPanel,
    required LovView lovView,
    required Widget? pagination,
    required LovFieldStyle style,
  }) async {
    return await showDialog<_LovDialogResult<ITEM>>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return _LovPickerDialog<ITEM>(
          lovModel: lovModel,
          filterPanel: filterPanel,
          lovView: lovView,
          pagination: pagination,
          style: style,
        );
      },
    );
  }

  void _onConfirm(BuildContext context) {
    final List<ITEM> picked = lovModel.selectedItems.cast<ITEM>().toList();
    Navigator.of(context).pop(_LovDialogResult<ITEM>(selectedItems: picked));
  }

  void _onCancel(BuildContext context) {
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    final String effectiveTitle = style.dialogTitle ??
        style.labelText ??
        lovModel.description ??
        lovModel.name;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            _onCancel(context),
      },
      child: FaDialog(
        titleText: effectiveTitle,
        contentPadding: style.dialogContentPadding,
        preferredContentWidth: style.dialogWidth,
        preferredContentHeight: style.dialogHeight,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (filterPanel != null) ...[
              filterPanel!,
              const SizedBox(height: 8),
            ],
            Expanded(
              child: lovView,
            ),
            if (pagination != null) ...[
              const SizedBox(height: 6),
              pagination!,
            ],
            const Divider(height: 16),
            _buildFooterActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterActions(BuildContext context) {
    final bool isMulti = lovModel.selectionMode == LovSelectionMode.multiple;

    return Row(
      children: [
        if (isMulti)
          TextButton(
            onPressed: () => lovModel.clearSelection(),
            child: Text(style.clearSelectionButtonText),
          ),
        const Spacer(),
        TextButton(
          onPressed: () => _onCancel(context),
          child: Text(style.cancelButtonText),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _onConfirm(context),
          child: Text(style.confirmButtonText),
        ),
      ],
    );
  }
}
