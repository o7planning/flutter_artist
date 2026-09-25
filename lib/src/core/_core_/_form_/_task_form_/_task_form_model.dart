part of '../../core.dart';

abstract class TaskFormModel<
        TASK_DATA extends TaskData,
        TASK_INPUT extends FormInput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends BaseFormModel {
  Activity get activity => task.activity;

  @override
  String get pathInfo {
    return "${activity.name} > ${task.name} > task-form";
  }

  late final Task<
      TASK_DATA, //
      TASK_INPUT,
      ADDITIONAL_FORM_RELATED_DATA> task;

  void _bindToTask(
      Task<TASK_DATA, TASK_INPUT, ADDITIONAL_FORM_RELATED_DATA> task) {
    this.task = task;
  }

  /// Nạp các dữ liệu danh mục phụ trợ (vd: FeedbackCategoryList, UserProfile).
  Future<ADDITIONAL_FORM_RELATED_DATA?> performLoadFormRelatedData();

  /// Khởi tạo giá trị ban đầu cho form (Initial Values).
  Map<String, dynamic> specifyInitialValues({
    required TASK_INPUT? taskInput,
    required ADDITIONAL_FORM_RELATED_DATA? relatedData,
  });

  /// Thu thập dữ liệu biểu mẫu đã nhập và kích hoạt execute trên Task.
  Future<TaskExecutionResult<TASK_DATA>> submit() async {
    // final FormBuilderState? currentState = formKey.currentState;
    // if (currentState == null || !currentState.saveAndValidate()) {
    //   return TaskExecutionResult.validationFailed();
    // }
    //
    // final Map<String, dynamic> formData = currentState.value;
    //
    // // Giao quyền thực thi cho Task thông qua TaskExecutionIntent
    // return await task.executeWithFormData(formData: formData);
    throw UnimplementedError("TODO submit");
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  void _addToRecent() {
    FlutterArtist.desk._addRecentActivity(activity);
  }

  @override
  void _triggerWhenFormViewVisible() {
    FlutterArtist.storage._lazyUiComponentTriggerQueue.addActivity(activity);
  }

  @override
  bool _canResetForm() {
    // Actionable canReset = block.canResetForm();
    // return canReset;
    // TODO: Hardcode
    print("TODO: taskFormModel._canResetForm");
    return false;
  }

  @override
  void _refreshAllViews() {
    // activity.ui.refreshAllViews();
    // TODO: Hardcode
    print("TODO: taskFormModel._refreshAllViews");
  }
}
