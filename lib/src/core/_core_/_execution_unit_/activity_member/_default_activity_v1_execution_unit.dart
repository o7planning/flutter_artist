part of '../../core.dart';

class _DefaultActivityV1ExecutionUnit extends _ActivityV1MemberExecutionUnit {
  @override
  final DefaultActivityV1ExecutionIntent executionIntent;

  _DefaultActivityV1ExecutionUnit({
    required super.xActivityV1,
    required this.executionIntent,
  }) : super(
          executionIntent: executionIntent,
        );
}
