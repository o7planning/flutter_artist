part of '../../flutter_artist.dart';

class ErrorViewerDialog extends StatelessWidget {
  final String title;
  final dynamic error;

  const ErrorViewerDialog({
    required this.title,
    required this.error,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      titleText: title,
      contentPadding: EdgeInsets.all(5),
      content: _buildContent(context),
    );
    return alert;
  }

  Widget _buildContent(BuildContext context) {
    AppException? exception = ErrorUtils.toAppException(error);
    //
    final Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 380,
      preferredHeight: exception == null ||
              exception!.details == null ||
              exception!.details!.isEmpty
          ? 160
          : 240,
    );

    return SizedBox(
      height: size.height,
      width: size.width,
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          initiallyExpanded: true,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          tilePadding: const EdgeInsets.all(0),
          dense: true,
          visualDensity: const VisualDensity(
            vertical: -3,
            horizontal: -3,
          ),
          leading: Icon(
            _dataStateErrorIconData,
            size: 18,
          ),
          title: Text(
            exception?.message ?? "null",
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          children: exception == null ||
                  exception!.details == null ||
                  exception!.details!.isEmpty
              ? []
              : exception!.details!
                  .map((errorDetail) => _buildErrorDetail(errorDetail))
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildErrorDetail(String errorDetail) {
    return ListTile(
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
