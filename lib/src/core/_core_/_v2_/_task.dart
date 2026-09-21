part of '../core.dart';

abstract class Task<
    TASK_DATA extends TaskData, //
    TASK_INPUT extends FormInput,
    ADDITIONAL_FORM_DATA extends AdditionalFormRelatedData> extends _Core {
  final String name;
  final TaskConfig config;
  final TaskEffectiveConfig effectiveConfig;

  late final Activity activity;

  /// Form Model là tùy chọn (null nếu là Headless/Button Task)
  final TaskFormModel<TASK_DATA, TASK_INPUT, ADDITIONAL_FORM_DATA>? formModel;

  Task({
    required this.name,
    this.config = const TaskConfig(),
    this.formModel,
  }) : effectiveConfig = TaskEffectiveConfig.fromConfig(config) {
    formModel?._bindToTask(this);
  }

  void _bindToActivity(Activity parentActivity) {
    activity = parentActivity;
  }

  bool get hasForm => formModel != null;

  /// Hook thực thi chính của Task (Nhận dữ liệu từ Form nếu có)
  Future<ApiResult<TASK_DATA>> performExecute({
    required Map<String, dynamic>? formData,
  });

  Future<void> _processTaskSubmitResult(ApiResult<TASK_DATA> apiResult) async {
    // ...
  }
}
