part of '../../flutter_artist.dart';

class ErrorViewerDialog extends StatefulWidget {
  final String title;
  final dynamic error;

  const ErrorViewerDialog({
    required this.title,
    required this.error,
    super.key,
  });

  @override
  State<cupertino.StatefulWidget> createState() {
    return _ErrorViewerDialog();
  }
}

class _ErrorViewerDialog extends State<ErrorViewerDialog> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToSelectedContent(
      bool isExpanded, double previousOffset, int index, GlobalKey myKey) {
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      // make sure that your widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      _scrollController.animateTo(
          isExpanded ? (box.size.height * index) : previousOffset,
          duration: Duration(milliseconds: 500),
          curve: Curves.linear);
    }
  }

  @override
  Widget build(BuildContext context) {
    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      titleText: widget.title,
      contentPadding: EdgeInsets.all(8),
      content: _buildContent(context),
    );
    return alert;
  }

  Widget _buildContent(BuildContext context) {
    AppException? exception = ErrorUtils.toAppException(widget.error);
    //
    final Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 440,
      preferredHeight: exception == null ||
              exception!.details == null ||
              exception!.details!.isEmpty
          ? 160
          : 240,
    );

    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            visualDensity: const VisualDensity(
              vertical: -3,
              horizontal: -3,
            ),
            contentPadding: EdgeInsets.all(0),
            horizontalTitleGap: 5,
            minVerticalPadding: 5,
            minLeadingWidth: 24,
            minTileHeight: 0,
            titleAlignment: ListTileTitleAlignment.top,
            leading: Icon(
              _dataStateErrorIconData,
              size: 18,
              color: Colors.red,
            ),
            title: Text(
              exception?.message ?? "null",
              maxLines: 3,
              style: const TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (exception != null &&
              exception!.details != null &&
              exception!.details!.isNotEmpty)
            Divider(height: 10),
          Expanded(
            child: ListView(
              children: exception != null &&
                      exception!.details != null &&
                      exception!.details!.isNotEmpty
                  ? exception!.details!
                      .map((errorDetail) => _buildErrorDetail(errorDetail))
                      .toList()
                  : [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorDetail(String errorDetail) {
    return ListTile(
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
    );
  }
}

Future<void> _showErrorViewerDialog({
  required BuildContext context,
  required String title,
  required dynamic error,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ErrorViewerDialog(
        title: title,
        error: error,
      );
    },
  );
}
