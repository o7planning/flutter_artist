part of '../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _UiComponentsDialog extends StatefulWidget {
  Shelf? shelf;
  Block? block;
  final bool showActiveOnly;

  _UiComponentsDialog.block({
    required Block this.block,
    this.showActiveOnly = true,
    super.key,
  });

  _UiComponentsDialog.shelf({
    required Shelf this.shelf,
    this.showActiveOnly = true,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _UiComponentsDialogState();
  }
}

class _UiComponentsDialogState extends State<_UiComponentsDialog> {
  static const double fontSize = 13;

  String _title() {
    if (widget.shelf != null) {
      return "Active UI Components in current screen";
    } else if (widget.block != null) {
      return "Mounted UI Components of the Block";
    } else {
      throw UnimplementedError();
    }
  }

  Map<_WidgetState, bool> _findWidgetStates() {
    if (widget.shelf != null) {
      return widget.shelf!._findMountedWidgetStates(
        activeOnly: true,
        withPagination: true,
        withBlockFragment: true,
        withFilter: true,
        withForm: true,
        withControlBar: true,
      );
    } else if (widget.block != null) {
      return widget.block!._findMountedWidgetStates(
        activeOnly: false,
        withPagination: true,
        withBlockFragment: true,
        withFilter: true,
        withForm: true,
        withControlBar: true,
      );
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    AlertDialog alert = CustomAlertDialog(
      titleText: _title(),
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(context),
      closeDialog: () {
        Navigator.of(context).pop();
      },
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    if (width > 520) {
      width = 500;
    } else {
      width = 0.9 * width;
    }
    if (height > 420) {
      height = 320;
    } else {
      height = height - 60;
    }
    //
    Map<_WidgetState, bool> widgetStates = _findWidgetStates();
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.block != null)
            _IconLabelText(
              label: "Block: ",
              text: "${getClassName(widget.block)} (${widget.block!.name})",
            ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                ...widgetStates.entries
                    .map(
                      (entry) => _buildRowInfo(
                        widgetStateEntry: entry,
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(WidgetStateType type) {
    switch (type) {
      case WidgetStateType.filter:
        return _dataFilterIconData;
      case WidgetStateType.controlBar:
        return _blockControlBarIconData;
      case WidgetStateType.customControlBar:
        return _blockCustomControlBarIconData;
      case WidgetStateType.form:
        return _blockFormIconData;
      case WidgetStateType.blockFragment:
        return _blockFragmentIconData;
      case WidgetStateType.pagination:
        return _paginationIconData;
      case WidgetStateType.loggedInUser:
        return _loggedUserIconData;
      case WidgetStateType.scalarFragment:
        return _scalarFragmentIconData;
      case WidgetStateType.shelfFragment:
        return _shelfFragmentIconData;
    }
  }

  Widget _buildRowInfo({
    required MapEntry<_WidgetState, bool> widgetStateEntry,
  }) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: CheckboxListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -3, horizontal: -3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
        controlAffinity: ListTileControlAffinity.trailing,
        value: widgetStateEntry.key.showMode == ShowMode.dev,
        secondary: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
            color: widgetStateEntry.value
                ? Colors.green.withAlpha(30)
                : Colors.grey[200],
          ),
          child: Icon(
            _getIconData(widgetStateEntry.key.type),
            size: 24,
          ),
        ),
        title: _IconLabelText(
          icon: const Icon(
            _locationIconData,
            size: 16,
          ),
          label: "",
          text: widgetStateEntry.key.locationInfo,
          style: const TextStyle(
            fontSize: fontSize,
          ),
        ),
        subtitle: _IconLabelText(
          label: '  ',
          text: widgetStateEntry.key.description,
          style: const TextStyle(
            fontSize: fontSize - 2,
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

Future<void> _showBlockUiComponentsDialog({
  required BuildContext context,
  required Block block,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _UiComponentsDialog.block(
        block: block,
      );
    },
  );
}

Future<void> _showActiveUiComponentsDialog({
  required BuildContext context,
  required Shelf shelf,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _UiComponentsDialog.shelf(
        shelf: shelf,
      );
    },
  );
}
