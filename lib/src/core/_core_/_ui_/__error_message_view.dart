part of '../core.dart';

class ErrorMessageView extends StatelessWidget {
  final String message;

  const ErrorMessageView({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade700,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
