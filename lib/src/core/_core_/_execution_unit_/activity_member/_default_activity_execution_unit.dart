part of '../../core.dart';

class _DefaultActivityExecutionUnit extends _ActivityMemberExecutionUnit {
  @override
  final DefaultActivityExecutionIntent executionIntent;

  _DefaultActivityExecutionUnit({
    required super.xActivity,
    required this.executionIntent,
  }) : super(
          executionIntent: executionIntent,
        );
}
