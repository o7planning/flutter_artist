part of '../../core.dart';

abstract class TaskFormModel<
        INIT_DATA extends TaskInitData,
        RESULT_DATA extends TaskResultData,
        CREATION_PRESET extends CreationPreset,
        FORM_INPUT extends FormInput,
        ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData>
    extends BaseFormModel<CREATION_PRESET, FORM_INPUT,
        ADDITIONAL_FORM_RELATED_DATA> {
  @override
  String get pathInfo => "${task.activity.name} > ${task.name} > task-form";

  late final Task<INIT_DATA, RESULT_DATA, CREATION_PRESET, FORM_INPUT> task;

  void _bindToTask(Task parentTask) {
    task =
        parentTask as Task<INIT_DATA, RESULT_DATA, CREATION_PRESET, FORM_INPUT>;
  }

  TaskFormModel({super.config});

  // ===========================================================================
  // FORM EXTRACTION HOOKS (Symmetric with BlockFormModel)
  // ===========================================================================

  /// Supplies baseline initial values using [initData], [creationPreset], and [additionalData].
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? specifyInitialValuesForSimpleProps({
    required INIT_DATA? initData,
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  @_AbstractMethodAnnotation()
  OptValueWrap? specifyInitialValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required INIT_DATA? initData,
    required CREATION_PRESET creationPreset,
    required ADDITIONAL_FORM_RELATED_DATA additionalFormRelatedData,
  });

  @_AbstractMethodAnnotation()
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleProps({
    required FORM_INPUT formInput,
  });

  @_AbstractMethodAnnotation()
  OptValueWrap? extractUpdateValueForMultiOptProp({
    required String multiOptPropName,
    required SelectionType selectionType,
    required XData multiOptPropXData,
    required Object? parentMultiOptPropValue,
    required FORM_INPUT formInput,
  });

  @_AbstractMethodAnnotation()
  Future<ADDITIONAL_FORM_RELATED_DATA> performLoadAdditionalFormRelatedData({
    required INIT_DATA? initData,
  });

  // ===========================================================================
  // SUBMISSION
  // ===========================================================================

  /// Submits the active form and triggers the underlying Task execution.
  Future<TaskSubmitExecutionResult<INIT_DATA, RESULT_DATA>> submit() async {
    final Map<String, dynamic> formMapData =
        _formModelStructure._currentFormData;
    final ApiResult<RESULT_DATA> apiResult = await task.performSubmit(
      formData: formMapData,
      initData: task.initData,
    );

    if (apiResult.isError()) {
      return TaskSubmitExecutionResult<INIT_DATA, RESULT_DATA>(
        precheck: null,
      );
    } else {
      _formModelStructure._setManualDirty(false);
      return TaskSubmitExecutionResult<INIT_DATA, RESULT_DATA>(
        precheck: null,
      );
    }
  }

  @override
  bool isEnabled() => dataState.isFresh;

  @override
  bool _canResetForm() => isDirty();

  @override
  void _refreshAllViews() {
    // task.ui.refreshAllViews();
    // FlutterArtist.desk.ui.refreshAllViews();
  }

  @override
  void _triggerWhenFormViewVisible() {}

  @override
  void _addToRecent() {}

  @override
  Future<void> _onChangeFromFormView({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) async {
    // Reactive multi-opt cascade triggers
  }
}
