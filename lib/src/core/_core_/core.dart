import 'dart:async';
import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/scheduler.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
    as dialogs;
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hive/hive.dart';
import 'package:number_pagination/number_pagination.dart' as number_pagination;
import 'package:visibility_detector/visibility_detector.dart';

import '../../debug/dialog/_block_error_viewer_dialog.dart';
import '../../debug/dialog/_code_flow_viewer_dialog.dart';
import '../../debug/dialog/_error_log_viewer_dialog.dart';
import '../../debug/dialog/_executor_dialog.dart';
import '../../debug/dialog/_filter_criteria_dialog.dart';
import '../../debug/dialog/_filter_model_info_dialog.dart';
import '../../debug/dialog/_form_error_viewer_dialog.dart';
import '../../debug/dialog/_form_model_info_dialog.dart';
import '../../debug/dialog/_root_debug_dialog.dart';
import '../../debug/dialog/_scalar_error_viewer_dialog.dart';
import '../../debug/dialog/_storage_dialog.dart';
import '../../debug/dialog/_ui_components_dialog.dart';
import '../../debug/executor/model/_debug_x_shelf_task_unit_queue.dart';
import '../../debug/executor/model/_debug_task_unit.dart';
import '../../debug/executor/model/_debug_task_unit_queue.dart';
import '../../debug/storage/_block_or_scalar.dart';
import '../action/_background_action.dart';
import '../action/_action.dart';
import '../action/block_silent_action.dart';
import '../action/block_quick_multi_items_creation_action.dart';
import '../action/block_quick_item_creation_action.dart';
import '../action/block_quick_item_update_action.dart';
import '../action/block_silent_item_creation_action.dart';
import '../action/block_silent_item_update_action.dart';
import '../action/scalar_quick_extra_data_load_action.dart';
import '../action/storage_silent_action.dart';
import '../adapter/_flutter_artist_adapter.dart';
import '../adapter/_global_data_adapter.dart';
import '../adapter/_locale_adapter.dart';
import '../adapter/_logged_in_user_adapter.dart';
import '../adapter/_notification_adapter.dart';
import '../annotation/annotation.dart';
import '../enums/_action_confirmation_type.dart';
import '../enums/_action_result_state.dart';
import '../enums/_activity_hidden_behavior.dart';
import '../enums/_block_control_action_type.dart';
import '../enums/_block_error_method.dart';
import '../enums/_block_hidden_behavior.dart';
import '../enums/_block_item_refreshment_mode.dart';
import '../enums/_code_flow_type.dart';
import '../enums/_current_item_selection_type.dart';
import '../enums/_data_mode.dart';
import '../enums/_data_state.dart';
import '../enums/_debug_cat.dart';
import '../enums/_err_code_if_item_is_null.dart';
import '../enums/_filter_activity_type.dart';
import '../enums/_force_type.dart';
import '../enums/_form_action.dart';
import '../enums/_form_activity_type.dart';
import '../enums/_form_error_method.dart';
import '../enums/_form_mode.dart';
import '../enums/_item_creation_type.dart';
import '../enums/_item_list_mode.dart';
import '../enums/_multi_opt_prop_reload.dart';
import '../enums/_post_query_behavior.dart';
import '../enums/_qry_hint.dart';
import '../enums/_qry_pagination_type.dart';
import '../enums/_quick_suggestion_mode.dart';
import '../enums/_quick_suggestion_type.dart';
import '../enums/_refreshable_widget_type.dart';
import '../enums/_scalar_control_action_type.dart';
import '../enums/_scalar_error_method.dart';
import '../enums/_scalar_hidden_behavior.dart';
import '../enums/_selection_type.dart';
import '../enums/_shelf_hidden_behavior.dart';
import '../enums/_show_mode.dart';
import '../enums/_sorting_direction.dart';
import '../enums/_task_type.dart';
import '../enums/_x_shelf_type.dart';
import '../enums/after_silent_action.dart';
import '../error/_app_error_info.dart';
import '../error/_block_error_info.dart';
import '../error/_duplicate_filter_criterion_error.dart';
import '../error/_duplicate_form_prop_error.dart';
import '../error/_fatal_app_error.dart';
import '../error/_form_error_info.dart';
import '../error/_form_temp_error.dart';
import '../error/_scalar_error_info.dart';
import '../error_logger/_error_logger.dart';
import '../global/_global_data.dart';
import '../icon/icon_constants.dart';
import '../notification/_notification_listener.dart';
import '../notification/_notification_summary.dart';
import '../precheck/__actionable.dart';
import '../precheck/_check_allow.dart';
import '../precheck/background_action_precheck.dart';
import '../precheck/block_clearance_precheck.dart';
import '../precheck/block_silent_item_creation_precheck.dart';
import '../precheck/block_silent_item_update_precheck.dart';
import '../precheck/scalar_clearance_precheck.dart';
import '../precheck/block_form_enablement_chk.dart';
import '../precheck/block_form_reset_precheck.dart';
import '../precheck/block_form_save_precheck.dart';
import '../precheck/block_item_creation_precheck.dart';
import '../precheck/block_item_curr_selection_precheck.dart';
import '../precheck/block_item_deletion_precheck.dart';
import '../precheck/block_item_edit_precheck.dart';
import '../precheck/block_items_deletion_precheck.dart';
import '../precheck/block_multi_items_creation_precheck.dart';
import '../precheck/block_query_precheck.dart';
import '../precheck/block_silent_action_precheck.dart';
import '../precheck/block_quick_item_creation_precheck.dart';
import '../precheck/block_quick_item_update_precheck.dart';
import '../precheck/enter_form_fields_precheck.dart';
import '../precheck/form_model_data_load_precheck.dart';
import '../precheck/scalar_query_precheck.dart';
import '../precheck/scalar_quick_action_precheck.dart';
import '../precheck/show_form_info_precheck.dart';
import '../typedef/custom_confirmation.dart';
import '../utils/_class_utils.dart';
import '../utils/_compare_utils.dart';
import '../utils/_debug_print.dart';
import '../utils/_hive_utils.dart';
import '../utils/_string_utils.dart';
import '../utils/_visibility_detector_utils.dart';
import '../widgets/_custom_app_container.dart';
import '../event/fire_silent_events_action.dart';

part '__core__/___core.dart';

part '__core__/_activity.dart';

part '__core__/_background_executor.dart';

part '__core__/_block.dart';

part '__core__/_block_data.dart';

part '__core__/_coordinator.dart';

part '__core__/_current_couple_item.dart';

part '__core__/_debug_options.dart';

part '__core__/_default_filter_model.dart';

part '_core_event_/_eff_block.dart';

part '_core_event_/_eff_scalar.dart';

part '_core_event_/_effected_shelf_members.dart';

part '__core__/_error_listener.dart';

part '__core__/_executor.dart';

part '__core__/_extra_form_input.dart';

part '__core__/_filter_criteria.dart';

part '__core__/_filter_input.dart';

part '__core__/_filter_model.dart';

part '__core__/_form_leave_safely.dart';

part '__core__/_form_model.dart';

part '__core__/_item_sort_criteria.dart';

part '__core__/_scalar.dart';

part '__core__/_scalar_data.dart';

part '__core__/_shelf.dart';

part '__core__/_shelf_block_scalar_type.dart';

part '_core_event_/_shelf_external_utils.dart';

part '__core__/_shelf_structure.dart';

part '__core__/_single_item_block.dart';

part '__core__/_sort_criterion.dart';

part '__core__/_storage.dart';

part '__core__/_storage_ev.dart';

part '__core__/_suggested_selection.dart';

part '_code_flow_/_code_flow_item.dart';

part '_code_flow_/_code_flow_logger.dart';

part '_code_flow_/_func_call_info.dart';

part '_config_/_activity_config.dart';

part '_config_/_block_config.dart';

part '_config_/_coordinator_config.dart';

part '_config_/_event_config.dart';

part '_config_/_filter_model_config.dart';

part '_config_/_form_model_config.dart';

part '_config_/_scalar_config.dart';

part '_config_/_shelf_config.dart';

part '_core_x_/_lazy_objects.dart';

part '_core_x_/_x_block.dart';

part '_core_x_/_x_filter_model.dart';

part '_core_x_/_x_form_model.dart';

part '_core_x_/_x_scalar.dart';

part '_core_x_/_x_shelf.dart';

part '_core_x_/_x_condition_/_scalar_re_qry_condition.dart';

part '_core_x_/_x_condition_/_block_re_qry_condition.dart';

part '_core_x_/_x_condition_/_block_item_refresh_condition.dart';

part '_core_x_/_x_shelf_/_x_query_/__src_block_and_options.dart';

part '_core_x_/_x_shelf_/_x_query_/__src_scalar_and_options.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_shelf_natural_query.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_shelf_external_reaction_old.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_shelf_external_reaction.dart';

part '_core_x_/_x_shelf_/_x_query_/__x_shelf_base_query.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_block_query.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_block_query_empty.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_block_query_and_prepare_to_edit.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_block_query_and_prepare_to_create.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_filter_model_query_all.dart';

part '_core_x_/_x_shelf_/_x_shelf_form_model_save.dart';

part '_core_x_/_x_shelf_/_x_shelf_form_model_enter_fields.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_multi_items_deletion.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_item_deletion.dart';

part '_core_x_/_x_shelf_/_x_shelf_prepare_form_to_create_item.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_clear_current_item.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_quick_multi_items_creation.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_silent_item_update.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_quick_item_update.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_quick_item_creation.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_silent_action_execution.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_curr_item_selection.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_silent_item_creation.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_clearance.dart';

part '_core_x_/_x_shelf_/_x_shelf_scalar_clearance.dart';

part '_core_x_/_x_shelf_/_x_shelf_scalar_silent_action.dart';

part '_core_x_/_x_shelf_/_x_shelf_scalar_quick_extra_data_load_action.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_scalar_query.dart';

part '_core_x_/_x_shelf_/_x_shelf_form_view_change.dart';

part '_core_x_/_x_shelf_/_x_shelf_filter_view_change.dart';

part '_core_x_/_x_storage.dart';

part '_core_state_/__force_reload_throw.dart';

part '_core_state_/_force_reload_form_calculator.dart';

part '_core_state_/_force_reload_item_calculator.dart';

part '_core_state_/_force_reload_state.dart';

part '_fa_.dart';

part '_filter_criterion_/__criterion.dart';

part '_filter_criterion_/_calculated_criterion.dart';

part '_filter_criterion_/_filter_criteria_structure.dart';

part '_filter_criterion_/_multi_opt_criterion.dart';

part '_filter_criterion_/_multi_opt_ss_criterion.dart';

part '_filter_criterion_/_multi_opt_ms_criterion.dart';

part '_filter_criterion_/_simple_criterion.dart';

part '_form_prop_/__prop.dart';

part '_form_prop_/_calculated_prop.dart';

part '_form_prop_/_form_props_structure.dart';

part '_form_prop_/_multi_opt_prop.dart';

part '_form_prop_/_multi_opt_ss_prop.dart';

part '_form_prop_/_multi_opt_ms_prop.dart';

part '_form_prop_/_simple_prop.dart';

part '_form_prop_/_value_wrap.dart';

part '_globals_/_globals_manager.dart';

part '_locale_/_locale_manager.dart';

part '_login_/_login_activity_base.dart';

part '_login_/_simple_login_view.dart';

part '_notification_/_notification_engine.dart';

part '_task_result_/__task_result.dart';

part '_task_result_/_background_action_result.dart';

part '_task_result_/_block_clearance_result.dart';

part '_task_result_/_scalar_clearance_result.dart';

part '_task_result_/_block_item_creation_result.dart';

part '_task_result_/_block_item_curr_selection_result.dart';

part '_task_result_/_block_item_deletion_result.dart';

part '_task_result_/_block_items_deletion_result.dart';

part '_task_result_/_block_query_result.dart';

part '_task_result_/_block_silent_action_result.dart';

part '_task_result_/_block_quick_item_creation_result.dart';

part '_task_result_/_block_silent_item_creation_result.dart';

part '_task_result_/_block_quick_item_update_result.dart';

part '_task_result_/_block_silent_item_update_result.dart';

part '_task_result_/_block_quick_multi_items_creation_result.dart';

part '_task_result_/_form_model_data_load_result.dart';

part '_task_result_/_form_save_result.dart';

part '_task_result_/_scalar_query_result.dart';

part '_task_result_/_storage_silent_action_result.dart';

part '_task_unit_/__resulted_s_task_unit.dart';

part '_task_unit_/__x_shelf_task_unit_queue.dart';

part '_task_unit_/__task_unit.dart';

part '_task_unit_/__x_root_queue.dart';

part '_task_unit_/_block_clearance_task_unit.dart';

part '_task_unit_/_scalar_clearance_task_unit.dart';

part '_task_unit_/_block_clear_current_task_unit.dart';

part '_task_unit_/_block_item_deletion_task_unit.dart';

part '_task_unit_/_block_multi_items_deletion_task_unit.dart';

part '_task_unit_/_block_prepare_form_to_create_item_task_unit.dart';

part '_task_unit_/_block_query_task_unit.dart';

part '_task_unit_/_block_silent_action_task_unit.dart';

part '_task_unit_/_block_quick_item_creation_task_unit.dart';

part '_task_unit_/_block_silent_item_creation_task_unit.dart';

part '_task_unit_/_block_quick_multi_items_creation_task_unit.dart';

part '_task_unit_/_block_quick_item_update_task_unit.dart';

part '_task_unit_/_block_silent_item_update_task_unit.dart';

part '_task_unit_/_block_select_as_current_task_unit.dart';

part '_task_unit_/_filter_view_change_task_unit.dart';

part '_task_unit_/_form_model_auto_enter_form_fields_task_unit.dart';

part '_task_unit_/_form_model_load_form_task_unit.dart';

part '_task_unit_/_form_model_save_form_task_unit.dart';

part '_task_unit_/_form_view_change_task_unit.dart';

part '_task_unit_/_scalar_load_extra_data_quick_action_task_unit.dart';

part '_task_unit_/_scalar_query_task_unit.dart';

part '_task_unit_/_storage_silent_action_task_unit.dart';

part '_ui_/__refreshable_widget.dart';

part '_ui_/__refreshable_widget_state.dart';

part '_ui_/_activity_fragment_widget_builder.dart';

part '_ui_/_block_control_bar.dart';

part '_ui_/_block_control_bar_config.dart';

part '_ui_/_block_fragment_view.dart';

part '_ui_/_block_fragment_view_builder.dart';

part '_ui_/_block_item_detail_view.dart';

part '_ui_/_block_items_view.dart';

part '_ui_/_block_items_view_builder.dart';

part '_ui_/_control_bar_button.dart';

part '_ui_/_dev_container.dart';

part '_ui_/_filter_view.dart';

part '_ui_/_filter_view_builder.dart';

part '_ui_/_form_view.dart';

part '_ui_/_form_view_builder.dart';

part '_ui_/_logged_in_user_builder.dart';

part '_ui_/_notification_button_builder.dart';

part '_ui_/_number_pagination_view.dart';

part '_ui_/_pagination_view.dart';

part '_ui_/_quick_suggestion_bar.dart';

part '_ui_/_quick_suggestion_button.dart';

part '_ui_/_refreshable_neutral_view.dart';

part '_ui_/_refreshable_neutral_view_builder.dart';

part '_ui_/_scalar_value_view.dart';

part '_ui_/_scalar_fragment_view.dart';

part '_ui_/_scalar_fragment_view_builder.dart';

part '_ui_/_sort_options.dart';

part '_ui_/_sort_options_bar.dart';

part '_ui_/_sort_options_dropdown.dart';

part '_ui_/_task_progress_view_builder.dart';

part '_ui_/_x_state.dart';

part '_ui_com_/__ui_components.dart';

part '_ui_com_/_block_ui_components.dart';

part '_ui_com_/_filter_ui_components.dart';

part '_ui_com_/_form_ui_components.dart';

part '_ui_com_/_logged_in_user_ui_components.dart';

part '_ui_com_/_scalar_ui_components.dart';

part '_ui_com_/_shelf_ui_components.dart';

part '_ui_control_/_block_control.dart';

part '_ui_control_/_block_control_elevated_button.dart';

part '_ui_control_/_block_control_fab.dart';

part '_ui_control_/_block_control_filled_button.dart';

part '_ui_control_/_block_control_inkwell.dart';

part '_ui_control_/_block_control_outlined_button.dart';

part '_ui_control_/_block_control_text_button.dart';

part '_ui_control_/_custom_control_bar.dart';

part '_ui_control_/_custom_control_bar_item.dart';

part '_ui_control_/_scalar_control.dart';

part '_ui_control_/_scalar_control_elevated_button.dart';

part '_ui_control_/_scalar_control_fab.dart';

part '_ui_control_/_scalar_control_filled_button.dart';

part '_ui_control_/_scalar_control_inkwell.dart';

part '_ui_control_/_scalar_control_outlined_button.dart';

part '_ui_control_/_scalar_control_text_button.dart';

part '_utils_/_app_utils.dart';

part '_xdata_/_x_data.dart';

part '_xdata_/_list_x_data.dart';

part '_xdata_/_tree_x_data.dart';

// *****************************************************************************
// *****************************************************************************

class _AbstractMethodAnnotation {
  const _AbstractMethodAnnotation();
}

class _RootMethodAnnotation {
  const _RootMethodAnnotation();
}

class _InternalEventReactAnnotation {
  const _InternalEventReactAnnotation();
}

class _ShelfExternalAnnotation {
  const _ShelfExternalAnnotation();
}

class _ReturnTaskResultMethodAnnotation {
  const _ReturnTaskResultMethodAnnotation();
}

class _PrecheckPrivateMethod {
  const _PrecheckPrivateMethod();
}

class _PrecheckMethod {
  const _PrecheckMethod();
}

class _IsAllowPrivateMethodAnnotation {
  const _IsAllowPrivateMethodAnnotation();
}

class _OverridableMethodAnnotation {
  const _OverridableMethodAnnotation();
}

class _TaskUnitClassAnnotation {
  const _TaskUnitClassAnnotation();
}

class _TaskUnitMethodAnnotation {
  const _TaskUnitMethodAnnotation();
}

class _ImportantMethodAnnotation {
  final String message;

  const _ImportantMethodAnnotation(this.message);
}

class _MayThrowFormTempErrorAnnotation {
  const _MayThrowFormTempErrorAnnotation();
}

class _BlockShelfQueryAnnotation {
  const _BlockShelfQueryAnnotation();
}

class _BlockPrepareFormToCreateItemAnnotation {
  const _BlockPrepareFormToCreateItemAnnotation();
}

class _BlockSelectItemAsCurrentAnnotation {
  const _BlockSelectItemAsCurrentAnnotation();
}

class _BlockClearanceAnnotation {
  const _BlockClearanceAnnotation();
}

class _BlockClearCurrentAnnotation {
  const _BlockClearCurrentAnnotation();
}

class _BlockQueryNextPageAnnotation {
  const _BlockQueryNextPageAnnotation();
}

class _BlockQueryPreviousPageAnnotation {
  const _BlockQueryPreviousPageAnnotation();
}

class _BlockQueryMorePageAnnotation {
  const _BlockQueryMorePageAnnotation();
}

class _BlockQueryAnnotation {
  const _BlockQueryAnnotation();
}

class _BlockQueryAndPrepareToEditAnnotation {
  const _BlockQueryAndPrepareToEditAnnotation();
}

class _BlockQueryAndPrepareToCreateAnnotation {
  const _BlockQueryAndPrepareToCreateAnnotation();
}

class _BlockSelectFirstItemAsCurrentAnnotation {
  const _BlockSelectFirstItemAsCurrentAnnotation();
}

class _BlockSelectNextItemAsCurrentAnnotation {
  const _BlockSelectNextItemAsCurrentAnnotation();
}

class _BlockSelectPreviousItemAsCurrentAnnotation {
  const _BlockSelectPreviousItemAsCurrentAnnotation();
}

class _BlockDeleteSelectedItemsAnnotation {
  const _BlockDeleteSelectedItemsAnnotation();
}

class _BlockDeleteCheckedItemsAnnotation {
  const _BlockDeleteCheckedItemsAnnotation();
}

class _BlockDeleteCurrentItemAnnotation {
  const _BlockDeleteCurrentItemAnnotation();
}

class _BlockDeleteItemAnnotation {
  const _BlockDeleteItemAnnotation();
}

class _BlockDeleteItemsAnnotation {
  const _BlockDeleteItemsAnnotation();
}

class _BlockRefreshCurrentItemAnnotation {
  const _BlockRefreshCurrentItemAnnotation();
}

class _FormModelEnterFormFieldsAnnotation {
  const _FormModelEnterFormFieldsAnnotation();
}

class _FormModelSaveFormAnnotation {
  const _FormModelSaveFormAnnotation();
}

class _FormModelLoadFormAnnotation {
  const _FormModelLoadFormAnnotation();
}

class _FormViewChangeAnnotation {
  const _FormViewChangeAnnotation();
}

class _FilterViewChangeAnnotation {
  const _FilterViewChangeAnnotation();
}

class _ScalarQueryAnnotation {
  const _ScalarQueryAnnotation();
}

class _ScalarClearanceAnnotation {
  const _ScalarClearanceAnnotation();
}

// ******* Scalar QuickAction (START) ******************************************

class _StorageSilentActionAnnotation {
  const _StorageSilentActionAnnotation();
}

class _ScalarLoadExtraDataQuickActionAnnotation {
  const _ScalarLoadExtraDataQuickActionAnnotation();
}

// ******* Scalar QuickAction (END) ********************************************

// ******* Block QuickAction (START) *******************************************

class _BlockSilentActionAnnotation {
  const _BlockSilentActionAnnotation();
}

class _BlockQuickItemCreationActionAnnotation {
  const _BlockQuickItemCreationActionAnnotation();
}

class _BlockSilentItemCreationActionAnnotation {
  const _BlockSilentItemCreationActionAnnotation();
}

class _BlockQuickCreateMultiItemsActionAnnotation {
  const _BlockQuickCreateMultiItemsActionAnnotation();
}

class _BlockQuickItemUpdateActionAnnotation {
  const _BlockQuickItemUpdateActionAnnotation();
}

class _BlockSilentItemUpdateActionAnnotation {
  const _BlockSilentItemUpdateActionAnnotation();
}

// ******* Block QuickAction (END) *********************************************
