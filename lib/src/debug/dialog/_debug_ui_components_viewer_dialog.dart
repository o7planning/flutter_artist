import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_show_mode.dart';
import '../../core/enums/_tip_document.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '_tip_document_viewer_dialog.dart';

class DebugUiComponentsViewerDialog extends StatefulWidget {
  final Shelf? shelf;
  final Block? block;
  final Scalar? scalar;
  final bool showActiveOnly;

  const DebugUiComponentsViewerDialog.block({
    required Block this.block,
    this.showActiveOnly = true,
    super.key,
  })  : shelf = null,
        scalar = null;

  const DebugUiComponentsViewerDialog.scalar({
    required Scalar this.scalar,
    this.showActiveOnly = true,
    super.key,
  })  : shelf = null,
        block = null;

  const DebugUiComponentsViewerDialog.shelf({
    required Shelf this.shelf,
    this.showActiveOnly = true,
    super.key,
  })  : block = null,
        scalar = null;

  @override
  State<StatefulWidget> createState() {
    return _DebugUiComponentsViewerDialogState();
  }

  static Future<void> open({
    required BuildContext context,
    required Shelf shelf,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugUiComponentsViewerDialog.shelf(
          shelf: shelf,
        );
      },
    );
  }
}

class _DebugUiComponentsViewerDialogState
    extends State<DebugUiComponentsViewerDialog> {
  static const double fontSize = 13;

  String _title() {
    if (widget.shelf != null) {
      return "Active UI Components in current screen";
    } else if (widget.block != null) {
      return "Mounted UI Components of the Block";
    } else if (widget.scalar != null) {
      return "Mounted UI Components of the Scalar";
    } else {
      throw UnimplementedError();
    }
  }

  Map<IContextProviderViewState, XState> _findWidgetStates() {
    if (widget.shelf != null) {
      return widget.shelf!.ui.debugFindMountedWidgetStates(
        activeOnly: true,
        withPagination: true,
        withBlockFragment: true,
        withScalarFragment: true,
        withFilter: true,
        withSort: true,
        withForm: true,
        withBlockControlBar: true,
        withScalarControlBar: true,
        withControl: true,
      );
    } else if (widget.block != null) {
      return widget.block!.ui.debugFindMountedWidgetStates(
        activeOnly: false,
        withPagination: true,
        withBlockBaseView: true,
        withFilter: true,
        withSort: true,
        withForm: true,
        withBlockControlBar: true,
        withControl: true,
      );
    } else if (widget.scalar != null) {
      return widget.scalar!.ui.debugFindMountedWidgetStates(
        activeOnly: false,
        withPagination: true,
        withScalarBaseView: true,
        withFilter: true,
        withScalarControlBar: true,
      );
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    FaAlertDialog alert = FaAlertDialog(
      icon: Icon(
        FaIconConstants.uiComponentsIconData,
        size: 18,
      ),
      titleText: "Debug UI Components Viewer",
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(context),
      onHelpPressed: () {
        TipDocumentViewerDialog.open(
          context: context,
          tipDocument: TipDocument.debugUiComponentsViewer,
        );
      },
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context) {
    final size = calculatePreferredDialogSize(
      context,
      preferredWidth: 560,
      preferredHeight: 320,
    );
    //
    Map<IContextProviderViewState, XState> widgetStates = _findWidgetStates();
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.block != null)
            IconLabelText(
              label: "Block: ",
              text: "${getClassName(widget.block)} (${widget.block!.name})",
            ),
          if (widget.block != null) const SizedBox(height: 10),
          Text(_title()),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                ...widgetStates.entries.map(
                  (entry) => _buildRowInfo(
                    widgetStateEntry: entry,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInfo({
    required MapEntry<IContextProviderViewState, XState> widgetStateEntry,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isVisible = widgetStateEntry.value.isVisible;
    final bool isDevMode = widgetStateEntry.key.showMode == ShowMode.dev;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDevMode
              ? colorScheme.primary
              : theme.dividerColor.withValues(alpha: 0.1),
          width: 0.8,
        ),
      ),
      child: CheckboxListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        controlAffinity: ListTileControlAffinity.trailing,
        value: isDevMode,
        secondary: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isVisible
                ? colorScheme.primary.withValues(alpha: 0.15)
                : theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
            border: Border.all(
              color: isVisible
                  ? colorScheme.primary.withValues(alpha: 0.5)
                  : theme.dividerColor.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: Icon(
            widgetStateEntry.key.type.iconData,
            size: 22,
            color: isVisible ? colorScheme.primary : theme.hintColor,
          ),
        ),
        title: IconLabelText(
          icon: Icon(
            FaIconConstants.locationIconData,
            size: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          label: "",
          text: widgetStateEntry.key.locationInfo,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isDevMode ? FontWeight.bold : FontWeight.normal,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            widgetStateEntry.key.description,
            style: TextStyle(
              fontSize: fontSize - 2,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        onChanged: (bool? value) {
          widgetStateEntry.key.showMode =
              (value ?? false) ? ShowMode.dev : ShowMode.production;
          widgetStateEntry.key.setState(() {});
          setState(() {});
        },
      ),
    );
  }
}
