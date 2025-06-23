part of '../../flutter_artist.dart';

class ErrorLogViewerDialog extends StatefulWidget {
  final String title;
  final ErrorLogger errorLogger;

  const ErrorLogViewerDialog({
    this.title = 'Error Viewer',
    required this.errorLogger,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _ErrorLogViewerDialogState();
  }
}

class _ErrorLogViewerDialogState extends State<ErrorLogViewerDialog> {
  ErrorInfo? _errorInfo;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _errorInfo = widget.errorLogger.lastError;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    if (width > 620) {
      width = 600;
    } else {
      width = 0.9 * width;
    }
    if (height > 420) {
      height = 320;
    } else {
      height = height - 100;
    }

    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      titleText: widget.title,
      content: _buildContent(width, height),
    );
    return alert;
  }

  Widget _buildErrorButtons() {
    return _CustomAppContainer(
      width: double.maxFinite,
      child: Wrap(
        spacing: 5,
        children: widget.errorLogger.errorInfos
            .map(
              (errorInfo) => TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  minimumSize: Size.zero,
                  backgroundColor: _errorInfo == errorInfo
                      ? Colors.blueGrey.withAlpha(80)
                      : Colors.blueGrey.withAlpha(30),
                ),
                onPressed: () {
                  _errorInfo = errorInfo;
                  setState(() {});
                },
                child: Text(errorInfo.id.toString()),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildExpansionTile({
    required IconData iconData,
    required String title,
    required String subtitle,
    required List<Widget> children,
    required bool initiallyExpanded,
    required int index,
  }) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        tilePadding: const EdgeInsets.all(0),
        dense: true,
        visualDensity: const VisualDensity(
          vertical: -3,
          horizontal: -3,
        ),
        backgroundColor: Colors.black12,
        collapsedBackgroundColor: Colors.black12,
        leading: Icon(
          iconData,
          size: 18,
        ),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        children: children,
        onExpansionChanged: (bool expanded) {
          if (expanded) {
            selectedIndex = index;
          } else {
            selectedIndex = -1;
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildErrorDetails() {
    return Column(
      children: [
        if (_errorInfo != null)
          _buildExpansionTile(
            iconData: _infoIconData,
            title: _errorInfo!.message,
            subtitle: "Shelf: ${_errorInfo!.shelfName}",
            index: 0,
            initiallyExpanded: true,
            children: _errorInfo!.errorDetails == null
                ? []
                : _errorInfo!.errorDetails!
                    .map((errorDetail) => _buildErrorDetail(errorDetail))
                    .toList(),
          ),
        if (_errorInfo != null && _errorInfo!.stackTrace != null)
          const SizedBox(height: 5),
        if (_errorInfo != null && _errorInfo!.stackTrace != null)
          Expanded(
            child: _CustomAppContainer(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Text(
                  _errorInfo!.stackTrace.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorDetail(String errorDetail) {
    return Material(
      child: ListTile(
        tileColor: Colors.white,
        dense: true,
        visualDensity: const VisualDensity(
          vertical: -3,
          horizontal: -3,
        ),
        contentPadding: const EdgeInsets.all(0),
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(
            _listItemBulletIconData,
            color: Colors.black,
            size: 16,
          ),
        ),
        title: Text(
          errorDetail,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildContent(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildErrorButtons(),
          const Divider(),
          Expanded(
            child: _buildErrorDetails(),
          ),
        ],
      ),
    );
  }
}

Future<void> _showErrorLogViewerDialog({
  required BuildContext context,
  required ErrorLogger errorLogger,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ErrorLogViewerDialog(
        errorLogger: errorLogger,
      );
    },
  );
}
