import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_enums.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/__utils.dart';

import '_tip_document_viewer_dialog.dart';

class DebugUiContextInspectorDialog extends StatefulWidget {
  final Shelf? shelf;
  final Block? block;
  final Scalar? scalar;

  final Activity? activity;
  final Prozess? prozess;
  final Stage? stage;
  final Task? task;
  final bool showActiveOnly;

  const DebugUiContextInspectorDialog.module({
    required FeatureModule module,
    this.showActiveOnly = true,
    super.key,
  })  : shelf = module is Shelf ? module : null,
        block = null,
        scalar = null,
        activity = module is Activity ? module : null,
        prozess = null,
        stage = null,
        task = null;

  const DebugUiContextInspectorDialog.shelf({
    required Shelf this.shelf,
    this.showActiveOnly = true,
    super.key,
  })  : block = null,
        scalar = null,
        activity = null,
        prozess = null,
        stage = null,
        task = null;

  const DebugUiContextInspectorDialog.block({
    required Block this.block,
    this.showActiveOnly = true,
    super.key,
  })  : shelf = null,
        scalar = null,
        activity = null,
        prozess = null,
        stage = null,
        task = null;

  const DebugUiContextInspectorDialog.scalar({
    required Scalar this.scalar,
    this.showActiveOnly = true,
    super.key,
  })  : shelf = null,
        block = null,
        activity = null,
        prozess = null,
        stage = null,
        task = null;

  @override
  State<StatefulWidget> createState() {
    return _DebugUiContextInspectorDialogState();
  }

  static Future<void> show({
    required BuildContext context,
    required FeatureModule module,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugUiContextInspectorDialog.module(
          module: module,
        );
      },
    );
  }
}

class _DebugUiContextInspectorDialogState
    extends State<DebugUiContextInspectorDialog> {
  static const double fontSize = 13;

  String _title() {
    if (widget.shelf != null) {
      return "Mounted UI Components of the Block";
    } else if (widget.block != null) {
      return "Mounted UI Components of the Block";
    } else if (widget.scalar != null) {
      return "Mounted UI Components of the Scalar";
    } else if (widget.activity != null) {
      return "Mounted UI Components of the Activity";
    } else if (widget.task != null) {
      return "Mounted UI Components of the Task";
    } else if (widget.prozess != null) {
      return "Mounted UI Components of the Prozess";
    } else {
      throw UnimplementedError("DebugUiContextInspectorDialog _title");
    }
  }

  Map<IContextProviderViewState, XState> _debugFindWidgetStates() {
    // SHELF
    if (widget.shelf != null) {
      return widget.shelf!.ui.debug.findAllMountedWidgetStates();
    } else if (widget.block != null) {
      return widget.block!.ui.debug.findAllMountedWidgetStates();
    } else if (widget.scalar != null) {
      return widget.scalar!.ui.debug.findAllMountedWidgetStates();
    } else if (widget.scalar != null) {
      return widget.scalar!.ui.debug.findAllMountedWidgetStates();
    }
    // ACTIVITY
    else if (widget.activity != null) {
      return widget.activity!.ui.debug.findAllMountedWidgetStates();
    } else if (widget.prozess != null) {
      return widget.prozess!.ui.debug.findAllMountedWidgetStates();
    } else if (widget.stage != null) {
      return widget.stage!.ui.debug.findAllMountedWidgetStates();
    } else if (widget.task != null) {
      return widget.task!.ui.debug.findAllMountedWidgetStates();
    }
    // OTHERS
    else {
      throw UnimplementedError(
          "DebugUiContextInspectorDialog._findWidgetStates");
    }
  }

  @override
  Widget build(BuildContext context) {
    FaDialog alert = FaDialog(
      iconData: FaIconConstants.uiComponentsIconData,
      titleText: "Debug UI Context Inspector",
      preferredContentWidth: 560,
      preferredContentHeight: 320,
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(context),
      onHelpPressed: () {
        TipDocumentViewerDialog.show(
          context: context,
          tipDocument: TipDocument.debugUiContextInspector,
        );
      },
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context) {
    Map<IContextProviderViewState, XState> widgetStates =
        _debugFindWidgetStates();
    return Column(
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
    );
  }

  Widget _buildRowInfo({
    required final MapEntry<IContextProviderViewState, XState> widgetStateEntry,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final IContextProviderViewState key = widgetStateEntry.key;
    final bool isVisible = widgetStateEntry.value.isVisible;
    final bool isDevMode = key.showMode == ShowMode.dev;

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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
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
      ),
    );
  }
}
