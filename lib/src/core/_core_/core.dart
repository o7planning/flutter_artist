import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/scheduler.dart';
import 'package:flutter_artist/src/debug/menu/_debug_menu_builder.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
    as dialogs;
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hive/hive.dart';
import 'package:number_pagination/number_pagination.dart' as number_pagination;

import '../../debug/code_flow/__task_flow_const.dart';
import '../../debug/dialog/_block_error_viewer_dialog.dart';
import '../../debug/dialog/_debug_viewer_dialog.dart';
import '../../debug/dialog/_debug_shelf_structure_viewer_dialog.dart';
import '../../debug/dialog/_error_viewer_dialog.dart';
import '../../debug/dialog/_task_flow_viewer_dialog.dart';
import '../../debug/dialog/_log_viewer_dialog.dart';
import '../../debug/dialog/_executor_dialog.dart';
import '../../debug/dialog/_form_error_viewer_dialog.dart';
import '../../debug/dialog/_debug_form_model_viewer_dialog.dart';
import '../../debug/dialog/_root_debug_dialog.dart';
import '../../debug/dialog/_scalar_error_viewer_dialog.dart';
import '../../debug/dialog/_debug_storage_viewer_dialog.dart';
import '../../debug/dialog/_debug_ui_components_viewer_dialog.dart';
import '../../debug/executor/model/_debug_x_root_queue_item.dart';
import '../../debug/executor/model/_debug_task_unit.dart';
import '../../debug/executor/model/_debug_x_root_queue.dart';
import '../../debug/storage/_block_or_scalar.dart';
import '../../debug/utils/_debug.dart';
import '../action/_background_action.dart';
import '../action/_action.dart';
import '../action/block_silent_action.dart';
import '../action/block_quick_multi_items_creation_action.dart';
import '../action/block_quick_item_creation_action.dart';
import '../action/block_quick_item_update_action.dart';
import '../action/scalar_quick_extra_data_load_action.dart';
import '../action/storage_silent_action.dart';
import '../adapter/_global_data_adapter.dart';
import '../adapter/_notification_adapter.dart';
import '../annotation/annotation.dart';
import '../built_in/empty_form_input.dart';
import '../built_in/empty_filter_criteria.dart';
import '../built_in/empty_filter_input.dart';
import '../enums/_action_confirmation_type.dart';
import '../enums/_action_result_state.dart';
import '../enums/_activity_hidden_action.dart';
import '../enums/_client_side_sort_mode.dart';
import '../enums/_default_setting_policy.dart';
import '../enums/_filter_criterion_operator.dart';
import '../enums/_filter_error_method.dart';
import '../enums/_hook_hidden_action.dart';
import '../enums/_block_control_action_type.dart';
import '../enums/_block_error_method.dart';
import '../enums/_block_hidden_action.dart';
import '../enums/_item_absent_representative_policy.dart';
import '../enums/_line_flow_type.dart';
import '../enums/_master_flow_item_type.dart';
import '../enums/_current_item_setting_type.dart';
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
import '../enums/_freeze_type.dart';
import '../enums/_item_creation_type.dart';
import '../enums/_item_list_mode.dart';
import '../enums/_multi_opt_prop_reload.dart';
import '../enums/_after_query_action.dart';
import '../enums/_qry_hint.dart';
import '../enums/_qry_pagination_type.dart';
import '../enums/_quick_suggestion_mode.dart';
import '../enums/_quick_suggestion_type.dart';
import '../enums/_refreshable_widget_type.dart';
import '../enums/_representative_type.dart';
import '../enums/_scalar_control_action_type.dart';
import '../enums/_scalar_error_method.dart';
import '../enums/_scalar_hidden_action.dart';
import '../enums/_selection_type.dart';
import '../enums/_shelf_hidden_action.dart';
import '../enums/_show_mode.dart';
import '../enums/_sort_direction.dart';
import '../enums/_sorting_side.dart';
import '../enums/_task_type.dart';
import '../enums/_tip_document.dart';
import '../enums/_x_shelf_type.dart';
import '../enums/after_silent_action.dart';
import '../error/_block_error_info.dart';
import '../error/_dev_error.dart';
import '../error/_filter_criterion_errors.dart';
import '../error/_filter_error_info.dart';
import '../error/_form_prop_errors.dart';
import '../error/_fatal_app_error.dart';
import '../error/_filter_temp_error.dart';
import '../error/_form_error_info.dart';
import '../error/_form_temp_error.dart';
import '../error/_scalar_error_info.dart';
import '../global/_global_data.dart';
import '../icon/icon_constants.dart';
import '../logger/_logger.dart';
import '../notification/_notification_listener.dart';
import '../notification/_notification_summary.dart';
import '../precheck/__actionable.dart';
import '../precheck/_check_allow.dart';
import '../precheck/background_action_precheck.dart';
import '../precheck/block_clearance_precheck.dart';
import '../precheck/filter_model_data_load_precheck.dart';
import '../precheck/scalar_clearance_precheck.dart';
import '../precheck/block_form_enablement_chk.dart';
import '../precheck/block_form_reset_precheck.dart';
import '../precheck/block_form_save_precheck.dart';
import '../precheck/block_item_creation_precheck.dart';
import '../precheck/block_current_item_setting_precheck.dart';
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
import '../precheck/shelf_delayed_reaction_execution_precheck.dart';
import '../precheck/show_form_info_precheck.dart';
import '../typedef/custom_confirmation.dart';
import '../utils/_class_utils.dart';
import '../utils/_compare_utils.dart';
import '../utils/_hive_utils.dart';
import '../utils/_html_utils.dart';
import '../utils/_name_utils.dart';
import '../widgets/_custom_app_container.dart';
import '../event/fire_silent_events_action.dart';

part '__core__/___core.dart';

part '__core__/_hook.dart';

part '__core__/_activity.dart';

part '__core__/_background_executor.dart';

part '__core__/_block.dart';

part '__core__/_block_data.dart';

part '__core__/_coordinator.dart';

part '__core__/_drawer_state.dart';

part '__core__/_block_item2_wrap.dart';

part '../debug/_debug_utils.dart';

part '../debug/_debug_printer.dart';

part '../debug/_debug_options.dart';

part '__core__/_default_filter_model.dart';

part '__core__/_queued_event.dart';

part '__core__/_queued_event_manager.dart';

part '_core_event_/_eff_block.dart';

part '_core_event_/_eff_scalar.dart';

part '_core_event_/_effected_shelf_members.dart';

part '__core__/_log_listener.dart';

part '__core__/_executor.dart';

part '_form_/_form_input.dart';

part '_form_/_form_related_data.dart';

part '_filter_/_filter_criteria.dart';

part '_filter_/_val_/__filter_x_val.dart';

part '_filter_/_val_/__filter_val.dart';

part '_filter_/_def_/_filter_criterion_def.dart';

part '_filter_/_def_/_filter_criteria_def.dart';

part '_filter_/_def_/_filter_criterion_tilde_def.dart';

part '_filter_/_model_/__filter_condition_model.dart';

part '_filter_/_def_/_filter_condition_def.dart';

part '_filter_/_filter_input.dart';

part '_filter_/_filter_model.dart';

part '_filter_/_x_filter_criteria.dart';

part '_form_/_form_leave_safely.dart';

part '_form_/_form_model.dart';

part '_sort_/_model_/_client_side_sort_model.dart';

part '_sort_/_model_/_server_side_sort_model.dart';

part '_sort_/_sort_model.dart';

part '_sort_/_sort_model_builder.dart';

part '__core__/_storage_core.dart';

part '__core__/_processed_query_result.dart';

part '__core__/_polymorphism_manager.dart';

part '__core__/_storage_natural_query_queue.dart';

part '__core__/_storage_structure.dart';

part '__core__/_polymorphism_family.dart';

part '__core__/_scalar.dart';

part '__core__/_scalar_data.dart';

part '__core__/_scalar_value_wrap.dart';

part '__core__/_shelf.dart';

part '__core__/_storage_freeze.dart';

part '__core__/_shelf_block_scalar_type.dart';

part '_core_event_/_shelf_external_utils.dart';

part '__core__/_shelf_structure.dart';

part '__core__/_single_item_block.dart';

part '_sort_/_sortable_criteria.dart';

part '_sort_/_sort_criterion.dart';

part '_sort_/_sortable_criterion.dart';

part '_sort_/_sort_criteria.dart';

part '__core__/_storage.dart';

part '__core__/_storage_ev.dart';

part '__core__/_suggested_selection.dart';

part '_code_flow_/_master_flow_item.dart';

part '_code_flow_/_code_flow_logger.dart';

part '_code_flow_/_line_flow_item.dart';

part '_code_flow_/_func_call_info.dart';

part '_config_/_event_configs.dart';

part '_config_/_hook_config.dart';

part '_config_/_activity_config.dart';

part '_config_/_block_config.dart';

part '_config_/_coordinator_config.dart';

part '_config_/_event_config.dart';

part '_config_/_filter_model_config.dart';

part '_config_/_form_model_config.dart';

part '_config_/_scalar_config.dart';

part '_config_/_shelf_config.dart';

part '_core_x_/_lazy_obj_/_lazy_filter_model.dart';

part '_core_x_/_lazy_obj_/_lazy_form_model.dart';

part '_core_x_/_lazy_obj_/_lazy_block.dart';

part '_core_x_/_lazy_obj_/_lazy_scalar.dart';

part '_core_x_/_lazy_obj_/_lazy_objects.dart';

part '_core_x_/_root_queue_/_x_activity.dart';

part '_core_x_/_x_block.dart';

part '_core_x_/_x_hook.dart';

part '_core_x_/_x_filter_model.dart';

part '_core_x_/_x_form_model.dart';

part '_core_x_/_x_scalar.dart';

part '_core_x_/_root_queue_/_x_root_queue_item.dart';

part '_core_x_/_root_queue_/_x_shelf.dart';

part '_core_x_/_x_condition_/_scalar_re_qry_condition.dart';

part '_core_x_/_x_condition_/_block_re_qry_condition.dart';

part '_core_x_/_x_condition_/_block_item_refresh_condition.dart';

part '_core_x_/_x_shelf_/_x_query_/__src_block_and_options.dart';

part '_core_x_/_x_shelf_/_x_query_/__src_scalar_and_options.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_shelf_natural_query.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_shelf_external_reaction.dart';

part '_core_x_/_x_shelf_/_x_query_/__x_shelf_base_query.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_hook.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_block_query.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_block_query_empty.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_block_query_and_prepare_to_edit.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_block_query_and_prepare_to_create.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_filter_model_query.dart';

part '_core_x_/_x_shelf_/_x_shelf_form_model_save.dart';

part '_core_x_/_x_shelf_/_x_shelf_form_model_enter_fields.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_multi_items_deletion.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_item_deletion.dart';

part '_core_x_/_x_shelf_/_x_shelf_prepare_form_to_create_item.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_clear_current_item.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_quick_multi_items_creation.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_quick_item_update.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_quick_item_creation.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_silent_action_execution.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_set_item_as_current.dart';

part '_core_x_/_x_shelf_/_x_shelf_block_clearance.dart';

part '_core_x_/_x_shelf_/_x_shelf_scalar_clearance.dart';

part '_core_x_/_x_shelf_/_x_shelf_scalar_silent_action.dart';

part '_core_x_/_x_shelf_/_x_shelf_scalar_quick_extra_data_load_action.dart';

part '_core_x_/_x_shelf_/_x_query_/_x_shelf_scalar_query.dart';

part '_core_x_/_x_shelf_/_x_shelf_form_view_change.dart';

part '_core_x_/_x_shelf_/_x_shelf_filter_panel_change.dart';

part '_core_x_/_x_shelf_/_x_shelf_sort_panel_change.dart';

part '_core_x_/_x_storage.dart';

part '_core_state_/__force_reload_throw.dart';

part '_core_state_/_force_reload_item_calculator.dart';

part '_core_state_/_force_reload_state.dart';

part '_fa_.dart';

part '_filter_/_model_/_tilde_filter_criterion_model.dart';

part '_filter_/_model_/_calculated_tilde_filter_criterion_model.dart';

part '_filter_/_filter_model_structure.dart';

part '_sort_/_def_/_sort_criterion_def.dart';

part '_sort_/_sort_model_structure.dart';

part '_filter_/_model_/_multi_opt_tilde_filter_criterion_model.dart';

part '_filter_/_model_/_multi_opt_ss_tilde_filter_criterion_model.dart';

part '_filter_/_model_/_multi_opt_ms_tilde_filter_criterion_model.dart';

part '_filter_/_model_/_simple_tilde_filter_criterion_model.dart';

part '_form_/_model_/__form_prop_model.dart';

part '_form_/_def_/_form_prop_def.dart';

part '_form_/_model_/_calculated_form_prop_model.dart';

part '_form_/_form_model_structure.dart';

part '_form_/_model_/_multi_opt_form_prop_model.dart';

part '_form_/_model_/_multi_opt_ss_form_prop_model.dart';

part '_form_/_model_/_multi_opt_ms_form_prop_model.dart';

part '_form_/_model_/_simple_form_prop_model.dart';

part '__core__/_value_wrap.dart';

part '_globals_/_globals_manager.dart';

part '_locale_/_locale_manager.dart';

part '_login_/_login_activity.dart';

part '_login_/_simple_login_view.dart';

part '_notification_/_notification_engine.dart';

part '_observer_/_navigator_observer.dart';

part '_task_result_/__task_result.dart';

part '_task_result_/_shelf_delayed_reaction_execution_result.dart';

part '_task_result_/_form_model_enter_form_fields_result.dart';

part '_task_result_/_background_action_result.dart';

part '_task_result_/_block_clearance_result.dart';

part '_task_result_/_scalar_clearance_result.dart';

part '_task_result_/_block_item_creation_result.dart';

part '_task_result_/_block_current_item_setting_result.dart';

part '_task_result_/_block_item_deletion_result.dart';

part '_task_result_/_block_items_deletion_result.dart';

part '_task_result_/_block_query_result.dart';

part '_task_result_/_block_silent_action_result.dart';

part '_task_result_/_block_quick_item_creation_result.dart';

part '_task_result_/_block_quick_item_update_result.dart';

part '_task_result_/_block_quick_multi_items_creation_result.dart';

part '_task_result_/_form_model_data_load_result.dart';

part '_task_result_/_filter_model_data_load_result.dart';

part '_task_result_/_form_save_result.dart';

part '_task_result_/_scalar_query_result.dart';

part '_task_result_/_storage_silent_action_result.dart';

part '_task_unit_/_hook_task_unit.dart';

part '_task_unit_/__resulted_s_task_unit.dart';

part '_task_unit_/__x_shelf_task_unit_queue.dart';

part '_task_unit_/__task_unit.dart';

part '_core_x_/_root_queue_/__x_root_queue.dart';

part '_task_unit_/_block_clearance_task_unit.dart';

part '_task_unit_/_scalar_clearance_task_unit.dart';

part '_task_unit_/_block_clear_current_task_unit.dart';

part '_task_unit_/_block_item_deletion_task_unit.dart';

part '_task_unit_/_activity_task_unit.dart';

part '_task_unit_/_block_multi_items_deletion_task_unit.dart';

part '_task_unit_/_block_prepare_form_to_create_item_task_unit.dart';

part '_task_unit_/_block_query_task_unit.dart';

part '_task_unit_/_block_silent_action_task_unit.dart';

part '_task_unit_/_block_quick_item_creation_task_unit.dart';

part '_task_unit_/_block_quick_multi_items_creation_task_unit.dart';

part '_task_unit_/_block_quick_item_update_task_unit.dart';

part '_task_unit_/_block_set_item_as_current_task_unit.dart';

part '_task_unit_/_filter_panel_change_task_unit.dart';

part '_task_unit_/_form_model_auto_enter_form_fields_task_unit.dart';

part '_task_unit_/_filter_model_load_data_task_unit.dart';

part '_task_unit_/_form_model_load_data_task_unit.dart';

part '_task_unit_/_form_model_save_form_task_unit.dart';

part '_task_unit_/_form_view_change_task_unit.dart';

part '_task_unit_/_scalar_load_extra_data_quick_action_task_unit.dart';

part '_task_unit_/_scalar_query_task_unit.dart';

part '_task_unit_/_storage_silent_action_task_unit.dart';

part '_ui_/__refreshable_widget.dart';

part '_ui_/__refreshable_widget_state.dart';

part '_ui_/_activity_fragment_view.dart';

part '_ui_/_activity_fragment_view_builder.dart';

part '_ui_/_hook_fragment_view.dart';

part '_ui_/_hook_fragment_view_builder.dart';

part '_ui_/_block_control_bar.dart';

part '_ui_/_block_control_bar_config.dart';

part '_ui_/_block_fragment_view.dart';

part '_ui_/_block_fragment_view_builder.dart';

part '_ui_/_block_item_detail_view.dart';

part '_ui_/_block_item_detail_view_builder.dart';

part '_ui_/_block_items_view.dart';

part '_ui_/_block_items_view_builder.dart';

part '_ui_/_control_bar_button.dart';

part '_ui_/_dev_container.dart';

part '_ui_/_filter_panel.dart';

part '_ui_/_filter_panel_builder.dart';

part '_ui_/_sort_panel_builder.dart';

part '_ui_/_sort_panel.dart';

part '_ui_/_form_view.dart';

part '_ui_/_form_view_builder.dart';

part '_ui_/_logged_in_user_builder.dart';

part '_ui_/_notification_button_builder.dart';

part '_ui_/_block_number_pagination.dart';

part '_ui_/_block_pagination.dart';

part '_ui_/_quick_suggestion_bar.dart';

part '_ui_/_quick_suggestion_button.dart';

part '_ui_/_refreshable_neutral_view.dart';

part '_ui_/_refreshable_neutral_view_builder.dart';

part '_ui_/_scalar_value_view.dart';

part '_ui_/_scalar_value_view_builder.dart';

part '_ui_/_scalar_fragment_view.dart';

part '_ui_/_scalar_fragment_view_builder.dart';

part '_ui_/_task_progress_view_builder.dart';

part '_ui_/_x_state.dart';

part '_ui_com_/__ui_components.dart';

part '_ui_com_/_activity_ui_components.dart';

part '_ui_com_/_block_ui_components.dart';

part '_ui_com_/_filter_ui_components.dart';

part '_ui_com_/_hook_ui_components.dart';

part '_ui_com_/_sort_ui_components.dart';

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

class _HookAnnotation {
  const _HookAnnotation();
}

class _ActivityAnnotation {
  const _ActivityAnnotation();
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

class _BlockSetItemAsCurrentAnnotation {
  const _BlockSetItemAsCurrentAnnotation();
}

class _BlockClearanceAnnotation {
  const _BlockClearanceAnnotation();
}

class _BlockClearCurrentItemAnnotation {
  const _BlockClearCurrentItemAnnotation();
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

class _FormModelLoadDataAnnotation {
  const _FormModelLoadDataAnnotation();
}

class _FormViewChangeAnnotation {
  const _FormViewChangeAnnotation();
}

class _SortModelChangedAnnotation {
  const _SortModelChangedAnnotation();
}

class _FilterModelLoadDataAnnotation {
  const _FilterModelLoadDataAnnotation();
}

class _FilterPanelChangeAnnotation {
  const _FilterPanelChangeAnnotation();
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

class _BlockQuickCreateMultiItemsActionAnnotation {
  const _BlockQuickCreateMultiItemsActionAnnotation();
}

class _BlockQuickItemUpdateActionAnnotation {
  const _BlockQuickItemUpdateActionAnnotation();
}

// ******* Block QuickAction (END) *********************************************
