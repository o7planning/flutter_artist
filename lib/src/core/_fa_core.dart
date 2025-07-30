import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:animated_tree_view/node/base/i_node.dart';
import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:animated_tree_view/tree_view/widgets/expansion_indicator.dart';
import 'package:animated_tree_view/tree_view/widgets/indent.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_artist/src/precheck/__chk_code_detail.dart';
import 'package:flutter_artist/src/precheck/block_quick_action_precheck.dart';
import 'package:flutter_artist/src/precheck/block_quick_create_item_precheck.dart';
import 'package:flutter_artist/src/precheck/block_quick_update_item_precheck.dart';
import 'package:flutter_artist/src/precheck/_check_allow.dart';
import 'package:flutter_artist/src/precheck/enter_form_fields_precheck.dart';
import 'package:flutter_artist/src/precheck/form_model_load_data_precheck.dart';
import 'package:flutter_artist/src/precheck/scalar_query_precheck.dart';
import 'package:flutter_artist/src/precheck/show_form_info_precheck.dart';
import 'package:flutter_artist/src/typedef/custom_confirmation.dart';
import 'package:flutter_artist/src/utils/_hive_utils.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart'
    as dialogs;
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:graphview/GraphView.dart';
import 'package:hive/hive.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:number_pagination/number_pagination.dart' as number_pagination;
import 'package:tabbed_view/tabbed_view.dart';
import 'package:uuid/uuid.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../action/base_action.dart';
import '../action/block_quick_action.dart';
import '../action/block_quick_child_block_items_action.dart';
import '../action/block_quick_create_item_action.dart';
import '../action/block_quick_create_multi_items_action.dart';
import '../action/block_quick_item_update_action.dart';
import '../action/scalar_load_extra_data_quick_action.dart';
import '../action/scalar_quick_action.dart';
import '../adapter/_flutter_artist_adapter.dart';
import '../adapter/_global_data_adapter.dart';
import '../adapter/_locale_adapter.dart';
import '../adapter/_logged_in_user_adapter.dart';
import '../adapter/_notification_adapter.dart';

import '../debug/code_flow/_code_flow_func_trace_info_view.dart';
import '../debug/code_flow/_code_flow_info_error_view.dart';
import '../debug/code_flow/_code_flow_method_args_view.dart';
import '../debug/code_flow/_code_flow_method_view.dart';
import '../debug/storage/_block_or_scalar.dart';
import 'annotation/annotation.dart';
import 'error_logger/_error_logger.dart';
import '../debug/filter/_filter_data_debug_view.dart';
import '../debug/storage/_shelf_structure_graph_view.dart';
import '../debug/storage/_storage_structure_view.dart';
import '../debug/filter/__filter_criteria_debug_view.dart';
import '../debug/utils/_dialog_size.dart';
import '../debug/dialog/_block_error_viewer_dialog.dart';
import '../debug/dialog/_code_flow_viewer_dialog.dart';
import '../debug/dialog/_dialog_constants.dart';
import '../debug/dialog/_filter_criteria_dialog.dart';
import '../debug/dialog/_filter_model_info_dialog.dart';
import '../debug/dialog/_form_error_viewer_dialog.dart';
import '../debug/dialog/_scalar_error_viewer_dialog.dart';
import '../enums/_action_confirmation_type.dart';
import '../enums/_action_result_state.dart';
import '../enums/_activity_hidden_behavior.dart';
import '../enums/_block_control_action_type.dart';
import '../enums/_block_error_method.dart';
import '../enums/_block_hidden_behavior.dart';
import '../enums/_block_refresh_item_mode.dart';
import '../enums/_code_flow_item_type.dart';
import '../enums/_code_flow_type.dart';
import '../enums/_current_item_selection_type.dart';
import '../enums/_data_mode.dart';
import '../enums/_data_state.dart';
import '../enums/_debug_cat.dart';
import '../enums/_filter_activity_type.dart';
import '../enums/_force_type.dart';
import '../enums/_form_action.dart';
import '../enums/_form_activity_type.dart';
import '../enums/_form_error_method.dart';
import '../enums/_form_mode.dart';
import '../enums/_item_creation_type.dart';
import '../enums/_list_behavior.dart';
import '../enums/_multi_opt_prop_reload.dart';
import '../enums/_nli_type.dart';
import '../enums/_post_query_behavior.dart';
import '../enums/_refreshable_widget_type.dart';
import '../enums/_scalar_control_action_type.dart';
import '../enums/_scalar_error_method.dart';
import '../enums/_scalar_hidden_behavior.dart';
import '../enums/_shelf_hidden_behavior.dart';
import '../enums/_show_mode.dart';
import '../enums/_sorting_direction.dart';
import '../enums/_task_type.dart';
import '../enums/after_quick_action.dart';
import '../error/_app_error_info.dart';
import '../error/_block_error_info.dart';
import '../error/_duplicate_filter_criterion_error.dart';
import '../error/_duplicate_form_prop_error.dart';
import '../error/_fatal_app_error.dart';
import '../error/_form_error_info.dart';
import '../error/_form_temp_error.dart';
import '../error/_scalar_error_info.dart';
import '../global/_global_data.dart';
import '../global/_notification_listener.dart';
import '../global/_notification_summary.dart';
import '../icon/icon_constants.dart';
import '../precheck/block_clearance_precheck.dart';
import '../precheck/block_form_enablement_chk.dart';
import '../precheck/block_form_reset_precheck.dart';
import '../precheck/block_form_save_precheck.dart';
import '../precheck/block_item_creation_precheck.dart';
import '../precheck/block_item_curr_selection_precheck.dart';
import '../precheck/block_item_deletion_precheck.dart';
import '../precheck/block_item_edit_precheck.dart';
import '../precheck/block_query_precheck.dart';
import '../utils/_compare_utils.dart';
import '../utils/_string_utils.dart';
import '../widgets/_custom_app_container.dart';
import '../widgets/_simple_accordion.dart';
import '../widgets/_simple_accordion_section.dart';
import '../debug/dialog/_error_log_viewer_dialog.dart';
import '../debug/dialog/_form_data_info_dialog.dart';
import '../debug/dialog/_storage_dialog.dart';
import '../debug/storage/widgets/_shelf_info_view.dart';
import '../utils/_debug_print.dart';

part '_task_result_/_task_result.dart';

part '_task_result_/_block_clearance_result.dart';

part '_task_result_/_form_model_load_data_result.dart';

part '_task_result_/_block_item_creation_result.dart';

part '_task_result_/_block_quick_update_item_result.dart';

part '_task_result_/_block_quick_action_result.dart';

part '_task_result_/_block_quick_create_item_result.dart';

part '_task_result_/_block_item_curr_selection_result.dart';

part '_task_result_/_block_item_deletion_result.dart';

part '_task_result_/_block_items_deletion_result.dart';

part '_task_result_/_block_query_result.dart';

part '_task_result_/_form_save_result.dart';

part '_task_result_/_scalar_query_result.dart';

part '_code_flow_/_code_flow_item.dart';

part '../debug/code_flow/_code_flow_item_view.dart';

part '_code_flow_/_code_flow_logger.dart';

part '_code_flow_/_func_call_info.dart';

part '_coordinator_/_coordinator.dart';

part '_coordinator_/_coordinator_config.dart';

part '_core_/_actionable.dart';

part '_core_/_activity.dart';

part '_core_/_activity_config.dart';

part '_core_/_app_utils.dart';

part '_core_/_block.dart';

part '_core_/_block_config.dart';

part '_core_/_block_data.dart';

part '_core_/_block_internal_broadcast.dart';

part '_core_/_block_internal_event_reaction.dart';

part '_core_/_block_outside_broadcast.dart';

part '_core_/_block_outside_event_reaction.dart';

part '_core_/_current_couple_item.dart';

part '_core_/_default_filter_model.dart';

part '_core_/_error_listener.dart';

part '_core_/_executor.dart';

part '_core_/_extra_form_input.dart';

part '_core_/_filter_criteria.dart';

part '_core_/_filter_input.dart';

part '_core_/_filter_model.dart';

part '_core_/_filter_model_config.dart';

part '_core_/_form_leave_safely.dart';

part '_core_/_form_model.dart';

part '_core_/_form_model_config.dart';

part '_core_/_item_sort_criteria.dart';

part '_core_/_logging.dart';

part '_core_/_scalar.dart';

part '_core_/_scalar_config.dart';

part '_core_/_scalar_data.dart';

part '_core_/_scalar_internal_event_reaction.dart';

part '_core_/_scalar_outside_event_reaction.dart';

part '_core_/_shelf.dart';

part '_core_/_shelf_block_scalar_type.dart';

part '_core_/_shelf_structure.dart';

part '_core_/_single_item_block.dart';

part '_core_/_sort_criterion.dart';

part '_core_/_storage.dart';

part '_core_/_suggested_selection.dart';

part '_core_/_typedef.dart';

part '_core_/_x_base.dart';

part '_core_query_/_block_opt.dart';

part '_core_query_/_filter_model_opt.dart';

part '_core_query_/_form_model_opt.dart';

part '_core_query_/_lazy_objects.dart';

part '_core_query_/_scalar_and_block_list.dart';

part '_core_query_/_scalar_opt.dart';

part '_core_query_/_x_block.dart';

part '_core_query_/_x_filter_model.dart';

part '_core_query_/_x_form_model.dart';

part '_core_query_/_x_scalar.dart';

part '_core_query_/_x_shelf.dart';

part '_core_state_/_force_reload_form_calculator.dart';

part '_core_state_/_force_reload_item_calculator.dart';

part '_core_state_/_force_reload_state.dart';

part '_dialog_/_ui_components_dialog.dart';

part '_fa_.dart';

part '_filter_criterion_/_calculated_criterion.dart';

part '_filter_criterion_/_criterion.dart';

part '_filter_criterion_/_filter_criteria_structure.dart';

part '_filter_criterion_/_multi_opt_criterion.dart';

part '_filter_criterion_/_simple_criterion.dart';

part '_form_prop_/_calculated_prop.dart';

part '_form_prop_/_form_props_structure.dart';

part '_form_prop_/_multi_opt_prop.dart';

part '_form_prop_/_prop.dart';

part '_form_prop_/_simple_prop.dart';

part '_form_prop_/_value_wrap.dart';

part '_globals_/_globals_manager.dart';

part '_locale_/_locale_manager.dart';

part '_login_/_login_activity_base.dart';

part '_login_/_simple_login_view.dart';

part '_notification_/_notification_engine.dart';

part '_task_unit_/__task_unit.dart';

part '_task_unit_/__resulted_task_unit.dart';

part '_task_unit_/__task_unit_queue.dart';

part '_task_unit_/_block_clear_current_task_unit.dart';

part '_task_unit_/_block_delete_item_task_unit.dart';

part '_task_unit_/_block_prepare_form_to_create_item_task_unit.dart';

part '_task_unit_/_block_query_task_unit.dart';

part '_task_unit_/_block_quick_action_task_unit.dart';

part '_task_unit_/_block_quick_child_block_items_task_unit.dart';

part '_task_unit_/_block_quick_create_item_task_unit.dart';

part '_task_unit_/_block_quick_create_multi_items_task_unit.dart';

part '_task_unit_/_block_quick_update_item_task_unit.dart';

part '_task_unit_/_block_select_as_current_task_unit.dart';

part '_task_unit_/_filter_view_change_task_unit.dart';

part '_task_unit_/_form_model_auto_enter_form_fields_task_unit.dart';

part '_task_unit_/_form_model_load_form_task_unit.dart';

part '_task_unit_/_form_model_save_form_task_unit.dart';

part '_task_unit_/_form_view_change_task_unit.dart';

part '_task_unit_/_scalar_load_extra_data_quick_action_task_unit.dart';

part '_task_unit_/_scalar_query_task_unit.dart';

part '_task_unit_/_scalar_quick_action_task_unit.dart';

part '_ui_/__error_widget_utils.dart';

part '_ui_/_activity_fragment_widget_builder.dart';

part '_ui_/_block_control_bar.dart';

part '_ui_/_block_fragment_view.dart';

part '_ui_/_block_fragment_view_builder.dart';

part '_ui_/_block_item_view.dart';

part '_ui_/_block_items_view.dart';

part '_ui_/_block_items_view_builder.dart';

part '_ui_/_control_bar_button.dart';

part '_ui_/_dev_container.dart';

part '_ui_/_filter_view.dart';

part '_ui_/_filter_view_builder.dart';

part '_ui_/_form_view.dart';

part '_ui_/_form_view_builder.dart';

part '_ui_/_labeled_radio.dart';

part '_ui_/_logged_in_user_builder.dart';

part '_ui_/_notification_button_builder.dart';

part '_ui_/_number_pagination_view.dart';

part '_ui_/_pagination_view.dart';

part '_ui_/_refreshable_neutral_view.dart';

part '_ui_/_refreshable_neutral_view_builder.dart';

part '_ui_/_refreshable_widget.dart';

part '_ui_/_refreshable_widget_state.dart';

part '_ui_/_scalar_fragment_view.dart';

part '_ui_/_scalar_fragment_view_builder.dart';

part '_ui_/_sort_options.dart';

part '_ui_/_sort_options_bar.dart';

part '_ui_/_sort_options_dropdown.dart';

part '_ui_/_task_progress_view_builder.dart';

part '_ui_/_x_state.dart';

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

part '_utils_/_json_utils.dart';

part '_utils_/_patch_utils.dart';

part '_utils_/_register_error_utils.dart';

part '../utils/_text_size_utils.dart';

part '_utils_/_utils.dart';

part '_utils_/_visibility_detector_utils.dart';

part '_xdata_/_x_data.dart';

part '_xdata_/_x_list.dart';

part '_xdata_/_x_tree.dart';

// *****************************************************************************
// *****************************************************************************

class _AbstractMethodAnnotation {
  const _AbstractMethodAnnotation();
}

class _RootMethodAnnotation {
  const _RootMethodAnnotation();
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
  const _ImportantMethodAnnotation();
}

class _MayThrowFormTempErrorAnnotation {
  const _MayThrowFormTempErrorAnnotation();
}

class _BlockPrepareFormToCreateItemAnnotation {
  const _BlockPrepareFormToCreateItemAnnotation();
}

class _BlockSelectItemAsCurrentAnnotation {
  const _BlockSelectItemAsCurrentAnnotation();
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

class _BlockRefreshAndSelectFirstItemAsCurrentAnnotation {
  const _BlockRefreshAndSelectFirstItemAsCurrentAnnotation();
}

class _BlockRefreshAndSelectNextItemAsCurrentAnnotation {
  const _BlockRefreshAndSelectNextItemAsCurrentAnnotation();
}

class _BlockRefreshAndSelectPreviousItemAsCurrentAnnotation {
  const _BlockRefreshAndSelectPreviousItemAsCurrentAnnotation();
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

// ******* Scalar QuickAction (START) ******************************************

class _ScalarQuickActionAnnotation {
  const _ScalarQuickActionAnnotation();
}

class _ScalarLoadExtraDataQuickActionAnnotation {
  const _ScalarLoadExtraDataQuickActionAnnotation();
}

// ******* Scalar QuickAction (END) ********************************************

// ******* Block QuickAction (START) *******************************************

class _BlockQuickActionAnnotation {
  const _BlockQuickActionAnnotation();
}

class _BlockQuickCreateItemActionAnnotation {
  const _BlockQuickCreateItemActionAnnotation();
}

class _BlockQuickCreateMultiItemsActionAnnotation {
  const _BlockQuickCreateMultiItemsActionAnnotation();
}

class _BlockQuickUpdateItemActionAnnotation {
  const _BlockQuickUpdateItemActionAnnotation();
}

class _BlockQuickChildBlockItemsActionAnnotation {
  const _BlockQuickChildBlockItemsActionAnnotation();
}

// ******* Block QuickAction (END) *********************************************
