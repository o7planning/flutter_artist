part of '../core.dart';

/// Mô hình quản lý biểu mẫu và validation chuyên biệt cho Task.
abstract class TaskFormModel<
TASK_DATA extends TaskData,
FORM_INPUT extends FormInput,
ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData> extends _Core {
  late final Task<
      TASK_DATA, //
      FORM_INPUT,
      ADDITIONAL_FORM_RELATED_DATA> task;

  void _bindToTask(Task<
      TASK_DATA, //
      FORM_INPUT,
      ADDITIONAL_FORM_RELATED_DATA>
  task) {
    this.task = task;
  }

  /// Thu thập dữ liệu và kích hoạt luồng Submit của Task.
  Future<void> submit() async {
    // Thu thập dữ liệu biểu mẫu đã nhập
    Map<String, dynamic> formTaskData = {};

    final apiResult = await task.performExecute(
      formData: formTaskData,
    );
    await task._processTaskSubmitResult(apiResult);
  }
}
