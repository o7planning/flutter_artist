part of '../core.dart';

class TaskRestartConfirmDialog extends StatelessWidget {
  final Task task;

  const TaskRestartConfirmDialog({
    super.key,
    required this.task,
  });

  /// Displays the restart confirmation dialog and returns true if confirmed.
  static Future<bool> show({
    required BuildContext context,
    required Task task,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TaskRestartConfirmDialog(
        task: task,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color actionColor = colorScheme.error;

    return FaDialog(
      titleText: "Restart Task",
      iconData: Icons.warning_amber_rounded,
      iconColor: actionColor,
      preferredContentWidth: 400,
      preferredContentHeight: null,
      content: Text(
        task.restartConfirmMessage,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            "Cancel",
            style: TextStyle(color: colorScheme.secondary),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: actionColor,
            foregroundColor: colorScheme.onError,
            elevation: 0,
          ),
          child: const Text("Confirm Restart"),
        ),
      ],
    );
  }
}
