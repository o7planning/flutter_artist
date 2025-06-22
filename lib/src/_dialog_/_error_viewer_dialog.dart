part of '../../flutter_artist.dart';

class ErrorViewerDialog extends StatelessWidget {
  final dynamic error;

  const ErrorViewerDialog({
    required this.error,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 320,
      preferredHeight: 200,
    );

    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      titleText: "Error Information",
      content: _buildContent(size.width, size.height),
    );
    return alert;
  }

  Widget _buildContent(double width, double height) {
    return Text("TODO");
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
      ),
    );
  }
}

Future<void> _showErrorViewerDialog({
  required BuildContext context,
  required dynamic error,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ErrorViewerDialog(
        error: error,
      );
    },
  );
}
