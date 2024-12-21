part of '../flutter_artist.dart';

class _CustomAlertDialog extends AlertDialog {
  final String titleText;
  final Function()? closeDialog;

  _CustomAlertDialog({
    super.key,
    super.icon,
    super.iconPadding,
    super.iconColor,
    required this.titleText,
    super.content,
    super.contentTextStyle,
    super.actions,
    super.actionsAlignment,
    super.actionsOverflowAlignment,
    super.actionsOverflowDirection,
    super.actionsOverflowButtonSpacing,
    super.buttonPadding,
    super.contentPadding = const EdgeInsets.fromLTRB(20, 10, 20, 10),
    super.backgroundColor,
    super.elevation,
    super.shadowColor,
    super.surfaceTintColor,
    super.semanticLabel,
    super.insetPadding,
    super.clipBehavior,
    super.alignment,
    super.scrollable = false,
    this.closeDialog,
  }) : super(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          titlePadding: const EdgeInsets.all(0),
          actionsPadding: const EdgeInsets.all(10),
          titleTextStyle: const TextStyle(fontSize: 16),
          title: Container(
            padding: const EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 240, 244, 248),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    titleText,
                    style: const TextStyle(
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                if (closeDialog != null) const SizedBox(width: 5),
                if (closeDialog != null)
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {
                      closeDialog();
                    },
                    child: Icon(
                      _dialogCloseIconData,
                      color: Colors.red.withAlpha(180),
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        );
}
