import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_artist/src/core/error/_task_error_info.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskRestartPrecheckUtils.checkBeforeRestart', () {
    // =========================================================================
    // 1. Kiểm tra trạng thái hệ thống (Busy Check)
    // =========================================================================
    test('Should return [busy] when checkBusy=true and isBusy=true', () {
      final result = TaskRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: true,
        isBusy: true,
        checkAllow: true,
        taskDataState: const TaskDataStatePending.initial(),
        isReexecutionAllowed: true,
        checkRestartAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, TaskRestartPrecheck.busy);
    });

    test('Should bypass busy check when checkBusy=false even if isBusy=true',
        () {
      final result = TaskRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: false,
        isBusy: true,
        checkAllow: true,
        taskDataState: const TaskDataStatePending.initial(),
        isReexecutionAllowed: true,
        checkRestartAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isTrue);
    });

    // =========================================================================
    // 2. Kiểm tra Bypass khi Task đang ở trạng thái Pending hoặc Stale
    // =========================================================================
    test('Should return [yes] automatically when TaskDataState is Pending', () {
      final result = TaskRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        taskDataState: const TaskDataStatePending.initial(),
        // isReexecutionAllowed là false nhưng vẫn pass vì state là Pending
        isReexecutionAllowed: false,
        checkRestartAllowed: () =>
            CheckAllowResult.notAllowed(), // Bỏ qua checkAllow
      );

      expect(result.yes, isTrue);
    });

    test('Should return [yes] automatically when TaskDataState is Stale', () {
      final result = TaskRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        taskDataState: TaskDataStateLoadedStale(staleErrorInfo: null),
        isReexecutionAllowed: false,
        checkRestartAllowed: () => CheckAllowResult.notAllowed(),
      );

      expect(result.yes, isTrue);
    });

    // =========================================================================
    // 3. Kiểm tra khóa cấu hình động (isReexecutionAllowed = false)
    // =========================================================================
    test(
        'Should return [restrictedBySubmitted] if isReexecutionAllowed=false and state is Success',
        () {
      final result = TaskRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        taskDataState: TaskDataStateSubmissionAttemptedSuccess(),
        isReexecutionAllowed: false, // Bị khóa
        checkRestartAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, TaskRestartPrecheck.restrictedBySubmitted);
    });

    test(
        'Should return [reloadRestrictedByConfig] if isReexecutionAllowed=false and state is Fresh',
        () {
      final result = TaskRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        taskDataState: const TaskDataStateLoadedFresh(),
        isReexecutionAllowed: false, // Bị khóa
        checkRestartAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, TaskRestartPrecheck.reloadRestrictedByConfig);
    });

    test(
        'Should return [reloadRestrictedByConfig] if isReexecutionAllowed=false and state is Failed',
        () {
      final result = TaskRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        taskDataState: TaskDataStateSubmissionAttemptedFailed(
          submissionErrorInfo: TaskErrorInfo(
            taskErrorMethod: TaskErrorMethod.isReexecutionAllowed,
            error: "Error",
            errorStackTrace: StackTrace.current,
          ),
        ),
        isReexecutionAllowed: false, // Bị khóa
        checkRestartAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, TaskRestartPrecheck.reloadRestrictedByConfig);
    });

    // =========================================================================
    // 4. Kiểm tra Business Rules (checkAllow / checkRestartAllowed)
    // =========================================================================
    test('Should return [notAllowed] if business rule rejects', () {
      final result = TaskRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        taskDataState: const TaskDataStateLoadedFresh(),
        isReexecutionAllowed: true, // Được phép re-execution
        checkRestartAllowed: () =>
            CheckAllowResult.notAllowed(), // Bị block bởi Business Rule
      );

      expect(result.yes, isFalse);
      expect(result.errCode, TaskRestartPrecheck.notAllowed);
    });

    test(
        'Should return [checkAllowMethodError] if business rule throws/returns error',
        () {
      // Giả lập một error info
      final fakeErrorInfo = ErrorInfo(
          errorMessage: "Fake Error", errorDetails: [], stackTrace: null);

      final result = TaskRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        taskDataState: TaskDataStateSubmissionAttemptedSuccess(),
        isReexecutionAllowed: true,
        checkRestartAllowed: () =>
            CheckAllowResult.error(errorInfo: fakeErrorInfo),
      );

      expect(result.yes, isFalse);
      expect(result.errCode, TaskRestartPrecheck.checkAllowMethodError);
      expect(result.errorInfo, equals(fakeErrorInfo));
    });

    test('Should bypass business rule check when checkAllow=false', () {
      final result = TaskRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: true,
        isBusy: false,
        checkAllow: false, // Bypass business rules
        taskDataState: const TaskDataStateLoadedFresh(),
        isReexecutionAllowed: true,
        checkRestartAllowed: () =>
            CheckAllowResult.notAllowed(), // Dù false nhưng sẽ không bị xét tới
      );

      expect(result.yes, isTrue);
    });

    // =========================================================================
    // 5. Success Path (Trường hợp lý tưởng)
    // =========================================================================
    test('Should return [yes] when all checks passed gracefully', () {
      final result = TaskRestartPrecheckUtils.checkBeforeRestart(
        checkBusy: true,
        isBusy: false,
        checkAllow: true,
        taskDataState: const TaskDataStateLoadedFresh(),
        isReexecutionAllowed: true,
        checkRestartAllowed: () => CheckAllowResult.allowed(),
      );

      expect(result.yes, isTrue);
      expect(result.errCode, isNull);
    });
  });
}
