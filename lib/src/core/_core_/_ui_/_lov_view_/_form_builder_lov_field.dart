part of '../../core.dart';

/// Closed, self-contained FormBuilder field integrating a [LovView], an optional
/// [FilterPanel], and a built-in [FaDialog] picker.
///
/// Supports both [LovSelectionMode.single] (emitting `ITEM?`) and
/// [LovSelectionMode.multiple] (emitting `List<ITEM>?`), automatically adapting
/// to [lovView.lovModel.selectionMode].
///
/// ### Minimal Usage:
/// ```dart
/// FormBuilderLovField<CountryInfo>(
///   name: 'country',
///   filterPanel: CountryLovFilterPanel(filterModel: lovModel.filterModel!),
///   lovView: CountryLovView(lovModel: lovModel),
///   itemToString: (item) => item.nameInEnglish,
///   style: const LovFieldStyle(labelText: 'Country'),
/// )
/// ```
final class FormBuilderLovField<ITEM extends Identifiable<Comparable>>
    extends StatelessWidget {
  /// Form field name registered with the enclosing [FormBuilder].
  final String name;

  /// Optional [FilterPanel] rendered at the top of the LOV dialog.
  /// Must bind to the exact same [FilterModel] owned by [lovView.lovModel].
  final FilterPanel? filterPanel;

  /// Primary [LovView] rendered inside the LOV dialog.
  final LovView lovView;

  /// Optional pagination bar rendered below [lovView] inside the LOV dialog.
  final Widget? pagination;

  /// Visual and dialog layout configuration.
  final LovFieldStyle style;

  /// Formats an [ITEM] into its display label inside the field.
  /// Falls back to `item.toString()` if omitted.
  final String Function(ITEM item)? itemToString;

  /// Whether user interaction is enabled for this field.
  final bool enabled;

  /// Optional validator compatible with both single (`ITEM?`) and multi (`List<ITEM>?`) modes.
  final FormFieldValidator<dynamic>? validator;

  /// Controls validation timing for this field.
  final AutovalidateMode? autovalidateMode;

  /// Optional callback fired after the user confirms a selection in the LOV dialog
  /// (useful for Oracle Forms-style multi-field return mapping via `formModel.patchPropValue`).
  final void Function(List<ITEM> selectedItems)? onSelected;

  const FormBuilderLovField({
    super.key,
    required this.name,
    this.filterPanel,
    required this.lovView,
    this.pagination,
    this.style = const LovFieldStyle(),
    this.itemToString,
    this.enabled = true,
    this.validator,
    this.autovalidateMode,
    this.onSelected,
  });

  LovModel get _lovModel => lovView.lovModel;

  /// Validates structural consistency between [filterPanel], [lovView], and [ITEM].
  /// Returns an error message if misconfigured, or `null` if valid.
  String? _validateConfiguration() {
    final LovModel lovModel = _lovModel;

    // 1. Validate FilterPanel <-> LovModel ownership
    if (filterPanel != null) {
      final FilterModel? ownedFilter = lovModel.filterModel;
      if (ownedFilter == null) {
        return "Configuration Error in FormBuilderLovField('$name'): "
            "FilterPanel '${getClassNameWithoutGenerics(
            filterPanel)}' was provided, "
            "but LovModel '${lovModel.name}' (${getClassNameWithoutGenerics(
            lovModel)}) "
            "does not own a FilterModel.";
      }
      if (!identical(filterPanel!.filterModel, ownedFilter)) {
        return "Configuration Error in FormBuilderLovField('$name'): "
            "Mismatched FilterPanel and LovView. "
            "FilterPanel is bound to '${getClassNameWithoutGenerics(
            filterPanel!.filterModel)}', "
            "while LovModel '${lovModel
            .name}' owns '${getClassNameWithoutGenerics(ownedFilter)}'.";
      }
    }

    // 2. Validate generic ITEM compatibility (when explicitly typed)
    if (ITEM != Identifiable &&
        ITEM != dynamic &&
        lovModel.getItemType() != ITEM) {
      return "Configuration Error in FormBuilderLovField('$name'): "
          "Generic type '$ITEM' does not match LovModel '${lovModel.name}' "
          "item type '${lovModel.getItemType()}'.";
    }

    return null;
  }

  String _formatItem(ITEM item) {
    return itemToString != null ? itemToString!(item) : item.toString();
  }

  InputDecoration _buildEffectiveDecoration({
    required BuildContext context,
    required String? errorText,
    required bool isEmpty,
    required bool isEnabled,
    required VoidCallback? onClear,
    required VoidCallback? onOpenDialog,
  }) {
    final InputDecoration base = style.decoration ??
        InputDecoration(
          labelText: style.labelText,
          hintText: style.hintText,
          helperText: style.helperText,
          border: const OutlineInputBorder(),
          isDense: true,
        );

    final Widget suffixControls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (style.showClearButton && !isEmpty && isEnabled)
          IconButton(
            icon: Icon(style.clearIconData, size: 18),
            tooltip: style.clearTooltip,
            visualDensity: VisualDensity.compact,
            onPressed: onClear,
          ),
        IconButton(
          icon: Icon(style.triggerIconData, size: 18),
          tooltip: style.triggerTooltip,
          visualDensity: VisualDensity.compact,
          onPressed: isEnabled ? onOpenDialog : null,
        ),
      ],
    );

    return base.copyWith(
      labelText: base.labelText ?? style.labelText,
      hintText: base.hintText ?? style.hintText,
      helperText: base.helperText ?? style.helperText,
      errorText: errorText,
      enabled: isEnabled,
      suffixIcon: suffixControls,
    );
  }

  Future<void> _openLovDialog({
    required BuildContext context,
    required List<ITEM> initialSelection,
    required void Function(List<ITEM> confirmedItems) onConfirmed,
  }) async {
    // Sync current Form value into LovModel before opening the dialog.
    _lovModel.initSelection(initialSelection);

    final _LovDialogResult<ITEM>? result = await _LovPickerDialog.show<ITEM>(
      context: context,
      lovModel: _lovModel,
      filterPanel: filterPanel,
      lovView: lovView,
      pagination: pagination,
      style: style,
    );

    if (result != null) {
      onConfirmed(result.selectedItems);
      onSelected?.call(result.selectedItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? configError = _validateConfiguration();
    if (configError != null) {
      return ErrorMessageView(message: configError);
    }

    if (_lovModel.selectionMode == LovSelectionMode.single) {
      return _buildSingleSelectionField(context);
    }
    return _buildMultiSelectionField(context);
  }

  // ---------------------------------------------------------------------------
  // SINGLE SELECTION FIELD (Form value: ITEM?)
  // ---------------------------------------------------------------------------

  Widget _buildSingleSelectionField(BuildContext context) {
    return FormBuilderFieldDecoration<ITEM>(
      name: name,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      validator: validator != null ? (ITEM? value) => validator!(value) : null,
      builder: (FormFieldState<ITEM> field) {
        final state = field as FormBuilderFieldDecorationState<
            FormBuilderFieldDecoration<ITEM>,
            ITEM>;
        final ITEM? currentValue = state.value;
        final bool isEnabled = state.enabled;

        void triggerOpen() {
          if (!isEnabled) return;
          _openLovDialog(
            context: context,
            initialSelection: currentValue != null ? [currentValue] : const [],
            onConfirmed: (List<ITEM> items) {
              field.didChange(items.firstOrNull);
            },
          );
        }

        void triggerClear() {
          if (!isEnabled) return;
          field.didChange(null);
          onSelected?.call(const []);
        }

        return Focus(
          focusNode: state.effectiveFocusNode,
          onKeyEvent: (node, event) =>
              _handleFieldKeyEvent(
                event: event,
                isEnabled: isEnabled,
                onOpen: triggerOpen,
              ),
          child: InkWell(
            onTap: isEnabled ? triggerOpen : null,
            child: InputDecorator(
              isFocused: state.effectiveFocusNode.hasFocus,
              isEmpty: currentValue == null,
              decoration: _buildEffectiveDecoration(
                context: context,
                errorText: state.errorText,
                isEmpty: currentValue == null,
                isEnabled: isEnabled,
                onClear: triggerClear,
                onOpenDialog: triggerOpen,
              ),
              child: Text(
                currentValue != null ? _formatItem(currentValue) : '',
                style: style.textStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // MULTI SELECTION FIELD (Form value: List<ITEM>?)
  // ---------------------------------------------------------------------------

  Widget _buildMultiSelectionField(BuildContext context) {
    return FormBuilderFieldDecoration<List<ITEM>>(
      name: name,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      validator:
      validator != null ? (List<ITEM>? value) => validator!(value) : null,
      builder: (FormFieldState<List<ITEM>> field) {
        final state = field as FormBuilderFieldDecorationState<
            FormBuilderFieldDecoration<List<ITEM>>,
            List<ITEM>>;
        final List<ITEM> currentItems = state.value ?? const [];
        final bool isEmpty = currentItems.isEmpty;
        final bool isEnabled = state.enabled;

        void triggerOpen() {
          if (!isEnabled) return;
          _openLovDialog(
            context: context,
            initialSelection: currentItems,
            onConfirmed: (List<ITEM> items) {
              field.didChange(items.isEmpty ? null : List<ITEM>.from(items));
            },
          );
        }

        void triggerClear() {
          if (!isEnabled) return;
          field.didChange(null);
          onSelected?.call(const []);
        }

        void removeSingleItem(ITEM target) {
          if (!isEnabled) return;
          final List<ITEM> updated =
          currentItems.where((it) => it.id != target.id).toList();
          field.didChange(updated.isEmpty ? null : updated);
          onSelected?.call(updated);
        }

        return Focus(
          focusNode: state.effectiveFocusNode,
          onKeyEvent: (node, event) =>
              _handleFieldKeyEvent(
                event: event,
                isEnabled: isEnabled,
                onOpen: triggerOpen,
              ),
          child: InkWell(
            onTap: isEnabled ? triggerOpen : null,
            child: InputDecorator(
              isFocused: state.effectiveFocusNode.hasFocus,
              isEmpty: isEmpty,
              decoration: _buildEffectiveDecoration(
                context: context,
                errorText: state.errorText,
                isEmpty: isEmpty,
                isEnabled: isEnabled,
                onClear: triggerClear,
                onOpenDialog: triggerOpen,
              ),
              child: _buildMultiValueDisplay(
                items: currentItems,
                isEnabled: isEnabled,
                onRemoveItem: removeSingleItem,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMultiValueDisplay({
    required List<ITEM> items,
    required bool isEnabled,
    required void Function(ITEM item) onRemoveItem,
  }) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    if (style.multiDisplayMode == LovMultiDisplayMode.joinedText) {
      return Text(
        items.map(_formatItem).join(style.multiSeparator),
        style: style.textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Wrap(
      spacing: style.chipSpacing,
      runSpacing: style.chipRunSpacing,
      children: items
          .map(
            (ITEM item) =>
            Chip(
              label: Text(_formatItem(item), style: style.textStyle),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onDeleted: isEnabled ? () => onRemoveItem(item) : null,
            ),
      )
          .toList(),
    );
  }

  /// Opens the LOV dialog via Oracle Forms-inspired keyboard shortcuts
  /// (`F9` or `Enter`) when this field holds keyboard focus.
  KeyEventResult _handleFieldKeyEvent({
    required KeyEvent event,
    required bool isEnabled,
    required VoidCallback onOpen,
  }) {
    if (!isEnabled || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final LogicalKeyboardKey key = event.logicalKey;
    if (key == LogicalKeyboardKey.f9 || key == LogicalKeyboardKey.enter) {
      onOpen();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
